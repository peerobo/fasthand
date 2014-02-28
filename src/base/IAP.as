package base 
{		
	CONFIG::isIOS{		
		import com.fc.ProductDetail;
		import com.fc.StoreKitEvent;
		import com.fc.StoreKitExt;
	}
	CONFIG::isAndroid{
		import com.pozirk.payment.android.InAppPurchase;
		import com.pozirk.payment.android.InAppPurchaseDetails;
		import com.pozirk.payment.android.InAppPurchaseEvent;
		import com.pozirk.payment.android.InAppSkuDetails;
	}
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
		CONFIG::isIOS{
			private var iOSiap:StoreKitExt;
			private var iosRequestInfoInProgress:Boolean;
			private var iosRestoreInProgress:Boolean;		
			private var iosProductList:Vector.<ProductDetail>;
			private var iosReceiptList:Vector.<String>;	
			private const IOS_RECEIPT_PRE:String = "iosPre";	
		}
		
		CONFIG::isAndroid{
			private var androidIAP:InAppPurchase;
			private var androidReadyToPurchase:Boolean; 
			private var androidBoughtList:Vector.<String>;
			private var androidInitErrorMsg:String;
		}
		
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
				ret = false;
				CONFIG::isIOS{
					ret = iOSiap.canMakePurchase();
					if (!ret)
					{									
						var infoD:InfoDlg = Factory.getInstance(InfoDlg);
						infoD.text = LangUtil.getText("enableInAppPurchaseIOS");
						infoD.callback = null;
						PopupMgr.addPopUp(infoD);
					}
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
				trace("init iap ios");
				CONFIG::isIOS{
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
			}
			else if(Util.isAndroid)
			{	
				FPSCounter.log("init iap android");
				CONFIG::isAndroid{
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
		}					
		
		CONFIG::isAndroid{
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
				FPSCounter.log("restore done");
				androidBoughtList = new Vector.<String>();
				var len:int = Constants.ANDROID_PRODUCT_IDS.length;
				for (var i:int = 0; i < len; i++) 
				{
					var purchase:InAppPurchaseDetails = androidIAP.getPurchaseDetails(Constants.ANDROID_PRODUCT_IDS[i]);
					if(purchase)
					{						
						androidBoughtList.push(Constants.ANDROID_PRODUCT_IDS[i]);
					}
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
				var len:int = androidBoughtList.length;				
				for (var i:int = 0; i < len; i++) 
				{
					var key:String = Constants.ANDROID_PRODUCT_IDS[i];
					var value:String = (5 + int(Math.random() * 5)).toString();
					Util.setPrivateValue(key, value);
					FPSCounter.log(key, value);
				}
			}
			
			private function loadAnroidPurchaseStates():void 
			{
				androidBoughtList = new Vector.<String>();
				var len:int = Constants.ANDROID_PRODUCT_IDS.length;
				for (var i:int = 0; i < len; i++) 
				{
					var key:String = Constants.ANDROID_PRODUCT_IDS[i];
					var value:int = parseInt(Util.getPrivateKey(key));
					if (!isNaN(value) && value >= 5 && value < 10)
					{	
						androidBoughtList.push(Constants.ANDROID_PRODUCT_IDS[i]);						
					}
					FPSCounter.log(key, value);
				}
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
				FPSCounter.log("IAP purchase ok");	
				if (androidBoughtList.indexOf(e.data) > -1)
				{
					if(onPurchaseComplete is Function)
					{
						onPurchaseComplete();
						onPurchaseComplete = null;
					}
					return;				
				}
				FPSCounter.log(e.data);
				androidBoughtList.push(e.data);				
				saveAnroidPurchaseStates();
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
		}
		
		public function makePurchase(productID:String, onPurchaseCallback:Function):void
		{
			this.onPurchaseComplete = onPurchaseCallback;
			if (Util.isIOS)
			{
				trace("purchase ios");
				CONFIG::isIOS{
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
			}
			else if (Util.isAndroid)
			{	
				trace("purchase android");
				CONFIG::isAndroid{
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
		}
		
		CONFIG::isIOS{
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
			
			private function onIOSProductInfoDone(e:StoreKitEvent):void 		
			{
				iosProductList = iOSiap.getProductsAfterRequestData();
				iosRequestInfoInProgress = false;			
			}
		}
		
		public function checkBought(productID:String):Boolean
		{
			if (Util.isIOS)
			{
				trace("check bought ios");
				CONFIG::isIOS{
					var count:int = iosReceiptList ? iosReceiptList.length : 0;
					for (var i:int = 0; i < count; i++) 
					{
						if (iOSiap.hasBought(iosReceiptList[i]) == productID)
						{
							return true;
						}
					}
				}
			}
			else if (Util.isAndroid)
			{
				trace("check bought android");
				CONFIG::isAndroid{
					return androidBoughtList.indexOf(productID) > -1;
				}
			}
			return false;
		}
		
		public function restorePurchases(onRestoreComplete:Function):void
		{			
			this.onRestoreComplete = onRestoreComplete;
			if(Util.isIOS)
			{
				trace("restore ios");
				CONFIG::isIOS{
					iOSiap.restoreProducts();
					iosRestoreInProgress = true;
				}
			}
			else if(Util.isAndroid)
			{
				trace("restore android");
				CONFIG::isAndroid{
					FPSCounter.log("start restore purchase");
					androidIAP.restore();
				}
			}
			
		}
		
		
	}

}