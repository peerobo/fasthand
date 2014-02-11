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
	import starling.filters.ColorMatrixFilter;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class CatRenderer extends LoopableSprite 
	{
		private static const ICON_X:int = 12;
		private static const ICON_Y:int = 120;
		private static var ICON_W:int;
		private static var ICON_H:int;			
		private var lockIcon:DisplayObject;
		private var isLocked:Boolean;
		private var icon:DisplayObject;	
		private var title:BaseBitmapTextField;
		
		static private const COLORS_RND:Array = [Color.WHITE, 0xFFFF80, 0xFF80FF, 0x8282FF, 0x00FF80, 0xFF8000];		
		private var _cat:String;
		private var bt:BaseButton;
		private var colorMF:ColorMatrixFilter;
		public var clickCallbackObj:CallbackObj;
		
		public function CatRenderer() 
		{
			super();	
			colorMF = new ColorMatrixFilter();
		}				
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
						
			bt = ButtonAsset.getBaseBt(BackgroundAsset.BG_ITEM);			
			bt.x = 18;
			bt.y = 0;
			addChild(bt);
			lockIcon = Asset.getBaseImage(IconAsset.ICO_LOCK);
			lockIcon.touchable = false;
			lockIcon.visible = isLocked;
			addChild(lockIcon);			
			title = BFConstructor.getTextField(bt.background.width - 12, ICON_H, "", BFConstructor.ARIAL, Color.WHITE, HAlign.CENTER, VAlign.TOP);			
			title.y = 0;
			addChild(title);
			title.touchable = false;
			
			bt.setCallbackFunc(onClick);			
		}
		
		public function align(rectBt:Rectangle,lockRect:Rectangle):void
		{
			bt.background.width = rectBt.width;
			bt.background.height = rectBt.height;
			lockIcon.x = lockRect.x;
			lockIcon.y = lockRect.y;
			ICON_W = rectBt.width - ICON_X * 2;			
			ICON_H = rectBt.height - ICON_Y - 24;
			title.width = ICON_W;
			title.height = ICON_H;
			title.x = ICON_X + 12;
			title.y = 36;			
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
		
		public function adjustColorIdx(idx:int):void
		{	
			switch(idx)
			{
				case 1:
					colorMF.adjustHue( -7 / 180);
					colorMF.adjustSaturation(1);
					bt.colorFilter = colorMF;
				break;
				case 2:
					colorMF.adjustHue(119 / 180);
					bt.colorFilter = colorMF;
				break;
				case 3:
					colorMF.adjustHue( -87 / 180);
					colorMF.adjustSaturation(1);
					colorMF.adjustBrightness(0.37);
					bt.colorFilter = colorMF;
				break;
				case 4:
					colorMF.adjustHue(16 / 180);
					colorMF.adjustSaturation( -0.4);
					colorMF.adjustBrightness( -0.32);
					bt.colorFilter = colorMF;
				break;
				case 5:
					colorMF.adjustHue( -64 / 180);
					colorMF.adjustSaturation(0.29);
					colorMF.adjustBrightness(0.31);
					bt.colorFilter = colorMF;
				break;
			}
			
			
		}
	}

}