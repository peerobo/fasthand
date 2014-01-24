package fasthand 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.LayerMgr;
	import base.PopupMgr;
	import fasthand.gui.LeaderBoard;
	import fasthand.logic.GameRound;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.ButtonAsset;
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
		private var countTime:Number;				
		private var cat:String;
		
		public var currentPlayerScore:int;
		public var seqs:Array;
		public var isStartGame:Boolean;
		public var roundNo:int;
		
		public var gameOverCallback:Function;
		public var gameOverParams:Array;				
		
		public function Fasthand() 
		{
			gameRound = new GameRound();
		}
		
		public function startNewGame(cat:String):void
		{
			isStartGame = true;
			this.cat = cat;
			currentPlayerScore = 0;
			roundNo = 1;
			startARound();
			Starling.juggler.add(this);
		}
		
		public function startARound():void
		{
			var i:int;
			countTime = 0;
			var stringSeq:Array = (FasthandUtil[cat] as String).split(";");
			
			for (i = 0; i < stringSeq.length; i++) 
			{
				if (stringSeq[i] == "")
				{
					stringSeq.splice(i, 1);
					i--;
				}
			}
			
			var maxTile:int = Constants.TILE_PER_ROUND;
			var remove:int = stringSeq.length - maxTile;
			for (i = 0; i < remove; i++) 
			{
				var rnd:int = Math.random() * stringSeq.length;				
				stringSeq.splice(rnd, 1);
			}			
			
			seqs = stringSeq;
			gameRound.reset(stringSeq);
		}
		
		/* INTERFACE starling.animation.IAnimatable */
		
		public function advanceTime(time:Number):void 
		{
			if (isStartGame)
			{
				countTime += time;
				if (countTime >= 1)
				{
					countTime -= 1;
					gameRound.decreaseScore();
					if (gameRound.isOver)
						gameOver();
				}
			}
		}
		
		public function checkAdvanceRound(word:String):Boolean
		{
			var ret:Boolean = isStartGame && gameRound.checkWord(word);
			if (ret)
			{
				currentPlayerScore += gameRound.score;
				roundNo++;
				if (roundNo > Constants.ROUND_PER_GAME)
					gameOver();
				else
					startARound();
			}
			return ret;
		}
		
		public function get word2Find():String
		{
			return gameRound.mainWord;
		}
		
		private function gameOver():void 
		{
			isStartGame = false;
			Starling.juggler.remove(this);
			
			showLeaderboard();					
		}
		
		private function showLeaderboard():void 
		{
			var leaderboard:LeaderBoard = Factory.getInstance(LeaderBoard);			
			leaderboard.callback = onCloseLeaderBoard;
			leaderboard.setText("Ban dat duoc\n" + currentPlayerScore + "\n diem");
			PopupMgr.addPopUp(leaderboard, true);						
		}
		
		private function onCloseLeaderBoard():void 
		{
			
			if (gameOverCallback is Function)
			{
				gameOverCallback.apply(this, gameOverParams);
			}
		}
		
		public function get gameRoundTime():int
		{
			return gameRound.score;
		}
		
	}

}