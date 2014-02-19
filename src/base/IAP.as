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
		//private var iOSiap:Object;
		private var iOSiap:StoreKitExt;
		private var iosRequestInfoInProgress:Boolean;
		private var iosRestoreInProgress:Boolean;
		//private var iosProductList:Vector.<Object>;
		private var iosProductList:Vector.<ProductDetail>;
		private var iosReceiptList:Vector.<String>;	
		private const IOS_RECEIPT_PRE:String = "iosPre";	
		
		private var androidIAP:InAppPurchase;
		private var androidReadyToPurchase:Boolean;
		
		private var onPurchaseComplete:Function;
		private var onRestoreComplete:Function;
		
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
		
		private function onAndroidRestoreError(e:InAppPurchaseEvent):void 
		{
			 var purchase:InAppPurchaseDetails = androidIAP.getPurchaseDetails(Constants.ANDROID_PRODUCT_IDS[0]);
			 var skuDetails1:InAppSkuDetails = androidIAP.getSkuDetails(Constants.ANDROID_PRODUCT_IDS[0]		);

		}
		
		private function onAndroidRestoreSuccess(e:InAppPurchaseEvent):void 
		{
			
		}
		
		private function onAndroidPurchaseError(e:InAppPurchaseEvent):void 
		{
			
		}
		
		private function onAndroidPurchaseSuccess(e:InAppPurchaseEvent):void 
		{
			e.data; // product id
		}
		
		private function onAndroidInitError(e:InAppPurchaseEvent):void 
		{			
			androidReadyToPurchase = false;
		}
		
		private function onAndroidInitSuccess(e:InAppPurchaseEvent):void 
		{
			androidReadyToPurchase = true;
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
			if (Util.isAndroid)
			{				
				androidIAP.purchase(productID, InAppPurchaseDetails.TYPE_INAPP);

			}
		}
		
		//private function onIOSTransactionDone(e:Event):void 
		private function onIOSTransactionDone(e:StoreKitEvent):void 
		{
			iosReceiptList = iOSiap.getReceptListAfterTransaction();
			saveIOSReceiptsList();
			if (iosRestoreInProgress)
			{
				iosRestoreInProgress = false;				
				if(onRestoreComplete is Function)
					onRestoreComplete();
			}
			else
			{
				if(onPurchaseComplete is Function)
					onPurchaseComplete();
			}
		}
		
		private function saveIOSReceiptsList():void
		{
			var count:int = iosReceiptList.length;
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
				for (var i:int = 0; i < iosReceiptList.length; i++) 
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
			
		}
		
		private function onIOSProductInfoDone(e:StoreKitEvent):void 
		//private function onIOSProductInfoDone(e:Event):void 
		{
			iosProductList = iOSiap.getProductsAfterRequestData();
			iosRequestInfoInProgress = false;			
		}
	}

}