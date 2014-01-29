package  
{	
	import base.BFConstructor;
	import base.Factory;
	import base.GlobalInput;
	import base.LayerMgr;	
	import base.ScreenMgr;
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
		
		public function App() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onInit);
			this.alpha = 0.9999;			
		}				
		
		private function onInit(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			Starling.current.nativeOverlay.addChild(new FPSCounter(0, 0, 0xFFFFFF, true, 0x0));
			
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