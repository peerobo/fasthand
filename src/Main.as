package 
{	
	import base.BaseJsonGUI;
	import base.Factory;
	import base.GameSave;
	import base.IAP;
	import base.LangUtil;
	import base.ScreenMgr;
	import base.SoundManager;
	import comp.GameService;
	import fasthand.Fasthand;
	import fasthand.screen.GameScreen;
	import flash.data.EncryptedLocalStore;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Shape;
	import flash.display3D.Context3DProfile;
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
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;			
			//EncryptedLocalStore.reset();
			startStarlingFramework();
			if (Capabilities.cpuArchitecture == "ARM") 
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			}
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onAppExit);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onAppActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onAppDeactivate);
		}			
	
		private function onAppDeactivate(e:Event):void 
		{			
			Util.root.onAppDeactivate();			
		}
		
		private function onAppActivate(e:Event):void 
		{
			if (Util.root)
			{				
				Util.root.onAppActivate();			
			}
		}
		
		private function onAppExit(e:Event):void 
		{
			if (Util.root)
			{
				Util.root.onAppExit();
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
			var needExtended:Boolean = false;
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
				needExtended = true;
			}
			
			//if(Util.isAndroid)
				//Starling.handleLostContext = true;
			//else
				//Starling.handleLostContext = false;
			
			var starling:Starling;
			if(needExtended)
				starling = new Starling(App, stage,new Rectangle(0,0,sw,sh),null,"auto",Context3DProfile.BASELINE_EXTENDED);
			else
				starling = new Starling(App, stage,new Rectangle(0,0,sw,sh));
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