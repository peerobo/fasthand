package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.Factory;
	import fasthand.comp.CatRenderer;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class CategorySelector extends BaseJsonGUI 
	{
		public var backPageBt:BaseButton;
		public var nextPageBt:BaseButton;
		
		public var rectPlace:Array; // rectangle
		
		public var bg:Sprite;
		public var contentHolder:Sprite;
		public var page2:Sprite;
		
		public function CategorySelector() 
		{
			super("CategorySelector");			
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			var len:int = rectPlace.length;
			for (var i:int = 0; i < len; i++) 
			{
				var item:CatRenderer = new CatRenderer();
				item.x = rectPlace[i].x;
				item.y = rectPlace[i].y;
				addChild(item);
			}
			
			backPageBt.setCallbackFunc(onBackPage);
			nextPageBt.setCallbackFunc(onNextPage);			
		}
		
		private function onNextPage():void 
		{
			
		}
		
		private function onBackPage():void 
		{
			
		}
		
	}

}