package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.font.BaseBitmapTextField;
	import base.InAppPurchase;
	import base.PopupMgr;	
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
			
			yesBt.isDisable = !InAppPurchase.canPurchase;
		}
		
		private function onRestorePurchase():void 
		{
			
		}
		
		private function onYes():void 
		{
			
		}
		
		private function onCancel():void 
		{
			PopupMgr.removePopup(this);
		}
		
	}

}