package 
{
	//import com.hdi.nativeExtensions.NativeAds;
	import base.BaseJsonGUI;
	import base.LangUtil;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import res.Asset;
	import so.cuo.platform.admob.Admob;
	import so.cuo.platform.admob.AdmobEvent;
	import so.cuo.platform.admob.AdmobPosition;
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
			LangUtil.loadXMLData();
			BaseJsonGUI.loadCfg();			
			Util.initAd();
		}
		
		private function onAdReceived(event:AdmobEvent):void 
		{
			if(event.type==AdmobEvent.onBannerReceive){
				trace(event.data.width,event.data.height);
			}

		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			NativeApplication.nativeApplication.exit();
			//NativeAds.deactivateAd();
		}
		
	}
	
}