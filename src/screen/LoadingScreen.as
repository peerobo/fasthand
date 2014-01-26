package screen 
{	
	import base.Factory;
	import base.Graphics4Starling;
	import comp.LoadingIcon;
	import comp.LoopableSprite;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
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
		private var loadingIcon:LoadingIcon;		
		[Embed(source="../../res/asset/gui/ico_logo.png", mimeType = "image/png")]		
		private const LOGO:Class;
				
		[Embed(source="../../res/asset/gui/ico_logo.atf", mimeType="application/octet-stream")]
		public static const CompressedData:Class;
		
		private var t:Tween;
		
		public function LoadingScreen() 
		{
			super();
			//loadingIcon = new LoadingIcon();
			//loadingIcon.x = Util.appWidth - loadingIcon.width >>1;
			//loadingIcon.y = Util.appHeight - loadingIcon.height >> 1;
			//addChild(loadingIcon);
			
			//addEventListener(Event.ENTER_FRAME, onFrame);		
			
			var quad:Quad = new Quad(Util.appWidth,Util.appHeight,0x0);
			addChild(quad);
			var img:Bitmap = new LOGO() as Bitmap;
			img.scaleX = img.scaleY = Starling.contentScaleFactor;
			
			var data:ByteArray = new CompressedData() as ByteArray;			
			var tex:Texture = Texture.fromAtfData(data,Starling.contentScaleFactor);
			//var tex:Texture = Texture.fromBitmap(img,true,false,Starling.contentScaleFactor);
			var logo:Image = new Image(tex);			
			addChild(logo);
			Util.g_centerScreen(logo);
			t = new Tween(logo, 1);
			t.repeatCount = 0;
			t.reverse = true;
			t.fadeTo(0.0);
			
			interval = 0.033;
		}				
		
		private function onFrame(e:Event):void 
		{			
			//var resMgr:ResMgr = Factory.getInstance(ResMgr);
			//loadingIcon.progressString = resMgr.assetProgress * 100 + "%";
			
			//if (resMgr.assetProgress == 1)
			//{
				//var gameScreen:GameScreen = Factory.getInstance(GameScreen);
				//var p:DisplayObjectContainer = this.parent;
				//p.addChild(gameScreen);				
				//this.removeFromParent();
			//}
		}
		
		override public function update(time:Number):void 
		{
			super.update(time);
			t.advanceTime(time);
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			if (resMgr.assetProgress == 1)
			{
				var gameScreen:GameScreen = Factory.getInstance(GameScreen);
				var p:DisplayObjectContainer = this.parent;
				p.addChild(gameScreen);				
				this.removeFromParent();
			}
		}
	}

}