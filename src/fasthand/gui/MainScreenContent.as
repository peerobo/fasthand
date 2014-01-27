package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.font.BaseBitmapTextField;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class MainScreenContent extends BaseJsonGUI 
	{
		public var welcomeTxt:BaseBitmapTextField;
		public var slowBt:BaseButton;
		public var fastBt:BaseButton;
		
		private const COLOR_RND:Array = [0xFF0000,0xFF8080,0x0080FF,0xFFFF80,0x8000FF,0xFF8000,0x8000FF,0x408080,0x80FF00];
		
		public function MainScreenContent() 
		{
			super("MainScreen");			
			interval = 0.1;
		}				
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			var str:String = welcomeTxt.text;
			var idx:int = str.indexOf("\n");
			welcomeTxt.colors = [];
			welcomeTxt.colorRanges = [];
			var len:int = COLOR_RND.length;
			for (var i:int = 0; i < idx; i++) 
			{
				var cIDx:int = Math.random() * len;
				var c:int = COLOR_RND[cIDx];
				welcomeTxt.colors.push(c);
				welcomeTxt.colorRanges.push(i + 1);
			}
			welcomeTxt.redraw();
		}
		
		override public function update(time:Number):void 
		{
			super.update(time);						
			//trace("update", welcomeTxt.colors);
		}
	}

}