package fasthand 
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
	import fasthand.gui.LeaderBoard;
	import fasthand.gui.ScoreWindow;
	import fasthand.logic.GameRound;
	import fasthand.screen.CategoryScreen;
	import fasthand.screen.GameScreen;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.ButtonAsset;
	import res.asset.SoundAsset;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ndp
	 */
	public class Fasthand implements IAnimatable
	{
		private var gameRound:GameRound;		
		private var interval:Number;				
		private var roundTime:Number;
		public var cat:String;
		public var difficult:Boolean;
		public var currentPlayerScore:int;
		public var seqs:Array;
		public var isStartGame:Boolean;
		public var roundNo:int;
		
		public var gameOverCallback:Function;
		public var gameOverParams:Array;
		
		public var highscore:int;
		public var hightscoreDifficult:int;
		
		private var timeoutSound:SoundChannel;
		
		public function Fasthand() 
		{
			gameRound = new GameRound();
						
			var tmp:String = Util.getPrivateKey("highscore");
			highscore = tmp ?  parseInt(tmp) :  0;
			tmp = Util.getPrivateKey("highscoreDiff");
			hightscoreDifficult = tmp ?  parseInt(tmp) : 0;			
		}
		
		public function startNewGame():void
		{
			isStartGame = true;			
			currentPlayerScore = 0;
			roundNo = 1;
			startARound();
			Starling.juggler.add(this);
		}
		
		public function startARound():void
		{
			var i:int;
			interval = 0;
			var stringSeq:Array = FasthandUtil.getListWords(cat).concat();
			
			var maxTile:int = Constants.TILE_PER_ROUND;
			roundTime = difficult ? Constants.SEC_PER_ROUND_DIFFICULT : Constants.SEC_PER_ROUND;
			var remove:int = stringSeq.length - maxTile;
			for (i = 0; i < remove; i++) 
			{
				var rnd:int = Math.random() * stringSeq.length;				
				stringSeq.splice(rnd, 1);
			}			
			// shuffle
			var shuffleArr:Array = [];
			var len:int = stringSeq.length;
			while(len > 0)
			{				
				var idx:int = Math.random() * len;
				shuffleArr.push(stringSeq[idx]);
				stringSeq.splice(idx, 1);
				len-- ;
			}
			
			seqs = shuffleArr;
			gameRound.reset(shuffleArr);
			SoundManager.playSound(SoundAsset.getName(cat, gameRound.mainWord));
		}
		
		/* INTERFACE starling.animation.IAnimatable */
		
		public function advanceTime(time:Number):void 
		{
			if (isStartGame)
			{
				interval += time;
				if (interval >= 1)
				{
					interval -= 1;
					roundTime -= 1;	
					if (roundTime <= 3 && !timeoutSound)
					{
						timeoutSound = SoundManager.playSound(SoundAsset.SOUND_TIMEOUT);
					}
					if (roundTime < 0)
						gameOver();
				}
			}
		}
		
		public function checkAdvanceRound(word:String):Boolean
		{
			var ret:Boolean = isStartGame && gameRound.checkWord(word);			
			if (ret)
			{								
				currentPlayerScore += roundTime / gameRoundTime * Constants.MAX_SCORE_PER_ROUND;
				roundNo++;				
				if (roundNo > Constants.ROUND_PER_GAME)
				{
					gameOver();
				}
				else
				{
					var gameScreen:GameScreen = Factory.getInstance(GameScreen);
					gameScreen.preStartRound();
					if(timeoutSound)
					{
						timeoutSound.stop()
						timeoutSound = null;
					}
				}
			}			
			else
			{
				SoundManager.playSound(SoundAsset.getName(cat, word));
			}
			return ret;
		}
		
		public function get word2Find():String
		{
			return gameRound.mainWord;
		}
		
		public function gameOver(noScoreWnd:Boolean = false):void 
		{
			isStartGame = false;
			Starling.juggler.remove(this);
			if(timeoutSound)
			{
				timeoutSound.stop()
				timeoutSound = null;
			}
			var gameScreen:GameScreen = Factory.getInstance(GameScreen);
			gameScreen.endGame();
			if(!noScoreWnd)
				showScoreWindow();		
			if(!difficult)
				highscore = currentPlayerScore > highscore ? currentPlayerScore : highscore;
			else
				hightscoreDifficult = currentPlayerScore > hightscoreDifficult ? currentPlayerScore : hightscoreDifficult;										
		}
		
		private function showScoreWindow():void 
		{
			var scoreWnd:ScoreWindow = Factory.getInstance(ScoreWindow);
			PopupMgr.addPopUp(scoreWnd, true);
			scoreWnd.setTitle(LangUtil.getText(cat));
			scoreWnd.setScore(currentPlayerScore, difficult ? hightscoreDifficult : highscore);
			
			scoreWnd.closeCallback = onUserCloseWindow;
		}
		
		private function onUserCloseWindow():void 
		{
			var scoreWnd:ScoreWindow = Factory.getInstance(ScoreWindow);
			if (!scoreWnd.isChangeSubject)
			{
				var gameScreen:GameScreen = Factory.getInstance(GameScreen);
				gameScreen.preStartGame();
			}
			else
			{
				ScreenMgr.showScreen(CategoryScreen);
			}				
		}
		
		private function onCloseLeaderBoard():void 
		{			
			if (gameOverCallback is Function)
			{
				gameOverCallback.apply(this, gameOverParams);
			}
		}
		
		/**
		 * time for each round
		 */
		public function get gameRoundTime():int
		{
			return difficult ? Constants.SEC_PER_ROUND_DIFFICULT : Constants.SEC_PER_ROUND;
		}				
		
	}

}