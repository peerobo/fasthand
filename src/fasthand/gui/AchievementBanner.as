package fasthand.gui 
{
	import base.BaseJsonGUI;
	import base.font.BaseBitmapTextField;
	import base.LayerMgr;
	import comp.IAchievementBanner;
	import fasthand.FasthandUtil;
	import starling.display.DisplayObject;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class AchievementBanner extends BaseJsonGUI implements IAchievementBanner
	{
		private var _isShowing:Boolean;
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
			_isShowing = true;
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
		
		/* INTERFACE comp.IAchievementBanner */
		
		public function get isShowing():Boolean 
		{
			return _isShowing;
		}
		
		public function setLabelAndShow(achName:String):void 
		{
			label = FasthandUtil.getAchievementLabel(achName);
			LayerMgr.getLayer(LayerMgr.LAYER_EFFECT).addChild(this);
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
				_isShowing = false;
			}
			else
			{
				achievementTxt.text = FasthandUtil.getAchievementLabel(queueAchievement[0]);
				queueAchievement.splice(0, 1);
				Starling.juggler.tween(this, 0.5, { y: 60, onComplete: onCompleteShow } );
			}
		}
	}

}