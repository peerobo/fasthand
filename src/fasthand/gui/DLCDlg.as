package fasthand.gui 
{
	import base.BaseJsonGUI;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.LayerMgr;
	import flash.geom.Rectangle;
	import res.ResMgr;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class DLCDlg extends BaseJsonGUI 
	{
		public var timeProgressbar:DisplayObject;
		public var timeProgressbarBg:DisplayObject;
		public var rectPBMin:Rectangle;
		public var progressTxt:BaseBitmapTextField;
		public var progress:Number;
		
		public var msg:String;
		
		public function DLCDlg() 
		{
			super("DownloadContentDlg");			
		}
		
		override public function onAdded(e:Event):void 
		{
			LayerMgr.lockGameLayer = true;
			super.onAdded(e);			
		}
		
		override public function onRemoved(e:Event):void 
		{
			LayerMgr.lockGameLayer = false;
			super.onRemoved(e);			
		}
		
		override public function update(time:Number):void 
		{
			super.update(time);
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			
			progressTxt.text = msg + "\n" + int((resMgr.extraCurrentByte / 1024) * 1000) / 1000 + "KB / " + int((resMgr.extraCurrentByte2Load / 1024) * 1000) / 1000 + "KB";
			progress = resMgr.extraCurrentByte / resMgr.extraCurrentByte2Load;
			var w:int = timeProgressbarBg.width * progress;
			if (w < rectPBMin.width)
			{
				timeProgressbar.alpha = w / rectPBMin.width;
			}
			else
			{
				timeProgressbar.alpha = 1;
			}
			timeProgressbar.width = w;										
		}
	}

}