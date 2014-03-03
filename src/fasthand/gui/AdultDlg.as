package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.font.BaseBitmapTextField;
	import base.LangUtil;
	import base.PopupMgr;
	import flash.geom.Rectangle;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class AdultDlg extends BaseJsonGUI 
	{
		private var count:Number;
		public var equationTxt:BaseBitmapTextField;
		public var yesBt:BaseButton;
		public var strHolder:DisplayObject;
		public var timeTxt:BaseBitmapTextField;		
		public var callback:Function;
		
		private var firstNo:int;
		private var secondNo:int;
		private var stageText:StageText;
		
		public function AdultDlg() 
		{
			super("AdultDlg");
			interval = 1;
			
			stageText = new StageText();
			stageText.restrict = "0-9";
			stageText.maxChars = 3;
			stageText.softKeyboardType = SoftKeyboardType.NUMBER;
			stageText.editable = true;
			stageText.fontFamily = "Arial";
			stageText.fontSize = 40;	
			stageText.color = 0xFFFFFF;			
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			count = Constants.TIMEOUT_MATH;
			count = int(count * 10) / 10;
			var str:String = LangUtil.getText("adultClose");
			str = Util.replaceStr(str, ["@sec"], [count.toString()]);
			timeTxt.text = str;
						
			Starling.juggler.delayCall(correctViewPort,0.5);
			
			stageText.stage = Starling.current.nativeStage;
			yesBt.setCallbackFunc(onYes);
			
			firstNo = Math.random() * 50;
			secondNo = Math.random() * 50;
			
			equationTxt.text = firstNo + " + " + secondNo + " = ";						
		}
		
		private function correctViewPort():void 
		{
			var rec:Rectangle = new Rectangle();
			strHolder.getBounds(Starling.current.stage, rec);
			FPSCounter.log(rec.toString());			
			rec.x = rec.x * Starling.contentScaleFactor + 10;
			rec.y = rec.y * Starling.contentScaleFactor + 10;
			rec.width = rec.width * Starling.contentScaleFactor - 20;
			rec.height = rec.height * Starling.contentScaleFactor - 20;			
			FPSCounter.log(rec.toString());
			stageText.viewPort = rec;				
			
			stageText.text = "";
		}
		
		private function onYes():void 
		{
			validateResult();
		}
		
		override public function update(time:Number):void 
		{			
			super.update(time);
			if (count > 0)
			{
				count -= time;
				count = int(count * 10) / 10;
				var str:String = LangUtil.getText("adultClose");
				str = Util.replaceStr(str, ["@sec"], [count.toString()]);
				timeTxt.text = str;
			}
			if (count <= 0)
			{
				validateResult();
				PopupMgr.removePopup(this);
			}
		}
		
		private function validateResult():void 
		{
			var val:int = parseInt(stageText.text);
			if (val == firstNo + secondNo)
			{
				PopupMgr.removePopup(this);
				callback();
				callback = null;
			}
			else
			{
				stageText.text = "";
			}
			
		}
		
		override public function onRemoved(e:Event):void 
		{
			stageText.stage = null;
			super.onRemoved(e);			
		}
		
	}

}