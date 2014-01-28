package fasthand.comp 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.LangUtil;
	import comp.LoopableSprite;
	import flash.geom.Rectangle;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.ButtonAsset;
	import res.asset.IconAsset;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class CatRenderer extends LoopableSprite 
	{
		private static const ICON_X:int = 42;
		private static const ICON_Y:int = 48;
		private static const ICON_W:int = 246;
		private static const ICON_H:int = 216;			
		private var lockIcon:DisplayObject;
		private var isLocked:Boolean;
		private var icon:DisplayObject;	
		private var title:BaseBitmapTextField;
		
		static private const COLORS_RND:Array = [Color.PURPLE, Color.YELLOW, Color.OLIVE, Color.LIME];		
		
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
			lockIcon = Asset.getBaseImage(IconAsset.ICO_LOCK);
			lockIcon.y = 120;
			lockIcon.touchable = false;
			lockIcon.visible = isLocked;
			addChild(lockIcon);
			title = BFConstructor.getTextField(ICON_W, ICON_H, "", BFConstructor.BANHMI, COLORS_RND[int(Math.random()*COLORS_RND.length)], HAlign.CENTER, VAlign.TOP);
			title.x = ICON_X;
			title.y = 0;
			addChild(title);
			title.touchable = false;
		}
		
		public function set isLock(value:Boolean):void
		{
			if (lockIcon )
				lockIcon.visible = value;
			isLocked = value;
		}
		
		public function get isLock():Boolean
		{
			return isLocked;
		}
		
		public function setIcon(texName:String,name:String):void
		{
			if (icon && icon.parent)
			{
				if (icon is BaseBitmapTextField)
				{
					Factory.toPool(icon);
					icon.removeFromParent();
					icon = Factory.getObjectFromPool(Image);
					addChildAt(icon, 1);
				}
				(icon as Image).texture = Asset.getBaseTexture(texName);
				(icon as Image).readjustSize();				
			}
			else
			{
				icon = Asset.getBaseImage(texName) as Image;
				addChildAt(icon,1);
				icon.x = ICON_X;
				icon.y = ICON_Y;
			}
			icon.scaleX = icon.scaleY = 1;			
			Util.fit(icon, new Rectangle(ICON_X, ICON_Y, ICON_W, ICON_H));	
			icon.touchable = false;
			title.text = name;
		}
		
		public function setComingSoon():void
		{
			if(icon && icon is Image)
			{
				icon.removeFromParent();
				Factory.toPool(icon);
				icon = null;
			}
			icon = BFConstructor.getTextField(ICON_W, ICON_H, LangUtil.getText("comingsoon"), BFConstructor.BANHMI,0xFFFFFF,HAlign.CENTER,VAlign.TOP);			
			icon.x = ICON_X;
			icon.y = ICON_Y;
			addChildAt(icon, 1);
			icon.touchable = false;
			title.text = "";
		}
	}

}