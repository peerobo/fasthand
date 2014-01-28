package base 
{
	import flash.geom.Point;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author ndp
	 */
	public class GlobalInput 
	{
		public static const INPUT_SWIPE_LEFT:int = 0;
		public static const INPUT_SWIPE_RIGHT:int = 1;
		public static const INPUT_SWIPE_UP:int = 2;
		public static const INPUT_SWIPE_DOWN:int = 3;
		
		private var anchorPt:Point;
		private var directPt:Point;
		
		private const AMP:int = 10;
		
		public function GlobalInput() 
		{			
		}
		
		public function init():void
		{
			anchorPt = new Point();
			directPt = new Point():
			Util.root.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(Util.root);
			if (touch)
			{
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						anchorPt.x = touch.globalX;
						anchorPt.y = touch.globalY;
					break;
					case TouchPhase.MOVED:
						directPt.x = touch.globalX;
						directPt.y = touch.globalY;
						if (directPt.subtract(anchorPt).length > AMP)
							swipe();
					break;
					case TouchPhase.ENDED:
						
					break;
				}
				
			}
		}
		
		private function swipe():void 
		{
			var sub:Point = anchorPt.subtract(directPt);
			var mode:int;
			if (Math.abs(sub.x) < Math.abs(sub.y))
			{
				mode = sub.y < 0 ? INPUT_SWIPE_DOWN :INPUT_SWIPE_UP;
			}
			else
			{
				mode = sub.x < 0 ? INPUT_SWIPE_LEFT :INPUT_SWIPE_RIGHT;
			}
			
			swipeComps(mode);
		}
		
		private function swipeComps(mode:int):void 
		{
			
		}
	}

}