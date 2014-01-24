package base 
{
	/**
	 * ...
	 * @author ducnh
	 */
	public class LangUtil 
	{
		public static var localizeData:Object = new Object();
		
		public static function init(xml:XML):void
		{
			var x:XML = xml.child("VietNamese")[0];
			var xList:XMLList = x.*;
			var i:int;
			for (i = 0; i < xList.length(); i++)
			{
				var s:String = xList[i].children()[0];
				if(s) {
					s = s.replace("[sp]", " ");					
					s = s.replace(/\\n/g,"\n");
					s = s.replace(/\\t/g,"\t");
				}
				localizeData[xList[i].name()] = s;
			}
		}
		
		public static function getText(key:String):String
		{
			if (localizeData.hasOwnProperty(key))
			{
				return localizeData[key];
			}else
			{
				return key;
			}
			
		}				
	}

}