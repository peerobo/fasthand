package fasthand.screen 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.LayerMgr;
	import base.SoundManager;
	import comp.LoopableSprite;
	import comp.TileImage;	
	import fasthand.Fasthand;
	import fasthand.gui.MainScreenContent;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.SoundAsset;
	import res.ResMgr;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class MainScreen extends LoopableSprite
	{						
		private var mainScreen:MainScreenContent;
		
		public function MainScreen() 
		{			
			SoundManager.playSound(SoundAsset.THEME_SONG, true, 0, 0.7);
			mainScreen = new MainScreenContent();
			
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);						
			
			addChild(mainScreen);
			Util.g_centerScreen(mainScreen);
			
			mainScreen.slowBt.setCallbackFunc(onEnterGame,[false]);
			mainScreen.fastBt.setCallbackFunc(onEnterGame,[true]);
		}
		
		private function onEnterGame(isFast:Boolean):void 
		{
			SoundManager.playSound(SoundAsset.SOUND_CLICK);
			var fastHand:Fasthand = Factory.getInstance(Fasthand);
			fastHand.difficult = isFast;
			
			var catScrn:CategoryScreen = Factory.getInstance(CategoryScreen);
			LayerMgr.getLayer(LayerMgr.LAYER_GAME).addChild(catScrn);
			this.removeFromParent();
		}
		
		override public function onRemoved(e:Event):void 
		{
			mainScreen.removeFromParent();			
			
			super.onRemoved(e);			
		}
		
	}

}