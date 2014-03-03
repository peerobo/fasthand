package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.font.BaseBitmapTextField;
	import base.PopupMgr;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class ConfirmDlg extends BaseJsonGUI 
	{
		public var yesBt:BaseButton;
		public var noBt:BaseButton;
		public var contentTxt:BaseBitmapTextField;
		
		public var text:String;
		public var callback:Function; // callback(isYes:Boolean):void
		
		public function ConfirmDlg() 
		{
			super("ConfirmDlg");		
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			contentTxt.text = text;
			yesBt.setCallbackFunc(onClicked,[true]);
			noBt.setCallbackFunc(onClicked,[false]);
		}
		
		private function onClicked(value:Boolean):void 
		{
			PopupMgr.removePopup(this);
			callback(value);			
		}
	}

}