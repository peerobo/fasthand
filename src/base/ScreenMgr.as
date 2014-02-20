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
		public static var currScr:DisplayObject;
		
		public function ScreenMgr()
		{
			
		}
		
		public static function showScreen(c:Class):void
		{			
			var scr:DisplayObject = Factory.getInstance(c) as DisplayObject;			
			if (currScr == scr)
				return;
			if (currScr)
				currScr.removeFromParent();
			LayerMgr.getLayer(LayerMgr.LAYER_GAME).addChild(scr);			
			currScr = scr;
		}
		
	}

}