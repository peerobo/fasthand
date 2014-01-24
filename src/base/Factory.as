package base 
{	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.EventDispatcher;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;	
	/**
	 * 
	 * @author PhuongND
	 */
	public class Factory implements IAnimatable 
	{
		private var map:Object;	// "key" => { obj: Object, time: int}
		private var mapPersistent:Object; // "key" => obj
		private var touchDict:Dictionary = new Dictionary();	// touchObj => [f,p];
		
		private static var _ins:Factory;
		private static function get ins():Factory {
			if(!_ins) _ins = new Factory();
			return _ins;
		}
		private static const DESTROYTIME:int = 5 * 60 * 1000;		
		
		public function Factory() 
		{			
			Starling.juggler.add(this);
			map = new Object();
			mapPersistent = new Object();
		}
						
		public function getTmpInstance(C:Class):*
		{
			var key:String = getQualifiedClassName(C);
			var obj:*= null;
			
			if (map.hasOwnProperty(key))
			{
				obj = map[key]["obj"];
				map[key]["time"] = 0;
			}
			else
			{
				obj = new C();
				map[key] = {
					obj: obj,
					time: 0
				};
			}
			return obj;
		}
		
		public static function getTmpInstance(C:Class):*
		{
			return ins.getTmpInstance(C);
		}
		
		public static function getInstance(C:Class):*
		{
			return ins.getInstance(C);
		}
		
		public function getInstance(C:Class):* 
		{
			var key:String = getQualifiedClassName(C);
			var obj:*= null;
			
			if (mapPersistent.hasOwnProperty(key))
			{
				obj = mapPersistent[key];				
			}
			else
			{
				obj = new C();
				mapPersistent[key] = obj;
			}
			return obj;
		}

		public static function addMouseClickCallback(eventDispatcher:EventDispatcher, f:Function, p:Array = null):void
		{
			eventDispatcher.addEventListener(TouchEvent.TOUCH, onMouseClickCallback);
			ins.touchDict[eventDispatcher] = [f, p];
		}
		
		public static function removeMouseClickCallback(eventDispatcher:EventDispatcher):void
		{
			eventDispatcher.removeEventListener(TouchEvent.TOUCH, onMouseClickCallback);
			delete ins.touchDict[eventDispatcher];
		}
		
		static private function onMouseClickCallback(e:TouchEvent):void 
		{
			if (e.getTouch(e.currentTarget as DisplayObject, TouchPhase.ENDED))
			{
				var arrCall:Array = ins.touchDict[e.currentTarget];
				arrCall[0].apply(ins,arrCall[1]);
			}
		}		
		
		/* INTERFACE starling.animation.IAnimatable */
		
		public function advanceTime(time:Number):void 
		{
			var dt:int = time * 1000;
			for (var key:String in map) 
			{
				map[key]["time"] += dt;
				if (map[key]["time"] >= DESTROYTIME)
					delete map[key];
			}
		}
		
	}

}