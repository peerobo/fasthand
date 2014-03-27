package  
{	
	import base.BFConstructor;
	import base.Factory;
	import base.GameSave;
	import base.GlobalInput;
	import base.IAP;
	import base.LayerMgr;
	import base.ScreenMgr;
	import base.SoundManager;
	import comp.GameService;
	import fasthand.Fasthand;
	import fasthand.screen.CategoryScreen;
	import fasthand.screen.GameScreen;
	import fasthand.screen.LoadingScreen;
	import res.asset.ParticleAsset;
	import res.asset.SoundAsset;
	import res.ResMgr;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	CONFIG::isAndroid{
		import comp.SocialForAndroid;
	}
	
	/**
	 * ...
	 * @author ndp
	 */
	public class App extends Sprite 
	{
		public static const APP_NAME:String = "fasthand";
		
		public function App() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onInit);
			this.alpha = 0.9999;			
		}				
		
		public function onAppDeactivate():void 
		{			
			if (Util.isDesktop)
				return;
			SoundManager.instance.muteMusic = true;
			var logic:Fasthand = Factory.getInstance(Fasthand);			
			if (ScreenMgr.currScr is GameScreen && logic.isStartGame)
			{
				var gScr:GameScreen = Factory.getInstance(GameScreen);
				gScr.onPause();
			}
			var gameService:GameService = Factory.getInstance(GameService);
			gameService.saveHighscore();
		}
		
		public function onAppActivate():void 
		{
			if (ScreenMgr.currScr is CategoryScreen)
			{				
				SoundManager.instance.muteMusic = false;
			}
			
		}
		
		public function onAppExit():void 
		{
			var gameState:GameSave = Factory.getInstance(GameSave);
			gameState.saveState();	
			
		}
		
		public function reinitializeTextures():void 
		{
			ScreenMgr.showScreen(LoadingScreen);
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			resMgr.start();	
		}
		
		private function onInit(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			Util.root = this;
			var fps:FPSCounter = new FPSCounter(0, 0, 0xFFFFFF, true, 0x0);
			//Starling.current.nativeOverlay.addChild(fps);
			try
			{
				var gameState:GameSave = Factory.getInstance(GameSave);
				gameState.loadState();				
				var iap:IAP = Factory.getInstance(IAP);
				iap.initInAppPurchase(Util.isIOS?Constants.IOS_PRODUCT_IDS:Constants.ANDROID_LICENSING);			
				CONFIG::isAndroid {
					var shareAndroid:SocialForAndroid = Factory.getInstance(SocialForAndroid);
					shareAndroid.init();
				}
			}
			catch (err:Error)
			{
				FPSCounter.log(err.message);
			}			
			LayerMgr.init(this);
			var input:GlobalInput = Factory.getInstance(GlobalInput);
			input.init();
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			resMgr.start();			
			BFConstructor.init();
			ParticleAsset.loadCfg();
			SoundAsset.preload();
			ScreenMgr.showScreen(LoadingScreen);			
			Util.initAd();				
			
			trace("--- init game: stage", Util.appWidth, "x", Util.appHeight, "-", Util.deviceWidth, "x", Util.deviceHeight);						
			addEventListener(TouchEvent.TOUCH, onTouch);									
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			// debug displayobject
			//trace(e.target, (e.target as DisplayObject).parent);
		}
		
	}

}