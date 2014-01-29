package fasthand.screen 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.LangUtil;
	import base.LayerMgr;
	import base.PopupMgr;
	import base.ScreenMgr;
	import base.SoundManager;
	import comp.LoadingIcon;
	import comp.LoopableSprite;
	import comp.SpriteNumber;
	import fasthand.Fasthand;
	import fasthand.gui.GameBoard;
	import fasthand.gui.ScoreWindow;
	import res.Asset;
	import res.asset.ButtonAsset;
	import res.asset.IconAsset;
	import res.asset.SoundAsset;
	import starling.events.Event;
	import starling.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class GameScreen extends LoopableSprite 
	{
		private var gameboard:GameBoard;
		private var scoreBoard:SpriteNumber;
		
		public function GameScreen() 
		{
			super();
			gameboard = new GameBoard();
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			SoundManager.instance.muteMusic = true;
			
			var backBt:BaseButton = ButtonAsset.getBaseBt(ButtonAsset.BT_BACK);			
			backBt.setCallbackFunc(onBackToCategoryScreen);
			addChild(backBt);
			backBt.x = 30;
			backBt.y = 18;						
			
			addChildAt(gameboard,0);
			Util.g_centerScreen(gameboard);
			gameboard.onSelectWord = validateWord;			
			
			Util.showBannerAd();
			preStartGame();
		}
		
		private function validateWord(word:String):void 
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);
			if (logic.checkAdvanceRound(word))
			{
				gameboard.isAnimatedTime = false;
				gameboard.resetTimeCount();
			}
		}
		
		private function onBackToCategoryScreen():void 
		{
			ScreenMgr.showScreen(CategoryScreen);
		}
		
		public function preStartGame():void
		{
			gameboard.onAnimateComplete = startGame;
			gameboard.animate();
		}
		
		public function preStartRound():void
		{
			gameboard.onAnimateComplete = startRound;
			gameboard.animate();
		}
		
		public function startGame():void
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);
			logic.startNewGame();
			
			gameboard.maxTime = logic.gameRoundTime;
			gameboard.resetTimeCount();
			gameboard.isAnimatedTime = true;
			gameboard.setIcons(logic.seqs);
			gameboard.setWord(logic.word2Find);
		}
		
		public function startRound():void
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);
			logic.startARound();
			
			gameboard.maxTime = logic.gameRoundTime;
			gameboard.resetTimeCount();
			gameboard.isAnimatedTime = true;
			gameboard.setIcons(logic.seqs);
			gameboard.setWord(logic.word2Find);
		}
		
		override public function onRemoved(e:Event):void 
		{
			super.onRemoved(e);
			
			SoundManager.instance.muteMusic = false;
			Util.hideBannerAd();
		}
		
	}

}