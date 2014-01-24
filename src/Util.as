package  
{
	import flash.net.SharedObject;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	/**
	 * ...
	 * @author ndp
	 */
	public class Util 
	{
		public static const HOVER_FILTER:int = 0;
		public static const DISABLE_FILTER:int = 1;
		public static const DOWN_FILTER:int = 2;	
		
		public static var root:Sprite;
		
		public static function getFilter(type:int):FragmentFilter
		{
			var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
			switch (type) 
			{
				case HOVER_FILTER:
					colorMatrixFilter.adjustBrightness(0.1);
					colorMatrixFilter.adjustContrast(0.05);	
				break;
				case DISABLE_FILTER:
					colorMatrixFilter.adjustSaturation(-1);
				break;
				case DOWN_FILTER:
					colorMatrixFilter.adjustBrightness(0.2);
					colorMatrixFilter.adjustContrast(0.4);	
				break;				
			}
			return colorMatrixFilter;
		}
		
		public function Util() 
		{
			
		}
		
		public static function get appWidth():int
		{
			return Starling.current.stage.stageWidth;
		}
		
		public static function get appHeight():int
		{
			return Starling.current.stage.stageHeight;
		}
		
		public static function get deviceWidth():int
		{
			return Starling.current.nativeStage.fullScreenWidth;
		}
		
		public static function get deviceHeight():int
		{
			return Starling.current.nativeStage.fullScreenHeight;
		}
		
		public static function getLocalData(soName:String):SharedObject
		{			
			var result:SharedObject = SharedObject.getLocal(App.APP_NAME + "_" + soName);
			return result;
		}
		
	}

}