package base
{
	import base.font.BaseBitmapTextField;
	import comp.LoopableSprite;
	import comp.ShakeObject;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	public class BaseButton extends LoopableSprite
	{
		public static const PADDNG:int = 24;
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
		private var cMF:ColorMatrixFilter;
		public var destroyOnRemove:Boolean;
		
		public function BaseButton()
		{
			super();
			destroyOnRemove = true;
			initTouch();
			hoverFilter = Util.getFilter(Util.HOVER_FILTER);
			downFilter = Util.getFilter(Util.isDesktop ? Util.DOWN_FILTER : Util.HOVER_FILTER);
			disableFilter = Util.getFilter(Util.DISABLE_FILTER);			
		}
		
		override public function dispose():void 
		{
			destroy();
		}
		
		override public function onRemoved(e:Event):void 
		{
			if(destroyOnRemove)
			{
				super.onRemoved(e);
				destroy();
			}
		}
		
		public function destroy():void
		{
			callbackFunc = null;
			params = null;	
			cMF = null;
			hoverFilter = null;
			disableFilter = null;
			downFilter = null;
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
							this.filter = cMF;
							var newAnchor:Point = new Point(touch.globalX,touch.globalY);
							if (newAnchor.subtract(anchor).length < GlobalInput.SWIPE_AMP)
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
					this.filter = !_isDisable ? cMF: disableFilter;
				else
					this.filter = !_isDisable ? (isSelected ? downFilter : cMF) : disableFilter;
			}
		}
		
		public function setLabel(txt:TextField):void
		{
			if (label != null)
			{
				label.removeFromParent();
			}
			label = txt;
			label.batchable = true;
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
		
		public function set colorFilter(colorFilter:ColorMatrixFilter):void
		{
			cMF = colorFilter;
			this.filter = cMF;
			var colorMF:ColorMatrixFilter = hoverFilter as ColorMatrixFilter;
			colorMF.concat(cMF.matrix);
			colorMF = downFilter as ColorMatrixFilter;
			colorMF.concat(cMF.matrix);			
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
		
		public function setText(text:String, autoSizeBt:Boolean = false):void
		{
			if (!label)
			{
				if (autoSizeBt)
				{
					var l:BaseBitmapTextField = BFConstructor.getTextField(1, 1, text, BFConstructor.ARIAL, 0xFFFF80);
					l.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					background.width = l.width + PADDNG *3/2;
					background.height = l.height + PADDNG*3/2;
					setLabel(l);									
				}
				else
				{
					setLabel(BFConstructor.getTextField(background.width, background.height, text, BFConstructor.ARIAL, 0xFFFF80));				
				}
				
			}
			else
			{
				if (autoSizeBt)
				{
					label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					label.text = text;
					background.width = label.width + PADDNG*3/2;
					background.height = label.height + PADDNG*3/2;
				}
				else
				{
					label.autoSize = TextFieldAutoSize.NONE;
					
					label.width = background.width;
					label.height = background.height;
					label.text = text;
				}
				
			}
			
			if (autoSizeBt)
			{
				
				label.x = PADDNG >> 1;
				label.y = PADDNG >> 1;
			}
			else
			{				
				label.x = 0;
				label.y = 0;
			}
		}
	}
}