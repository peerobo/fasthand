package base
{
	import comp.ShakeObject;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class BaseButton extends Sprite
	{
		public var btnId:String = "";
		public var icons:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		public var label:TextField;
		public var callbackFunc:Function = null;
		private var _isDisable:Boolean;
		private var _isTab:Boolean
		private var _isSelected:Boolean; // for tab mode only
		private var hoverFilter:FragmentFilter;
		private var disableFilter:FragmentFilter;
		private var downFilter:FragmentFilter;
		private var params:Array;
		private var shakeObj:ShakeObject;
		public var gui:BaseJsonGUI;
		private var anchor:Point;
		
		public function BaseButton()
		{
			super();
			initTouch();
			hoverFilter = Util.getFilter(Util.HOVER_FILTER);
			downFilter = Util.getFilter(Util.DOWN_FILTER);
			disableFilter = Util.getFilter(Util.DISABLE_FILTER);
		}
		
		public function destroy():void
		{
			callbackFunc = null;
			params = null;
			
			for each(var disp:DisplayObject in icons)
			{
				Factory.toPool(disp);
				disp.removeFromParent();
			}									
			icons = new Vector.<DisplayObject>();
			if(label)
			{	
				Factory.toPool(label);
				label.removeFromParent();
			}
			label = null;
			filter = null;
		}			
		public function setCallbackFunc(func:Function, params:Array = null):void
		{
			this.params = params;
			callbackFunc = func;
		}
		
		private function initTouch():void
		{
			this.addEventListener(TouchEvent.TOUCH, onClick);
		}
				
		protected function onClick(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (touch)
			{
				switch (touch.phase)
				{
					case TouchPhase.HOVER: 
						this.filter = !_isDisable ? hoverFilter : this.filter;
						break;
					case TouchPhase.ENDED: 
						if (!_isDisable)
						{
							this.filter = null;
							var newAnchor:Point = new Point(touch.globalX,touch.globalY);
							if (newAnchor.equals(anchor))
							{
								if (callbackFunc != null)
								{
									callbackFunc.apply(this, params);
								}
							}
						}
						
						break;
					case TouchPhase.BEGAN: 
						if (!_isDisable)
						{
							this.filter = downFilter;
							anchor = new Point(touch.globalX,touch.globalY);
						}
						break;
				}
			}
			else
			{
				if (!isTab)
					this.filter = !_isDisable ? null : disableFilter;
				else
					this.filter = !_isDisable ? (isSelected ? downFilter : null) : disableFilter;
			}
		}
		
		public function setLabel(txt:TextField):void
		{
			if (label != null)
			{
				label.removeFromParent();
			}
			label = txt;
			addChild(label);
		}
		
		public function addIcon(icon:DisplayObject):void
		{
			icons.push(icon);
			this.addChild(icon);
		}
		
		public function get isDisable():Boolean
		{
			return _isDisable;
		}
		
		public function set isDisable(value:Boolean):void
		{
			_isDisable = value;
			if (isTab)
				filter = value ? downFilter : (isDisable ? disableFilter : null);
			else
				this.filter = _isDisable ? disableFilter : null;
		}
		
		public function get isTab():Boolean
		{
			return _isTab;
		}
		
		public function set isTab(value:Boolean):void
		{
			_isTab = value;
		}
		
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			_isSelected = value;
			if (isTab)
				filter = value ? downFilter : (isDisable ? disableFilter : null);
		}
		
		public function shake(amp:int = 10, sTime:int = 400, dt:int = 12, delayMil:int = 0, numShake:int = 1):void
		{
			if (shakeObj == null)
			{
				shakeObj = new ShakeObject();
				shakeObj.AMP = amp;
				shakeObj.shake(this, sTime, dt, delayMil, numShake);
				shakeObj.setCallback(onStopShake);
			}
		}
		
		public function stopShaking():void
		{
			if (shakeObj)
				shakeObj.stopShake();
		}
		
		private function onStopShake():void
		{
			shakeObj = null;
		}
		
		public function get background():DisplayObject
		{
			return icons[0];
		}
		
		public function set text(text:String):void
		{
			if (!label)
			{
				setLabel(BFConstructor.getTextField(background.width, background.height, text,BFConstructor.BANHMI));
			}
			else
			{
				label.width = background.width;
				label.height = background.height;
				label.text = text;
			}
		}
	}
}