package fasthand.logic 
{
	/**
	 * ...
	 * @author ndp
	 */
	public class GameRound 
	{
		public var mainWord:String;
		public var score:int;
		
		public function GameRound() 
		{
			
		}
		
		public function reset(stringSeq:Array):void 
		{
			var idx:int = Math.random() * stringSeq.length;
			mainWord = stringSeq[idx];
			score = Constants.SEC_PER_ROUND;
		}
		
		public function checkWord(word:String):Boolean
		{
			return (mainWord == word);		
		}
		
		public function decreaseScore():void
		{
			score--;
		}
		
		public function get isOver():Boolean
		{
			return score <= 0;
		}
	}

}