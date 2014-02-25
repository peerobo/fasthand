package fasthand.gui
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.GameSave;
	import base.IAP;
	import base.LangUtil;
	import base.PopupMgr;
	import base.ScreenMgr;
	import comp.LoadingIcon;
	import fasthand.FasthandUtil;
	import fasthand.screen.CategoryScreen;
	import res.Asset;
	import res.ResMgr;
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
		
		private var state:int = -1;
		private const PURCHASE:int = 0;
		private const RESTORE:int = 1;
		
		public function PurchaseDlg()
		{
			super("PurchaseDlg");
			var gameSave:GameSave = Factory.getInstance(GameSave);
			gameSave.registerValidate(savePurchaseForResuming);
		}
		
		private function savePurchaseForResuming():void
		{
			PopupMgr.removePopup(this);
			if (ScreenMgr.currScr is CategoryScreen && state > -1)
			{
				var gameSave:GameSave = Factory.getInstance(GameSave);
				var data:Object = gameSave.data;
				if (state == PURCHASE)
					data.state = GameSave.STATE_APP_PURCHASE;
				else if (state == RESTORE)
					data.state = GameSave.STATE_APP_RESTORE;
				else
					data.state = GameSave.STATE_APP_LAUNCH;
			}
		
		}
		
		override public function onAdded(e:Event):void
		{
			super.onAdded(e);
			state = -1;
			var rpl:Array = ["@num", "@price"];
			var rplW:Array = [(FasthandUtil.getListCat().length - Constants.CAT_FREE_NUM).toString(), Constants.PRICE_GAME.toString()];
			var colors:Array = [0xFFFF80, 0xFF8080]
			Util.g_replaceAndColorUp(contentTxt, rpl, rplW, colors);
			
			noBt.setCallbackFunc(onCancel);
			yesBt.setCallbackFunc(onPurchase);
			purchaseBt.setCallbackFunc(onRestorePurchase);
			
			var iap:IAP = Factory.getInstance(IAP);
			purchaseBt.isDisable = yesBt.isDisable = !iap.canPurchase;
		}
		
		public function onRestorePurchase():void
		{			
			PopupMgr.removePopup(this);
			PopupMgr.addPopUp(Factory.getInstance(LoadingIcon));
			var iap:IAP = Factory.getInstance(IAP);
			iap.restorePurchases(onTransactionComplete);
			state = RESTORE;
		}
		
		public function onPurchase():void
		{		
			var iap:IAP = Factory.getInstance(IAP);
			PopupMgr.removePopup(this);
			PopupMgr.addPopUp(Factory.getInstance(LoadingIcon));
			iap.makePurchase(Util.isIOS ? Constants.IOS_PRODUCT_IDS[0] : Constants.ANDROID_PRODUCT_IDS[0], onTransactionComplete);
			state = PURCHASE;
		}
		
		public function onTransactionComplete():void
		{
			var iap:IAP = Factory.getInstance(IAP);			
			PopupMgr.removePopup(Factory.getInstance(LoadingIcon));
			if (iap.checkBought(Util.isIOS ? Constants.IOS_PRODUCT_IDS[0] : Constants.ANDROID_PRODUCT_IDS[0]))
			{
				var infoD:InfoDlg = Factory.getInstance(InfoDlg);
				infoD.text = LangUtil.getText("IAPComplete");
				CategoryScreen.fullApp = true;
				infoD.callback = onCloseIAPInfoDlg;
				PopupMgr.addPopUp(infoD);
				state = -1;
			}
			else
			{
				PopupMgr.addPopUp(this);
			}
		}
		
		private function onCloseIAPInfoDlg():void
		{
			var downloadDLC:DLCDlg = Factory.getInstance(DLCDlg);
			PopupMgr.addPopUp(downloadDLC);
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			var arr:Array = [];
			var listCat:Array = FasthandUtil.getListCat();
			var len:int = listCat.length;
			for (var i:int = Constants.CAT_FREE_NUM; i < len; i++)
			{
				arr = arr.concat(Asset.getExtraContent(listCat[i]));
			}
			resMgr.getExtraContent(arr, onExtraContentDownloadCompleted, onAdvanceExtraContent);
		}
		
		private function onAdvanceExtraContent(idx:int):void
		{
			var idxCat:int = idx / 3 + 6;
			var idxFile:int = idx % 3;
			var listCat:Array = FasthandUtil.getListCat();
			var catLen:int = listCat.length - 6;
			var str:String = LangUtil.getText("extraContentLoad");
			str = Util.replaceStr(str, ["@cat", "@idxCat", "@totalCat", "@idxFile", "@totalFile"], [LangUtil.getText(listCat[idxCat]), "" + (idxCat - 5), "" + catLen, "" + (idxFile + 1), "3"]);
			var downloadDLC:DLCDlg = Factory.getInstance(DLCDlg);
			downloadDLC.msg = str;
		}
		
		private function onExtraContentDownloadCompleted():void
		{
			PopupMgr.removePopup(Factory.getInstance(DLCDlg));
			var categoryScr:CategoryScreen = Factory.getInstance(CategoryScreen);
			categoryScr.refresh();
		}
		
		private function onCancel():void
		{
			PopupMgr.removePopup(this);
			state = -1;
		}
	
	}

}