package base 
{		
	import com.fc.ProductDetail;
	import com.fc.StoreKitEvent;
	import com.fc.StoreKitExt;
	import com.pozirk.payment.android.InAppPurchase;
	import com.pozirk.payment.android.InAppPurchaseDetails;
	import com.pozirk.payment.android.InAppPurchaseEvent;
	import com.pozirk.payment.android.InAppSkuDetails;
	import fasthand.gui.ConfirmDlg;
	import fasthand.gui.InfoDlg;
	import flash.events.Event;
	import starling.core.Starling;
	/**
	 * In app purchase support
	 * 1. init in app purchase when app launch
	 * 2. make payment or restore
	 * 3. when done, call checkBought();
	 * @author ndp
	 */
	public class IAP 
	{		
		private var iOSiap:StoreKitExt;
		private var iosRequestInfoInProgress:Boolean;
		private var iosRestoreInProgress:Boolean;		
		private var iosProductList:Vector.<ProductDetail>;
		private var iosReceiptList:Vector.<String>;	
		private const IOS_RECEIPT_PRE:String = "iosPre";	
		
		private var androidIAP:InAppPurchase;
		private var androidReadyToPurchase:Boolean; 
		private var androidBoughtList:Vector.<String>;
		
		private var onPurchaseComplete:Function;
		private var onRestoreComplete:Function;
		private var androidInitErrorMsg:String;
		
		public function IAP() 
		{								
		}
		
		public function get canPurchase():Boolean
		{
			var ret:Boolean = false;
			if(Util.isIOS)
			{
				ret = iOSiap.canMakePurchase();
				if (!ret)
				{									
					var infoD:InfoDlg = Factory.getInstance(InfoDlg);
					infoD.text = LangUtil.getText("enableInAppPurchaseIOS");
					infoD.callback = null;
					PopupMgr.addPopUp(infoD);
				}
			}	
			else if (Util.isAndroid)
			{
				ret = true;
			}
			return ret;
		}
		
		/**
		 * init in-app purchase service
		 * @param	param [prodID, prodID...] (for IOS) or {publicKey} (for Android)
		 */
		public function initInAppPurchase(param:*):void 
		{
			if (Util.isIOS)
			{
				iOSiap = StoreKitExt.instance;	
				iOSiap.initExtension();
				loadIOSReceiptList();
				iOSiap.addEventListener(StoreKitEvent.PRODUCT_DATA_AVAILABLE, onIOSProductInfoDone);
				iOSiap.addEventListener(StoreKitEvent.RECEIPT_DATA_AVAILABLE, onIOSTransactionDone);
				if (canPurchase)
				{
					iosRequestInfoInProgress = true;
					iOSiap.requestProductData(Constants.IOS_PRODUCT_IDS);					
				}
			}
			else if(Util.isAndroid)
			{			
				androidIAP = new InAppPurchase();
				loadAnroidPurchaseStates();
				androidIAP.init(param);
				androidIAP.addEventListener(InAppPurchaseEvent.INIT_SUCCESS, onAndroidInitSuccess);
				androidIAP.addEventListener(InAppPurchaseEvent.INIT_ERROR, onAndroidInitError);
				androidIAP.addEventListener(InAppPurchaseEvent.PURCHASE_SUCCESS, onAndroidPurchaseSuccess);
				androidIAP.addEventListener(InAppPurchaseEvent.PURCHASE_ALREADY_OWNED, onAndroidPurchaseSuccess);
				androidIAP.addEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onAndroidPurchaseError);
				androidIAP.addEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onAndroidRestoreSuccess);
				androidIAP.addEventListener(InAppPurchaseEvent.RESTORE_ERROR, onAndroidRestoreError);
				androidReadyToPurchase = false;
			}
		}	
		
		private function loadAnroidPurchaseStates():void 
		{
			
		}
		
		private function onAndroidRestoreError(e:InAppPurchaseEvent):void 
		{			 
			FPSCounter.log("restore error:", e.data);
			if(onRestoreComplete is Function)
			{
				onRestoreComplete();
				onRestoreComplete = null;
			}
		}
		
		private function onAndroidRestoreSuccess(e:InAppPurchaseEvent):void 
		{
			var purchase:InAppPurchaseDetails = androidIAP.getPurchaseDetails(Constants.ANDROID_PRODUCT_IDS[0]);
			if(purchase)
				FPSCounter.log(", order id ", purchase._orderId, ", purchase state", purchase._purchaseState, ", purchase time", purchase._time, ", purchase sku", purchase._sku);
			FPSCounter.log("restore done");
			androidBoughtList = new Vector.<String>();
			var len:int = Constants.ANDROID_PRODUCT_IDS.length;
			for (var i:int = 0; i < len; i++) 
			{
				
			}
			saveAnroidPurchaseStates();
			if(onRestoreComplete is Function)
			{
				onRestoreComplete();
				onRestoreComplete = null;
			}
		}
		
		private function saveAnroidPurchaseStates():void 
		{
			
		}
		
		private function onAndroidPurchaseError(e:InAppPurchaseEvent):void 
		{
			FPSCounter.log("iap purchase error:",e.data);
			if(onPurchaseComplete is Function)
			{
				onPurchaseComplete();
				onPurchaseComplete = null;
			}
		}
		
		private function onAndroidPurchaseSuccess(e:InAppPurchaseEvent):void 
		{
			if (androidBoughtList.indexOf(e.data) > -1)
				return;
			androidBoughtList.push(e.data);
			var purchase:InAppPurchaseDetails = androidIAP.getPurchaseDetails(Constants.ANDROID_PRODUCT_IDS[0]);
			FPSCounter.log(", order id ", purchase._orderId, ", purchase state", purchase._purchaseState, ", purchase time", purchase._time, ", purchase sku", purchase._sku);
			if(onPurchaseComplete is Function)
			{
				onPurchaseComplete();
				onPurchaseComplete = null;
			}
		}
		
		private function onAndroidInitError(e:InAppPurchaseEvent):void 
		{			
			androidReadyToPurchase = false;
			androidInitErrorMsg = e.data;
			FPSCounter.log("IAP:", e.data);	
		}
		
		private function onAndroidInitSuccess(e:InAppPurchaseEvent):void 
		{
			androidReadyToPurchase = true;
			FPSCounter.log("IAP init success");	
		}
		
		public function makePurchase(productID:String, onPurchaseCallback:Function):void
		{
			this.onPurchaseComplete = onPurchaseCallback;
			if (Util.isIOS)
			{
				if (iosRequestInfoInProgress)
				{
					Starling.juggler.delayCall(makePurchase, 1);
					return;
				}
				var pIdx:int = 0;
				for (var i:int = 0; i < iosProductList.length; i++) 
				{
					if (productID == iosProductList[i].productID)
					{
						pIdx = i;
						break;
					}
				}
				iOSiap.makePayment(pIdx);
			}
			else if (Util.isAndroid)
			{				
				if(androidReadyToPurchase)
				{
					androidIAP.purchase(productID, InAppPurchaseDetails.TYPE_INAPP);
				}
				else
				{
					var infoD:InfoDlg = Factory.getInstance(InfoDlg);
					infoD.text = LangUtil.getText("cannotPurchase") + androidInitErrorMsg;
					PopupMgr.flush();
					PopupMgr.addPopUp(infoD);
				}
			}
		}
		
		//private function onIOSTransactionDone(e:Event):void 
		private function onIOSTransactionDone(e:StoreKitEvent):void 
		{
			try
			{
				FPSCounter.log("transaction complete");
				iosReceiptList = iOSiap.getReceptListAfterTransaction();
				saveIOSReceiptsList();						
				if(onRestoreComplete is Function)
				{
					onRestoreComplete();			
					iosRestoreInProgress = false;
				}
				if(onPurchaseComplete is Function)
					onPurchaseComplete();
				
			}
			catch (err:Error)
			{
				FPSCounter.log(err.getStackTrace());
			}
		}
		
		private function saveIOSReceiptsList():void
		{		
			var count:int = iosReceiptList ? iosReceiptList.length : 0;
			Util.setPrivateValue(IOS_RECEIPT_PRE + "count", count.toString());
			for (var i:int = 0; i < count; i++) 
			{
				Util.setPrivateValue(IOS_RECEIPT_PRE + "receipt" + i, iosReceiptList[i]);
			}					
		}
		
		private function loadIOSReceiptList():void
		{			
			var countStr:String = Util.getPrivateKey(IOS_RECEIPT_PRE + "count");		
			var count:int = parseInt(countStr);
			
			if (isNaN(count))
				count = 0;
			iosReceiptList = new Vector.<String>();				
			for (var i:int = 0; i < count; i++) 
			{
				iosReceiptList[i] = Util.getPrivateKey(IOS_RECEIPT_PRE + "receipt" + i);				
			}
			
		}
		
		public function checkBought(productID:String):Boolean
		{
			if (Util.isIOS)
			{
				var count:int = iosReceiptList ? iosReceiptList.length : 0;
				for (var i:int = 0; i < count; i++) 
				{
					if (iOSiap.hasBought(iosReceiptList[i]) == productID)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public function restorePurchases(onRestoreComplete:Function):void
		{			
			this.onRestoreComplete = onRestoreComplete;
			if(Util.isIOS)
			{
				iOSiap.restoreProducts();
				iosRestoreInProgress = true;
			}
			else if(Util.isAndroid)
			{
				FPSCounter.log("start restore purchase");
				androidIAP.restore();
			}
			
		}
		
		private function onIOSProductInfoDone(e:StoreKitEvent):void 
		//private function onIOSProductInfoDone(e:Event):void 
		{
			iosProductList = iOSiap.getProductsAfterRequestData();
			iosRequestInfoInProgress = false;			
		}
	}

}