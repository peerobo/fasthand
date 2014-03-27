package 
{	
	import base.BaseJsonGUI;
	import base.Factory;
	import base.LangUtil;
	CONFIG::isAndroid{
		import com.fc.FCAndroidUtility;
	}
	import comp.GameService;
	import flash.data.EncryptedLocalStore;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.setTimeout;
	import res.Asset;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author ndp
	 */
	[SWF(frameRate="60",backgroundColor="0x0")]
	public class Main extends Sprite 
	{		
		private var starling:Starling;
		private var canInit:Boolean;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;			
			//EncryptedLocalStore.reset();			
			CONFIG::isIOS{
				startStarlingFramework();			
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onAppDeactivate);	
				NativeApplication.nativeApplication.addEventListener(Event.EXITING, onAppExit);
			}
			if (Capabilities.cpuArchitecture == "ARM") 
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			}			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onAppActivate);
			var highscoreDB:GameService = Factory.getInstance(GameService);			
			if(Util.isIOS)
				highscoreDB.initGameCenter();
			else if (Util.isAndroid)
				highscoreDB.initGooglePlayGameService();
		}			
	
		private function onAppDeactivate(e:Event):void 
		{
			starling.stop(true);
			Util.root.onAppDeactivate();	
			trace("deactivate");
		}
		
		private function onAppActivate(e:Event):void 
		{
			CONFIG::isIOS{
				if (Util.root)
				{	
					starling.start();
					Util.root.onAppActivate();			
				}
			}
			trace("activate");
			CONFIG::isAndroid {
				if(!starling)
					setTimeout(init, 3000);
				else	
					init();
			}
		}
		
		CONFIG::isAndroid {		
			private function init():void
			{
				if(!starling)
				{
					FCAndroidUtility.instance.onInit = onAndroidStart;
					FCAndroidUtility.instance.init(Constants.APP_NAME);
				}
			}
			
			private function onAndroidStart():void 
			{							
				trace("set immersive");
				FCAndroidUtility.instance.setImmersive(true);	
				if(FCAndroidUtility.instance.getVersionInt() >= 19)
				{					
					if(!starling)
						stage.addEventListener(Event.RESIZE, onResize);
				}
				else
				{
					startStarlingFramework();
				}
				FCAndroidUtility.instance.onPause = onAndroidPause;
				FCAndroidUtility.instance.onResume = onAndroidResume;
				FCAndroidUtility.instance.onStop = onAndroidStop;
				FCAndroidUtility.instance.onRestart = onAndroidRestart;
				FCAndroidUtility.instance.onInit = null;
				
			}		
			
			private function onAndroidRestart():void 
			{
				trace("android restart");
			}
			
			private function onAndroidStop():void 
			{
				if (Util.root)
				{
					Util.root.onAppDeactivate();
					Util.root.onAppExit();
					trace("android stop");
					//NativeApplication.nativeApplication.exit();
				}
			}
			
			private function onAndroidResume():void 
			{
				trace("android resume");
				if (Util.root)
					Util.root.onAppActivate();
				if (starling && !starling.isStarted)
					starling.start();
				if (FCAndroidUtility.instance.doneInit)
					FCAndroidUtility.instance.setImmersive(true);
			}
			
			private function onAndroidPause():void 
			{
				trace("android pause");
				if (Util.root)
					Util.root.onAppDeactivate();
				if (starling && starling.isStarted)
					starling.stop(true);
			}
			
			private function onResize(e:Event):void 
			{
				stage.removeEventListener(Event.RESIZE, onResize);
				startStarlingFramework();		
			}
		}
		
		private function onAppExit(e:Event):void 
		{
			if (Util.root)
			{
				Util.root.onAppExit();
			}	
			NativeApplication.nativeApplication.exit();
		}
		
		private function startStarlingFramework():void 
		{
			if (!starling)
			{
				var sw:int = stage.fullScreenWidth;
				var sh:int = stage.fullScreenHeight;
				
				CONFIG::isAndroid {
					if(FCAndroidUtility.instance.getVersionInt()>=19)
					{
						Starling.handleLostContext = true;
						sw = stage.stageWidth;
						sh = stage.stageHeight
					}
				}
				
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
														
				if(needExtended)
					starling = new Starling(App, stage,new Rectangle(0,0,sw,sh),null,"auto",Context3DProfile.BASELINE_EXTENDED);
				else
					starling = new Starling(App, stage, new Rectangle(0, 0, sw, sh));			
				starling.stage.stageWidth = w;
				starling.stage.stageHeight = h;					
				starling.start();	
				Util.registerPool();
				Asset.init();
				LangUtil.loadXMLData();
				BaseJsonGUI.loadCfg();			
				//starling.addEventListener(Event.UNLOAD, onStarlingErrorContext);
				if(Util.isDesktop)
				{
					EncryptedLocalStore.removeItem(Constants.APP_NAME + "_" + Constants.SUBJECT_STR);								
				}
			}
		}					
	}
	
}