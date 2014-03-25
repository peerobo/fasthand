package base 
{
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author ndp
	 */
	public class GlobalInput implements IAnimatable
	{
		public static const INPUT_SWIPE_LEFT:int = 0;
		public static const INPUT_SWIPE_RIGHT:int = 1;
		public static const INPUT_SWIPE_UP:int = 2;
		public static const INPUT_SWIPE_DOWN:int = 3;
		
		private var anchorPt:Point;
		private var directPt:Point;
		private var checkSwipe:Boolean;
		private var disableTimeout:Number;
		private var swipeCallbacks:Array;	// callback object		
		private var keyMap:Object;
		
		public static const SWIPE_AMP:int = 136;
		
		public function GlobalInput() 
		{
			disableTimeout = -1;
			keyMap = { };
			Starling.juggler.add(this);
			FPSCounter.log("add keyboard event");
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);			
		}
		
		public function registerKey(keyCode:uint, f:Function):void
		{
			keyMap[keyCode.toString()] = f;
		}
		
		public function getCurrentKeyHandler(keyCode:uint):Function
		{
			return keyMap[keyCode.toString()];
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			FPSCounter.log("event keyboard capture");
			e.preventDefault();
			e.stopImmediatePropagation();
			for (var key:String in keyMap) 
			{
				if (key == e.keyCode.toString())
				{
					FPSCounter.log("execute keyboard function");
					var f:Function = keyMap[key];
					f.apply(this);
					break;
				}
			}			
		}
		
		public function advanceTime(time:Number):void 
		{			
			if (disableTimeout > 0)
			{
				disableTimeout -= time;
				if (disableTimeout <= 0)
					disable = false;
			}
		}
		
		/**
		 * temporary disable input in seconds
		 * @param	timeout
		 */
		public function setDisableTimeout(timeout:int):void
		{
			this.disableTimeout = timeout;
			disable = true;
		}
		
		public function set disable(bool:Boolean):void
		{
			Util.root.touchable = !bool;
			if (!bool)
			{
				disableTimeout = -1;
			}
		}
		
		public function init():void
		{
			anchorPt = new Point();
			directPt = new Point();
			swipeCallbacks = [];
			Util.root.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		/**
		 * register swipe listener
		 * @param	c callback function(mode:int):void
		 * @param	p params
		 * @return callbackobject (use to unregister later)
		 */
		public function registerSwipe(c:Function,p:Array = null):CallbackObj 
		{
			var callbackObj:CallbackObj = Factory.getObjectFromPool(CallbackObj);
			callbackObj.f = c;
			callbackObj.p = p;		
			swipeCallbacks.push(callbackObj);
			return callbackObj;
		}
		
		/**
		 * unregister swipe
		 * @param	callbackObj callback object
		 */
		public function unregisterSwipe(callbackObj:CallbackObj):void
		{
			var idx:int = swipeCallbacks.indexOf(callbackObj);
			swipeCallbacks.splice(idx, 1);
			Factory.toPool(callbackObj);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(Util.root);
			if (touch)
			{
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						checkSwipe = true;
						anchorPt.x = touch.globalX;
						anchorPt.y = touch.globalY;
					break;
					case TouchPhase.MOVED:
						if(checkSwipe)
						{
							directPt.x = touch.globalX;
							directPt.y = touch.globalY;
							if (directPt.subtract(anchorPt).length >= SWIPE_AMP && !PopupMgr.current)
							{
								swipe();
								checkSwipe = false;
							}
						}					
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
				mode = sub.y < 0 ? INPUT_SWIPE_DOWN : INPUT_SWIPE_UP;
			}
			else
			{
				mode = sub.x < 0 ? INPUT_SWIPE_LEFT : INPUT_SWIPE_RIGHT;
			}			
			swipeComps(mode);
		}
		
		private function swipeComps(mode:int):void 
		{
			var len:int = swipeCallbacks.length;
			for (var i:int = 0; i < len; i++) 
			{				
				var c:CallbackObj = swipeCallbacks[i];
				var clone:Array = !c.p ? [] : c.p.concat();
				clone.splice(0, 0, mode);				
				c.f.apply(this, clone);
			}
		}
	}

}