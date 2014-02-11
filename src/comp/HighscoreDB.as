package comp 
{
	/**
	 * ...
	 * @author ndp
	 */
	public class HighscoreDB 
	{
		private var highscoreMap:Object;
		
		public function HighscoreDB() 
		{
			highscoreMap = { };
		}
		
		public function registerType(type:String):void
		{
			if (!highscoreMap.hasOwnProperty(type))
			{
				highscoreMap[type] = 0;
			}
		}
		
		public function getHighscore(type:String):String
		{
			return highscoreMap[type];
		}
		
		public function setHighscore(type:String, value:int):void
		{
			highscoreMap[type ] = value;
		}
		
		public function saveHighscore():void
		{
			for (var s:String in highscoreMap) 
			{
				Util.setPrivateValue(s, highscoreMap[s]);
			}			
		}
		
		public function loadHighscore():void
		{
			for (var s:String in highscoreMap) 
			{
				var tmpVal:String = Util.getPrivateKey(s);
				var val:int = parseInt(tmpVal);
				highscoreMap[s] = isNaN(val) ? 0 : val;
			}			
		}
		
	}

}