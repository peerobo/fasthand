package 
{
	import com.hdi.nativeExtensions.NativeAds;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import res.Asset;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			
			// new to AIR? please read *carefully* the readme.txt files!
			
			startStarlingFramework();				
		}
		
		private function startStarlingFramework():void 
		{
			var sw:int = stage.fullScreenWidth;
			var sh:int = stage.fullScreenHeight;
			
			var maxSize:int = sw < sh ? sh : sw;
			var w:int;
			var h:int;
			if (maxSize <= 480)
			{
				w = sw*3;
				h = sh*3;
			}
			else if (maxSize <= 1280)
			{
				w = sw*3/2;
				h = sh*3/2;
			}
			else
			{
				w = sw;
				h = sh;
			}
			
			var starling:Starling = new Starling(App, stage,new Rectangle(0,0,sw,sh));
			starling.stage.stageWidth = w;
			starling.stage.stageHeight = h;				
			starling.start();					
			Asset.init();	
			
			NativeAds.setUnitId("a152e1293565247");
			NativeAds.setAdMode(false);//put the ads in real mode
			//initialize the ad banner with size compatible for phones, it's applicable to iOS only
			NativeAds.initAd(0,0, 320, 50);
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
			NativeAds.deactivateAd();
		}
		
	}
	
}