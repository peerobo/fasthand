package 
{	
	import base.BaseJsonGUI;
	import base.Factory;
	import base.GameSave;
	import base.IAP;
	import base.LangUtil;
	import comp.HighscoreDB;
	import fasthand.Fasthand;
	import flash.data.EncryptedLocalStore;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import res.Asset;		
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author ndp
	 */
	[SWF(frameRate="60",backgroundColor="0x0")]
	public class Main extends Sprite 
	{		
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//stage.addEventListener(Event.DEACTIVATE, deactivate);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onAppExit);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onAppActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onAppDeactivate);			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			//EncryptedLocalStore.reset();
			// entry point			
			// new to AIR? please read *carefully* the readme.txt files!						
			var gameState:GameSave = Factory.getInstance(GameSave);
			gameState.loadState();
			startStarlingFramework();
			if (Capabilities.cpuArchitecture == "ARM") 
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			}
		}			
	
		private function onAppDeactivate(e:Event):void 
		{
			var gameState:GameSave = Factory.getInstance(GameSave);
			gameState.saveState();
			if (Util.isDesktop)
				return;
			var highscoreDB:HighscoreDB = Factory.getInstance(HighscoreDB);
			highscoreDB.saveHighscore();		
			
			var gameState:GameSave = Factory.getInstance(GameSave);
			gameState.saveState();
			
			Starling.current.stop(true);
			// make sure the app behaves well (or exits) when in background			
			//NativeApplication.nativeApplication.exit();
			//NativeAds.deactivateAd();
		}
		
		private function onAppActivate(e:Event):void 
		{
			Starling.current.start();
		}
		
		private function onAppExit(e:Event):void 
		{
			if (Util.isAndroid)
			{			
				e.preventDefault();
			}
		}
		
		private function startStarlingFramework():void 
		{
			var sw:int = stage.fullScreenWidth;
			var sh:int = stage.fullScreenHeight;
			
			var maxSize:int = sw < sh ? sh : sw;
			var minSize:int = sw < sh ? sw : sh;
			var w:int;
			var h:int;
			//if (maxSize < 640)
			//{
				//w = sw*3;
				//h = sh*3;
			//}
			//else if (maxSize < 1920)
			//{
				//w = sw*3/2;
				//h = sh*3/2;
			//}
			//else if (maxSize < 1920)
			//{
				//w = sw*3/2;
				//h = sh*3/2;
			//}
			//else
			//{
				//w = sw;
				//h = sh;
			//}
			
			if (minSize <=320)
			{
				w = sw/0.25;
				h = sh/0.25;
			}
			else if (minSize <= 480)
			{
				w = sw/0.375;
				h = sh/0.375;
			}
			else if (minSize <= 800)
			{
				w = sw/0.5;
				h = sh/0.5;
			}
			else if (minSize <= 1080)
			{
				w = sw/0.75;
				h = sh/0.75;
			}
			else
			{
				w = sw;
				h = sh;
			}
			
			//if(Util.isAndroid)
				//Starling.handleLostContext = true;
			//else
				//Starling.handleLostContext = false;
			
			var starling:Starling = new Starling(App, stage,new Rectangle(0,0,sw,sh));
			starling.stage.stageWidth = w;
			starling.stage.stageHeight = h;					
			starling.start();	
			Util.registerPool();
			Asset.init();
			LangUtil.loadXMLData();
			BaseJsonGUI.loadCfg();						
			
			if(Util.isDesktop)
			{
				EncryptedLocalStore.removeItem(Constants.APP_NAME + "_" + Constants.SUBJECT_STR);								
			}
		}					
	}
	
}