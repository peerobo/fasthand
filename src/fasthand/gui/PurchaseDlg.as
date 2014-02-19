package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.GlobalInput;
	import base.IAP;
	import base.LangUtil;
	import base.PopupMgr;	
	import comp.LoadingIcon;
	import fasthand.FasthandUtil;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class PurchaseDlg extends BaseJsonGUI 
	{
		public var yesBt:BaseButton;
		public var noBt:BaseButton;
		public var purchaseBt:BaseButton;
		public var contentTxt:BaseBitmapTextField;
		
		public function PurchaseDlg() 
		{
			super("PurchaseDlg");
			
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			var rpl:Array = ["@num", "@price"];
			var rplW:Array = [(FasthandUtil.getListCat().length - Constants.CAT_FREE_NUM).toString(), Constants.PRICE_GAME.toString()];
			var colors:Array = [0xFFFF80, 0xFF8080]
			Util.g_replaceAndColorUp(contentTxt, rpl, rplW, colors);
			
			noBt.setCallbackFunc(onCancel);
			yesBt.setCallbackFunc(onYes);
			purchaseBt.setCallbackFunc(onRestorePurchase);
			
			var iap:IAP = Factory.getInstance(IAP);
			yesBt.isDisable = !iap.canPurchase;
		}
		
		private function onRestorePurchase():void 
		{
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			globalInput.disable = true;
			PopupMgr.removePopup(this);
			PopupMgr.addPopUp(Factory.getInstance(LoadingIcon));
			var iap:IAP = Factory.getInstance(IAP);
			iap.restorePurchases(onTransactionComplete);
		}
		
		private function onTransactionComplete():void 
		{
			var iap:IAP = Factory.getInstance(IAP);			
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			globalInput.disable = false;
			PopupMgr.removePopup(Factory.getInstance(LoadingIcon));
			if (iap.checkBought(Util.isIOS ? Constants.IOS_PRODUCT_IDS[0] : ""))
			{				
				var infoD:InfoDlg = Factory.getInstance(InfoDlg);
				infoD.text = LangUtil.getText("IAPComplete");
				PopupMgr.addPopUp(infoD);
				FPSCounter.log("show Popup");
			}
			else
			{
				PopupMgr.addPopUp(this);
			}
		}
		
		private function onYes():void 
		{
			var iap:IAP = Factory.getInstance(IAP);
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			globalInput.disable = true;
			PopupMgr.removePopup(this);
			PopupMgr.addPopUp(Factory.getInstance(LoadingIcon));
			iap.makePurchase(Util.isIOS ? Constants.IOS_PRODUCT_IDS[0] : Constants.ANDROID_PRODUCT_IDS[0], onTransactionComplete);
		}
			
		private function onCancel():void 
		{
			PopupMgr.removePopup(this);
		}
		
	}

}