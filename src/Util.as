package
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import comp.TileImage;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import so.cuo.platform.admob.Admob;
	import so.cuo.platform.admob.AdmobEvent;
	import so.cuo.platform.admob.AdmobPosition;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class Util
	{
		public static const HOVER_FILTER:int = 0;
		public static const DISABLE_FILTER:int = 1;
		public static const DOWN_FILTER:int = 2;
		
		public static var root:Sprite;
		
		public static function getFilter(type:int):FragmentFilter
		{
			var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
			switch (type)
			{
				case HOVER_FILTER: 
					colorMatrixFilter.adjustBrightness(0.1);
					colorMatrixFilter.adjustContrast(0.05);
					break;
				case DISABLE_FILTER: 
					colorMatrixFilter.adjustSaturation(-1);
					break;
				case DOWN_FILTER: 
					colorMatrixFilter.adjustBrightness(0.2);
					colorMatrixFilter.adjustContrast(0.4);
					break;
			}
			return colorMatrixFilter;
		}
		
		public function Util()
		{
		
		}
		
		public static function g_centerScreen(disp:DisplayObject):void
		{
			disp.x = Util.appWidth - disp.width >> 1;
			disp.y = Util.appHeight - disp.height >> 1;
		}
		
		public static function g_centerChild(p:DisplayObject, c:DisplayObject):void
		{
			c.x = p.width - c.width >> 1;
			c.y = p.height - c.height >> 1;
		}
		
		public static function initAd():void
		{
			var admob:Admob = Admob.getInstance();
			if (admob.supportDevice)
			{
				admob.setKeys("a152e1293565247");				
			}
		}
		
		public static function showBannerAd():void
		{
			var admob:Admob = Admob.getInstance();
			admob.showBanner(Admob.BANNER, AdmobPosition.BOTTOM_CENTER);//show banner with relation position			
		}
		
		public static function hideBannerAd():void
		{
			var admob:Admob = Admob.getInstance();
			admob.hideBanner();
		}
		
		public static function showFullScreenAd():void
		{
			var admob:Admob = Admob.getInstance();
			if (admob.supportDevice)
			{
				admob.setKeys("a152e1293565247");
				admob.addEventListener(AdmobEvent.onInterstitialReceive, onAdReceived);
				admob.cacheInterstitial();
			}
		}
		
		private static function onAdReceived(e:AdmobEvent):void
		{
			var admob:Admob = Admob.getInstance();
			if (e.type == AdmobEvent.onInterstitialReceive)
			{
				admob.showInterstitial();
				admob.removeEventListener(AdmobEvent.onInterstitialReceive, onAdReceived);
			}
		}
		
		public static function get appWidth():int
		{
			return Starling.current.stage.stageWidth;
		}
		
		public static function get appHeight():int
		{
			return Starling.current.stage.stageHeight;
		}
		
		public static function get deviceWidth():int
		{
			return Starling.current.nativeStage.fullScreenWidth;
		}
		
		public static function get deviceHeight():int
		{
			return Starling.current.nativeStage.fullScreenHeight;
		}
		
		public static function getLocalData(soName:String):SharedObject
		{
			var result:SharedObject = SharedObject.getLocal(App.APP_NAME + "_" + soName);
			return result;
		}
		
		public static function fit(disp:DisplayObject, fitObj:*):void
		{
			var rec:Rectangle;
			if (fitObj is Rectangle)
			{
				rec = fitObj;
			}
			else if (fitObj is DisplayObject)
			{
				rec = fitObj.getBounds(fitObj);
			}
			disp.width = disp.width > rec.width ? rec.width : disp.width;
			disp.scaleY =  disp.scaleX;
			
			disp.height = disp.height > rec.height ? rec.height : disp.height;
			disp.scaleX =  disp.scaleY;
			
			disp.x = rec.x + (rec.width - disp.width >>1);
			disp.y = rec.y + (rec.height - disp.height >>1);
		}
		
		public static function registerPool():void
		{
			Factory.registerPoolCreator(Image, function ():Image { 
					var img:Image = new Image(Texture.empty(1, 1));
					return img;
				},
				function(img:Image):void {
					img.scaleX = img.scaleY = 1;				
			});
			
			Factory.registerPoolCreator(MovieClip, function ():MovieClip {
				var vc:Vector.<Texture> = new Vector.<Texture>();
				vc.push(Texture.empty(1, 1));
				var mc:MovieClip = new MovieClip(vc, 1);				
				return mc;
			});
			
			Factory.registerPoolCreator(BaseBitmapTextField, function():BaseBitmapTextField {
					return new BaseBitmapTextField(1, 1, "");
				},
				function (txt:BaseBitmapTextField):void {
					txt.reset();
			});		

			Factory.registerPoolCreator(BaseButton, function():BaseButton {
					var baseBt:BaseButton = new BaseButton();
					return baseBt;
				},
				function (bt:BaseButton):void {										
					bt.destroy();					
				}
			);
			
			Factory.registerPoolCreator(Quad, function ():Quad {
				return new Quad(1, 1);
			});		
			
			Factory.registerPoolCreator(Scale9Image, function():Scale9Image {
				var scale9Textures:Scale9Textures = new Scale9Textures(Texture.empty(1,1),new Rectangle(0,0,0,0));
				var scale9Img:Scale9Image = new Scale9Image(scale9Textures);
				return scale9Img;
			});
		}
	
	}

}