package comp 
{
	import base.Factory;
	import base.Graphics4Starling;
	import res.ResMgr;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import flash.display.Graphics;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class LoadingIcon extends LoopableSprite
	{
		private var shape:DisplayObject;				
		private var deegree:int;
		private const RADIUS:int = 8;
		private var W:int = 100;
		private var status:TextField;
		
		public var progressString:String;
		
		public function LoadingIcon() 
		{
			super();
			
			W *= Starling.contentScaleFactor;
			shape = Graphics4Starling.beginDrawing();
			var graphics:Graphics = Graphics4Starling.getGraphicObject(shape);
			graphics.beginFill(0x0, 0.5);
			graphics.drawRect(0, 0, W, W);
			Graphics4Starling.updateGraphics(shape);
			addChild(shape);			
			shape.y = 100;

			status = new TextField(1, 60, "Loading", "Arial", 26, 0x0, true);	
			status.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(status);	
		}
				
		override public function advanceTime(time:Number):void 
		{
			deegree += 2/Starling.contentScaleFactor;
			if(deegree >= 360){
				deegree = 0 + deegree - 360;
			}
			var graphics:Graphics = Graphics4Starling.getGraphicObject(shape);
			graphics.clear();
			var centerR:Number = W >> 1;
			centerR -= RADIUS;
			var origin:Number = W >> 1;
			var rd:Number = Math.PI / 180 * deegree;
			var cx:Number = centerR * Math.cos(rd);
			var cy:Number = centerR * Math.sin(rd);
			graphics.beginFill(0x414141,1);
			graphics.drawCircle(origin + cx, origin + cy, RADIUS);
			graphics.endFill();
			rd = Math.PI / 180 * (deegree - 10);
			cx = centerR * Math.cos(rd);
			cy = centerR * Math.sin(rd);
			graphics.beginFill(0x414141,1);
			graphics.drawCircle(origin + cx, origin + cy, RADIUS - 2*Starling.contentScaleFactor);			
			graphics.endFill();
			rd = Math.PI / 180 * (deegree - 20);
			cx = centerR * Math.cos(rd);
			cy = centerR * Math.sin(rd);
			graphics.beginFill(0x414141,1);
			graphics.drawCircle(origin + cx, origin + cy, RADIUS - 4*Starling.contentScaleFactor);			
			graphics.endFill();
			Graphics4Starling.updateGraphics(shape);								
			var str:String = "";
			if (deegree < 60)
			{
				str = "Loading";
			}
			else if (deegree < 120)
			{
				str = "Loading.";
			}
			else if (deegree < 180)
			{
				str = "Loading..";
			}
			else if (deegree < 240)
			{
				str = "Loading...";
			}
			else if (deegree < 300)
			{
				str = "Loading....";
			}
			else if (deegree < 360)
			{
				str = "Loading.....";
			}	
			str += "\n" + progressString;
			status.text = str;
		}
		
		public function setTextColor(color:int):void
		{
			status.color = color;
		}
		
	}

}