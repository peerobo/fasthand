package fasthand.comp 
{
	import base.BaseButton;
	import comp.LoopableSprite;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.ButtonAsset;
	import res.asset.IconAsset;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class CatRenderer extends LoopableSprite 
	{
		private static const ICON_X:int = 42;
		private static const ICON_Y:int = 18;
		private static const ICON_W:int = 246;
		private static const ICON_H:int = 216;		
		
		public function CatRenderer() 
		{
			super();			
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			var bt:BaseButton = ButtonAsset.getBaseBt(BackgroundAsset.BG_ITEM);
			bt.background.width = 300;
			bt.background.height = 276;
			bt.x = 18;
			addChild(bt);
			var lockIcon:DisplayObject = Asset.getBaseImage(IconAsset.ICO_LOCK);
			lockIcon.y = 120;
			lockIcon.touchable = false;
			addChild(lockIcon);
		}
		
	}

}