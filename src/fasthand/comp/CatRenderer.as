package fasthand.comp 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.CallbackObj;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.LangUtil;
	import comp.LoopableSprite;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
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
		private static const ICON_Y:int = 60;
		private static const ICON_W:int = 246;
		private static const ICON_H:int = 186;			
		private var lockIcon:DisplayObject;
		private var isLocked:Boolean;
		private var icon:DisplayObject;	
		private var title:BaseBitmapTextField;
		
		static private const COLORS_RND:Array = [Color.WHITE, 0xFFFF80, 0xFF80FF, 0x8282FF, 0x00FF80, 0xFF8000];		
		private var _cat:String;
		private var bt:BaseButton;
		
		public var clickCallbackObj:CallbackObj;
		
		public function CatRenderer() 
		{
			super();			
		}				
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
						
			bt = ButtonAsset.getBaseBt(BackgroundAsset.BG_ITEM);
			bt.background.width = 324;
			bt.background.height = 276;
			bt.x = 18;
			bt.y = 0;
			addChild(bt);
			lockIcon = Asset.getBaseImage(IconAsset.ICO_LOCK);
			lockIcon.y = 120;
			lockIcon.x = 0;
			lockIcon.touchable = false;
			lockIcon.visible = isLocked;
			addChild(lockIcon);			
			title = BFConstructor.getTextField(bt.background.width - 48, ICON_H, "", BFConstructor.ARIAL, COLORS_RND[int(Math.random()*COLORS_RND.length)], HAlign.CENTER, VAlign.TOP);
			title.x = ICON_X;
			title.y = 0;
			addChild(title);
			title.touchable = false;
			
			bt.setCallbackFunc(onClick);			
		}
		
		public function align(rectBt:Rectangle,lockRect:Rectangle):void
		{
			bt.background.width = rect.width;
			bt.background.height = rect.height;
			lockIcon.x = lockRect.x;
			lockIcon.y = lockRect.y;
		}
		
		private function onClick():void
		{
			if (clickCallbackObj)
			{
				var p:Array = clickCallbackObj.p ? p.concat():[];
				p.splice(0, 0, this);
				clickCallbackObj.f.apply(this, p);
				for (var i:int = 0; i < this.numChildren; i++) 
				{
					var c:DisplayObject = getChildAt(i);
					trace(getQualifiedClassName(c), c.visible, c.x, c.y);
				}
			}
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
			_cat = name;
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
			Util.g_fit(icon, new Rectangle(ICON_X, ICON_Y, ICON_W, ICON_H));	
			icon.touchable = false;
			title.text = LangUtil.getText(name);
		}
		
		public function setComingSoon():void
		{
			if(icon && icon is Image)
			{
				icon.removeFromParent();
				Factory.toPool(icon);
				icon = null;
			}
			icon = BFConstructor.getTextField(ICON_W, ICON_H, LangUtil.getText("comingsoon"), BFConstructor.ARIAL,0xFFFFFF,HAlign.CENTER,VAlign.TOP);			
			icon.x = ICON_X;
			icon.y = ICON_Y;
			addChildAt(icon, 1);
			icon.touchable = false;
			title.text = "";
		}
		
		public function get cat():String
		{
			return _cat;
		}
	}

}