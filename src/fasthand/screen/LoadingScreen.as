package fasthand.screen 
{	
	import base.Factory;
	import base.Graphics4Starling;
	import base.LangUtil;
	import base.ScreenMgr;
	import comp.LoadingIcon;
	import comp.LoopableSprite;
	import comp.TileImage;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.ResMgr;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class LoadingScreen extends LoopableSprite 
	{						
		[Embed(source="../../../res/ico_logo.atf", mimeType="application/octet-stream")]
		public static const CompressedData:Class;
		
		private var t:Tween;
		private var quad:Quad;
		private var img:Image;
		
		public function LoadingScreen() 
		{
			super();			
			
			quad = Factory.getObjectFromPool(Quad);			
			quad.width = Util.appWidth;
			quad.height = Util.appHeight;
			quad.color = 0x0;
			addChild(quad);
			
			var data:ByteArray = new CompressedData() as ByteArray;			
			var tex:Texture = Texture.fromAtfData(data, 1 / Starling.contentScaleFactor);
			
			img = Factory.getObjectFromPool(Image);
			img.texture = tex;
			img.readjustSize();
			addChild(img);			
			
			Util.g_centerScreen(img);
			
			t = new Tween(img, 1);
			t.repeatCount = 0;
			t.reverse = true;
			t.fadeTo(0.3);
			
			interval = 0.033;
		}				
		
		override public function update(time:Number):void 
		{
			super.update(time);
			t.advanceTime(time);
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			if (resMgr.assetProgress == 1)
			{
				var p:DisplayObjectContainer = this.parent;
				// bg of game				
				ScreenMgr.showScreen(CategoryScreen);								
			}
		}
		
		override public function onRemoved(e:Event):void 
		{
			img.texture.dispose();
			img.removeFromParent();
			quad.removeFromParent();
			Factory.toPool(img);
			Factory.toPool(quad);
			super.dispose();
			t = null;
			img = null;
			quad = null;
			
			super.onRemoved(e);								
		}
	}

}