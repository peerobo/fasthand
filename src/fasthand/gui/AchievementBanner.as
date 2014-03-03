package fasthand.gui 
{
	import base.BaseJsonGUI;
	import base.font.BaseBitmapTextField;
	import starling.display.DisplayObject;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class AchievementBanner extends BaseJsonGUI 
	{
		public var label:String;
		public var achievementTxt:BaseBitmapTextField;
		public var bg:DisplayObject;
		public var textBg:DisplayObject;
		public var queueAchievement:Array;
		
		public function AchievementBanner() 
		{
			super("AchievementBanner");
			this.touchable = false;
			queueAchievement = [];
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			achievementTxt.text = label;
			bg.alpha = 0.8;
			textBg.alpha = 0.6;
			var cF:ColorMatrixFilter = new ColorMatrixFilter();
			cF.adjustBrightness( -1);
			cF.adjustContrast(1);
			cF.adjustSaturation( -0.5);			
			textBg.filter  = cF;
			
			this.y = -this.height;
			this.x = Util.appWidth - this.width >> 1;
			Starling.juggler.tween(this, 0.5, { y: 60, onComplete: onCompleteShow } );
		}
		
		public function queue(achievementLabel:String):void 
		{
			queueAchievement.push(achievementLabel);
		}
		
		private function onCompleteShow():void 
		{
			Starling.juggler.tween(this, 0.5, { y: -this.height, onComplete: onCompleteHide, delay: 3})
		}
		
		private function onCompleteHide():void 
		{			
			if (queueAchievement.length == 0)
			{
				this.removeFromParent();
			}
			else
			{
				achievementTxt.text = queueAchievement[0];
				queueAchievement.splice(0, 1);
				Starling.juggler.tween(this, 0.5, { y: 60, onComplete: onCompleteShow } );
			}
		}
	}

}