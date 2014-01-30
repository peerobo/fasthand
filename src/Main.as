package 
{
	//import com.hdi.nativeExtensions.NativeAds;
	import base.BaseJsonGUI;
	import base.Factory;
	import base.LangUtil;
	import fasthand.Fasthand;
	import flash.data.EncryptedLocalStore;
	import flash.desktop.NativeApplication;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
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
	[SWF(frameRate="60",backgroundColor="0xFFFFFF")]
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
			var minSize:int = sw < sh ? sw : sh;
			var w:int;
			var h:int;
			/*if (maxSize < 640)
			{
				w = sw*3;
				h = sh*3;
			}
			else if (maxSize < 1280)
			{
				w = sw*3/2;
				h = sh*3/2;
			}
			else
			{
				w = sw;
				h = sh;
			}*/
			
			if (minSize <=480)
			{
				w = sw*3;
				h = sh*3;
			}
			else if (minSize <= 960)
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
			Util.registerPool();
			Asset.init();
			LangUtil.loadXMLData();
			BaseJsonGUI.loadCfg();			
			Util.initAd();	
			
			if(Util.isDesktop)
			{
				EncryptedLocalStore.removeItem(Constants.APP_NAME + "_" + "highscore");
				EncryptedLocalStore.removeItem(Constants.APP_NAME + "_" + "highscoreDiff");
			}
		}
		
		private function onAdReceived(event:AdmobEvent):void 
		{
			if(event.type==AdmobEvent.onBannerReceive){
				trace(event.data.width,event.data.height);
			}
		}
		
		private function deactivate(e:Event):void 
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);
			if(logic.highscore > 0 || logic.hightscoreDifficult > 0)
			{
				Util.setPrivateValue("highscore", logic.highscore.toString());
				Util.setPrivateValue("highscoreDiff", logic.hightscoreDifficult.toString());				
			}						
			
			// make sure the app behaves well (or exits) when in background
			NativeApplication.nativeApplication.exit();
			//NativeAds.deactivateAd();
		}
		
	}
	
}