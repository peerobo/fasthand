package  
{	
	import base.BFConstructor;
	import base.Factory;
	import base.LayerMgr;
	import com.hdi.nativeExtensions.NativeAds;
	import com.hdi.nativeExtensions.NativeAdsEvent;
	import res.asset.ParticleAsset;
	import res.ResMgr;
	import screen.LoadingScreen;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
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
		}
		
		private function onInit(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			Starling.current.nativeOverlay.addChild(new FPSCounter(0, 0, 0xFFFFFF, true, 0x0));
			
			Util.root = this;
			LayerMgr.init(this);
			
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			resMgr.start();
			BFConstructor.init();
			ParticleAsset.loadCfg();
			
			var loadingScreen:LoadingScreen = Factory.getInstance(LoadingScreen);			
			LayerMgr.getLayer(LayerMgr.LAYER_GAME).addChild(loadingScreen);
			
			NativeAds.dispatcher.addEventListener(NativeAdsEvent.AD_RECEIVED,onAdReceived);
			NativeAds.showAd(0,Util.deviceHeight - 75,480,75);
			
			trace("--- init game: stage", Util.appWidth, "x", Util.appHeight, "-", Util.deviceWidth, "x", Util.deviceHeight);
		}
		
		private function onAdReceived(e:NativeAdsEvent):void 
		{
			
		}
		
	}

}