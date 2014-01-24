package comp 
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class LoopableSprite extends Sprite implements IAnimatable 
	{
		
		public function LoopableSprite() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}				
		
		public function onRemoved(e:Event):void 
		{
			Starling.juggler.remove(this);
			
		}
		
		public function onAdded(e:Event):void 
		{
			Starling.juggler.add(this);			
		}
		
		/* INTERFACE starling.animation.IAnimatable */
		
		public function advanceTime(time:Number):void 
		{
			
		}
	}

}