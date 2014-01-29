package fasthand.logic 
{
	/**
	 * ...
	 * @author ndp
	 */
	public class GameRound 
	{
		public var mainWord:String;
		
		public function GameRound() 
		{
			
		}
		
		public function reset(stringSeq:Array):void 
		{
			var idx:int = Math.random() * stringSeq.length;
			mainWord = stringSeq[idx];			
		}
		
		public function checkWord(word:String):Boolean
		{
			return (mainWord == word);		
		}		
	}

}