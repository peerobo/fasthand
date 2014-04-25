package 
{	
	import base.BaseJsonGUI;
	import base.Factory;
	import base.LangUtil;
	import fasthand.gui.PurchaseDlg;
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
			}
			CONFIG::isAndroid {
				Util.initVideoAd(Constants.VIDEO_AD_ANDROID,true,PurchaseDlg.unlockCurrCat,null,null);
				Util.initAndroidUtility(true, onAndroidInit);
				Util.setAndroidFullscreen(true);
			}
			CONFIG::isAmazon {				
				Util.initAndroidUtility(false, null);
				Util.setAndroidFullscreen(true);
				setTimeout(onAndroidInit, 1000);
			}
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onAppActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onAppDeactivate);	
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onAppExit);
			if (Capabilities.cpuArchitecture == "ARM") 
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			}			
			
			var highscoreDB:GameService = Factory.getInstance(GameService);			
			if(Util.isIOS)
				highscoreDB.initGameCenter();
		}					
		
		CONFIG::isAmazon{		
			private function onAndroidInit():void 
			{
					if (Util.androidVersionInt >= Util.KITKAT)
					{	
						Starling.handleLostContext = true;						
					}
					else 
					{
						Starling.handleLostContext = false;						
					}	
					startStarlingFramework();					
					//var gS:GameService = Factory.getInstance(GameService);			
					//gS.initGooglePlayGameService();
			}
		}
		
		CONFIG::isAndroid{		
			private function onAndroidInit():void 
			{
					if (Util.androidVersionInt >= Util.KITKAT)
					{	
						Starling.handleLostContext = true;						
					}
					else 
					{
						Starling.handleLostContext = false;						
					}	
					startStarlingFramework();					
					var gS:GameService = Factory.getInstance(GameService);			
					gS.initGooglePlayGameService();
			}
		}
	
		private function onAppDeactivate(e:Event):void 
		{
			if (Util.root)
			{	
				starling.stop(true);
				Util.root.onAppDeactivate();			
			}
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
				if (Util.root)
				{	
					starling.start();
					Util.root.onAppActivate();			
				}
				Util.setAndroidFullscreen(true);
			}
			CONFIG::isAmazon {
				if (Util.root)
				{	
					starling.start();
					Util.root.onAppActivate();			
				}
				Util.setAndroidFullscreen(true);
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
				trace("start starling");
				var sw:int = stage.stageWidth;
				var sh:int = stage.stageHeight;
				if (Util.isDesktop)
				{
					sw = stage.fullScreenWidth;
					sh = stage.fullScreenHeight;
				}
				
				CONFIG::isIOS {
					sw = stage.fullScreenWidth;
					sh = stage.fullScreenHeight;
				}
				
				var maxSize:int = sw < sh ? sh : sw;
				var minSize:int = sw < sh ? sw : sh;
				var w:int;
				var h:int;
				var needExtended:Boolean = false;
				if (minSize <= 320)
				{
					w = sw / 0.25;
					h = sh / 0.25;
				}
				else if (minSize <= 480)
				{
					w = sw / 0.375;
					h = sh / 0.375;
				}
				else if (minSize <= 800)
				{
					w = sw / 0.5;
					h = sh / 0.5;
				}
				else if (minSize <= 1080)
				{
					w = sw / 0.75;
					h = sh / 0.75;
				}
				else
				{
					w = sw;
					h = sh;
					needExtended = true;
				}
				
				if (needExtended)
					starling = new Starling(App, stage, new Rectangle(0, 0, sw, sh), null, "auto", Context3DProfile.BASELINE_EXTENDED);
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