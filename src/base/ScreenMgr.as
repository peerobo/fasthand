package base 
{
	import flash.utils.getQualifiedClassName;
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author ndp
	 */
	public class ScreenMgr 
	{		
		private static var currScr:DisplayObject;
		
		public function ScreenMgr()
		{
			
		}
		
		public static function showScreen(c:Class):void
		{			
			var scr:DisplayObject = Factory.getInstance(c) as DisplayObject;			
			if (currScr == scr)
				return;
			LayerMgr.getLayer(LayerMgr.LAYER_GAME).addChild(scr);
			if (currScr)
				currScr.removeFromParent();
			currScr = scr;
		}
		
	}

}