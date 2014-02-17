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
	import comp.HighscoreDB;
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
		private var _cat:String;
		public var difficult:Boolean;
		public var currentPlayerScore:int;
		public var seqs:Array;
		public var isStartGame:Boolean;
		public var roundNo:int;
		
		public var gameOverCallback:Function;
		public var gameOverParams:Array;
		
		public var highscore:int;			
		private var _pause:Boolean;
		
		public function Fasthand() 
		{
			gameRound = new GameRound();
			initHighscore();
			_pause = false;
		}
		
		private function initHighscore():void 
		{
			var highscoreDB:HighscoreDB = Factory.getInstance(HighscoreDB);
			for each (var s:String in FasthandUtil.getListCat())
			{
				highscoreDB.registerType(s);				
			}									
			highscoreDB.loadHighscore();
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
			roundTime = GAME_ROUND_TIME;
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
			var prevWord:String = word2Find;			
			gameRound.reset(shuffleArr);
			while (prevWord == word2Find)
				gameRound.reset(shuffleArr);
			
			SoundManager.playSound(SoundAsset.getName(cat, word2Find));
		}
		
		/* INTERFACE starling.animation.IAnimatable */
		
		public function advanceTime(time:Number):void 
		{
			if (isStartGame)
			{
				roundTime -= time;	
				
				if (roundTime < 0)
					gameOver();				
			}
		}
		
		public function get remainingRoundScore():int
		{
			return (roundTime / GAME_ROUND_TIME * Constants.MAX_SCORE_PER_ROUND) / (difficult ? 1 : 2) + 1;
		}
		
		public function checkAdvanceRound(word:String):Boolean
		{
			var ret:Boolean = isStartGame && gameRound.checkWord(word);			
			if (ret)
			{								
				currentPlayerScore += remainingRoundScore;
				roundNo++;				
				if (roundNo > Constants.ROUND_PER_GAME)
				{
					gameOver();
				}
				else
				{
					var gameScreen:GameScreen = Factory.getInstance(GameScreen);
					gameScreen.preStartRound();					
				}
			}			
			else
			{
				SoundManager.playSound(SoundAsset.getName(cat, word));
				penalty();
			}
			return ret;
		}
		
		private function penalty():void 
		{
			roundTime -= Constants.PENALTY_TIME;
		}
		
		public function get word2Find():String
		{
			return gameRound.mainWord;
		}
		
		public function gameOver(noScoreWnd:Boolean = false):void 
		{
			var hScoreDB:HighscoreDB = Factory.getInstance(HighscoreDB);
			var hScoreType:String = cat;
			highscore = hScoreDB.getHighscore(hScoreType);
			highscore = currentPlayerScore > highscore ? currentPlayerScore : highscore;			
			isStartGame = false;
			Starling.juggler.remove(this);			
			var gameScreen:GameScreen = Factory.getInstance(GameScreen);
			gameScreen.endGame();
			if(!noScoreWnd)
				showScoreWindow();			
			
			hScoreDB.setHighscore(hScoreType, highscore);
		}
		
		private function showScoreWindow():void 
		{
			var hScoreDB:HighscoreDB = Factory.getInstance(HighscoreDB);
			var hScoreType:String = cat;
			var scoreWnd:ScoreWindow = Factory.getInstance(ScoreWindow);			
			PopupMgr.addPopUp(scoreWnd, true);
			scoreWnd.setTitle(cat);			
			scoreWnd.celebrate = hScoreDB.getHighscore(hScoreType) < highscore;
			scoreWnd.setScore(currentPlayerScore, highscore, getPlayedSubjectNum());
			
			scoreWnd.closeCallback = onUserCloseWindow;
		}
		
		private function getPlayedSubjectNum():int
		{
			var str:String = Util.getPrivateKey(Constants.SUBJECT_STR);
			var arr:Array = str.split(";");
			return arr.length;
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
		public function get GAME_ROUND_TIME():int
		{
			return difficult ? Constants.SEC_PER_ROUND_DIFFICULT : Constants.SEC_PER_ROUND;
		}				
		
		public function get pause():Boolean 
		{
			return _pause;
		}
		
		public function set pause(value:Boolean):void 
		{
			if(_pause !=value)
			{
				_pause = value;				
				if (value)
				{				
					Starling.juggler.remove(this);					
				}
				else
				{
					Starling.juggler.add(this);					
				}
			}
		}
		
		public function get cat():String 
		{
			return _cat;
		}
		
		public function set cat(value:String):void 
		{
			_cat = value;
			var str:String = Util.getPrivateKey(Constants.SUBJECT_STR);
			str = str == null ? "":str;			
			var arr:Array = str.split(";");
			for (var i:int = 0; i < arr.length; i++) 
			{
				if (arr[i] == "")
					arr.splice(i, 1);
				if (_cat == arr[i])
					return;
			}
			arr.push(cat);
			str = arr.length > 1 ? arr.join(";"):arr[0];
			Util.setPrivateValue(Constants.SUBJECT_STR, str);
		}
		
	}

}