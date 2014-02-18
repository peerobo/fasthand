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
	public class InfoDlg extends BaseJsonGUI 
	{		
		public var closeBt:BaseButton;
		public var contentTxt:BaseBitmapTextField;
		
		public var text:String;
		public var callback:Function; // onclose():void
		
		public function InfoDlg() 
		{
			super("InfoDlg");
			
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			contentTxt.text = text;
			closeBt.setCallbackFunc(onClicked);			
		}
		
		private function onClicked():void 
		{
			if(callback is Function)
				callback();
			PopupMgr.removePopup(this);
		}
		
	}

}