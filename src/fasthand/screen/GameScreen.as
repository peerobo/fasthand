package fasthand.screen 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.EffectMgr;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.GlobalInput;
	import base.LangUtil;
	import base.LayerMgr;
	import base.PopupMgr;
	import base.ScreenMgr;
	import base.SoundManager;
	CONFIG::isAndroid {
		import com.fc.FCAndroidUtility;
	}
	import comp.GameService;
	import comp.LoadingIcon;
	import comp.LoopableSprite;
	import comp.SpriteNumber;
	import fasthand.comp.PauseDialog;
	import fasthand.Fasthand;
	import fasthand.FasthandUtil;
	import fasthand.gui.GameBoard;	
	import flash.geom.Point;
	import flash.system.System;
	import flash.ui.GameInput;
	import flash.ui.Keyboard;
	import res.Asset;
	import res.asset.ButtonAsset;
	import res.asset.IconAsset;
	import res.asset.SoundAsset;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Color;
	import starling.utils.HAlign;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class GameScreen extends LoopableSprite 
	{
		private var gameboard:GameBoard;
		private var scoreBoard:SpriteNumber;
		private var scoreTxt:BaseBitmapTextField;

		
		public function GameScreen() 
		{
			super();
			gameboard = new GameBoard();
			//gameboard.visible = false;			
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			//var disp:DisplayObject = Asset.getImage(Asset.WALL_GAME, Asset.WALL_GAME);
			
			var disp:Quad = Factory.getObjectFromPool(Quad);
			disp.color = 0xF5DC4B;
			disp.width = Util.appWidth;
			disp.height = Util.appHeight;
			addChildAt(disp, 0);
			//Util.g_centerScreen(disp);
			
			SoundManager.instance.muteMusic = true;						
			
			var backBt:BaseButton = ButtonAsset.getBaseBt(ButtonAsset.BT_BACK);			
			backBt.setCallbackFunc(onBackBt);
			addChild(backBt);
			backBt.x = 30;
			backBt.y = 18;						
			
			var pauseBt:BaseButton = ButtonAsset.getBaseBt(ButtonAsset.BT_PAUSE);			
			pauseBt.setCallbackFunc(onPause);
			addChild(pauseBt);
			pauseBt.x = backBt.x + backBt.width + 12;
			pauseBt.y = backBt.y;		
			
			scoreTxt = BFConstructor.getTextField(1, pauseBt.height, "score: " + Constants.MAX_SCORE_PER_ROUND * Constants.ROUND_PER_GAME, BFConstructor.ARIAL, Color.RED);
			scoreTxt.autoSize = TextFieldAutoSize.HORIZONTAL;
			var w:int = scoreTxt.width;
			scoreTxt.autoSize = TextFieldAutoSize.NONE;
			scoreTxt.width = w;
			scoreTxt.hAlign = HAlign.RIGHT;			
			scoreTxt.x = Util.appWidth - scoreTxt.width - backBt.x;
			scoreTxt.y = pauseBt.y;
			addChild(scoreTxt);
			
			addChildAt(gameboard, 1);
			relayoutGameboard(Util.isBannerAdShowed);			
			gameboard.onSelectWord = validateWord;			
			
			//Util.showBannerAd();
			preStartGame();
			
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			//globalInput.registerKey(Keyboard.BACK, onBackBt);
			globalInput.handleBackKey(onBackBt);
			//CONFIG::isAndroid {
				//FCAndroidUtility.instance.isHandleBackKey = true;
				//FCAndroidUtility.instance.onBackKeyHandle = onBackBt;
			//}
			
			Util.registerRelayoutAfterAd(relayoutGameboard, false);
		}
		
		private function relayoutGameboard(bool:Boolean):void 
		{
			Util.g_centerScreen(gameboard);
			if (bool)
				gameboard.y -= Util.adBannerHeight;
		}
		
		public function onPause():void 
		{
			SoundManager.playSound(SoundAsset.SOUND_CLICK);
			var pauseDlg:PauseDialog = Factory.getInstance(PauseDialog);
			pauseDlg.callbackUnPaused = resume;
			PopupMgr.addPopUp(pauseDlg);
			
			pause();
		}
		
		private function validateWord(word:String, item:DisplayObject):void 
		{
			var globalIpt:GlobalInput = Factory.getInstance(GlobalInput);
			globalIpt.setDisableTimeout(Constants.DISABLE_INPUT_EACH_TOUCH);			
			
			var logic:Fasthand = Factory.getInstance(Fasthand);
			var score:int = logic.remainingRoundScore;
			if (logic.checkAdvanceRound(word))	// right word
			{					
				gameboard.isAnimatedTime = false;
				gameboard.resetTimeCount();				
				
				var touchPos:Point = item.localToGlobal(new Point(item.width>>1, item.height>>1));
				EffectMgr.floatTextMessageEffect("+" + score.toString(), touchPos);
			}
			else	// wrong word
			{
				gameboard.animateWrongWord(item);				
			}
		}
		
		private function onBackBt():void 
		{
			FPSCounter.log("back bt pressed");
			Util.g_showConfirm(LangUtil.getText("confirmQuit"), onConfirmQuit);
			pause();
			
			SoundManager.playSound(SoundAsset.SOUND_CLICK);
		}
		
		private function onConfirmQuit(isQuit:Boolean):void 
		{
			if (isQuit)
			{
				gameboard.resetTimeCount();
				gameboard.isAnimatedTime = false;
				var logic:Fasthand = Factory.getInstance(Fasthand);
				logic.gameOver(true);
				ScreenMgr.showScreen(CategoryScreen);				
			}
			else
			{
				resume();
			}
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
			
			gameboard.maxTime = logic.GAME_ROUND_TIME;
			gameboard.resetTimeCount();
			gameboard.isAnimatedTime = true;
			gameboard.setIcons(logic.seqs);
			gameboard.setWord(logic.word2Find);
			
			//var gameService:GameService = Factory.getInstance(GameService);			
			//if (logic.difficult)			
				//gameService.unlockAchievement(FasthandUtil.ACH_FEARLESS);		
		}
		
		public function startRound():void
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);
			logic.startARound();
			
			gameboard.maxTime = logic.GAME_ROUND_TIME;
			gameboard.resetTimeCount();
			gameboard.isAnimatedTime = true;
			gameboard.setIcons(logic.seqs);
			gameboard.setWord(logic.word2Find);
		}
		
		override public function onRemoved(e:Event):void 
		{
			super.onRemoved(e);
			
			SoundManager.instance.muteMusic = false;
			//Util.hideBannerAd();
			Util.registerRelayoutAfterAd(relayoutGameboard, true);
		}
		
		public function endGame():void
		{
			if (gameboard)
				gameboard.reset();
		}
		
		public function pause():void 
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);
			logic.pause = true;
			
			gameboard.pause();
		}
		
		public function resume():void 
		{			
			var logic:Fasthand = Factory.getInstance(Fasthand);
			logic.pause = false;
			
			gameboard.resume();
		}
		
		override public function update(time:Number):void 
		{
			super.update(time);
			var logic:Fasthand = Factory.getInstance(Fasthand);
			scoreTxt.text = LangUtil.getText("score") + " " + logic.currentPlayerScore.toString();
			System.pauseForGCIfCollectionImminent(1);
		}
	}

}