package  
{	
	import base.BFConstructor;
	import base.Factory;
	import base.GameSave;
	import base.GlobalInput;	
	import base.IAP;
	import base.LayerMgr;	
	import base.ScreenMgr;
	import comp.HighscoreDB;
	import flash.display.Stage;
	import res.asset.ParticleAsset;
	import res.asset.SoundAsset;
	import res.ResMgr;
	import fasthand.screen.LoadingScreen;	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;	
	
	/**
	 * ...
	 * @author ndp
	 */
	public class App extends Sprite 
	{
		public static const APP_NAME:String = "fasthand";
		public static var APP_ID_IPHONE:String = "820843454";
		public static var APP_ID_ANDROID:String = "com.chillingo.deadahead.rowgplay";
		
		public function App() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onInit);
			this.alpha = 0.9999;			
		}				
		
		private function onInit(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			var fps:FPSCounter = new FPSCounter(0, 0, 0xFFFFFF, true, 0x0);
			Starling.current.nativeOverlay.addChild(fps);
			try
			{
				var gameState:GameSave = Factory.getInstance(GameSave);
				gameState.loadState();
				var highscoreDB:HighscoreDB = Factory.getInstance(HighscoreDB);			
				if(Util.isIOS)
					highscoreDB.initGameCenter();
				FPSCounter.log("iap");
				var iap:IAP = Factory.getInstance(IAP);
				iap.initInAppPurchase(Util.isIOS?Constants.IOS_PRODUCT_IDS:Constants.ANDROID_LICENSING);			
			}
			catch (err:Error)
			{
				FPSCounter.log(err.message);
			}
			Util.root = this;
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