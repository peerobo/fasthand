package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.Factory;
	import base.LangUtil;
	import fasthand.comp.CatRenderer;
	import fasthand.FasthandUtil;
	import res.asset.IconAsset;
	import starling.core.Starling;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class CategorySelector extends BaseJsonGUI 
	{
		private var sprCurr:Sprite;
		private var sprNext:Sprite;
		public var backPageBt:BaseButton;
		public var nextPageBt:BaseButton;
		
		public var rectPlace:Array; // rectangle
		
		public var bg:Sprite;
		public var contentHolder:Sprite;
		public var page2:Sprite;
		
		public var currentPage:int;
		
		public function CategorySelector() 
		{
			super("CategorySelector");	
			sprCurr = new Sprite();
			sprNext = new Sprite();
			currentPage = 0;			
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			addChild(sprNext);
			addChild(sprCurr);					
			
			var len:int = rectPlace.length;			
			for (var i:int = 0; i < len; i++) 
			{
				var item:CatRenderer = new CatRenderer();
				item.x = rectPlace[i].x;
				item.y = rectPlace[i].y;
				sprCurr.addChild(item);
				item.name = "item" + i;
				
				item = new CatRenderer();
				item.x = rectPlace[i].x;
				item.y = rectPlace[i].y;
				item.name = "item" + i;
				sprNext.addChild(item);
			}			
			backPageBt.setCallbackFunc(onBackPage);
			nextPageBt.setCallbackFunc(onNextPage);			
			updatePage(sprCurr, currentPage);
		}
		
		public function updatePage(pageHolder:Sprite, page:int):void
		{
			var idx:int = page * Constants.CAT_PER_PAGE;
			var len:int = rectPlace.length;
			var listCat:Array = FasthandUtil.getListCat();
			for (var i:int = 0; i < len; i++) 
			{				
				var item:CatRenderer = pageHolder.getChildByName("item" + i) as CatRenderer;
				if (listCat.length > idx + i)				
					item.setIcon(IconAsset.PREFIX + listCat[idx + i],LangUtil.getText(listCat[idx + i]));
				else
					item.setComingSoon();
				item.isLock = idx + i >= Constants.CAT_FREE_NUM;
			}
		}
		
		override public function onRemoved(e:Event):void 
		{
			super.onRemoved(e);
			
			sprCurr.removeChildren();
			sprNext.removeChildren();
		}
		
		private function onNextPage():void 
		{			
			sprNext.x = Util.appWidth;
			sprNext.y = 0;						
			currentPage++;
			updateBtStates();
			updatePage(sprNext, currentPage);
			Starling.juggler.tween(sprNext, 0.5, { x:0, alpha: 1 } );
			Starling.juggler.tween(sprCurr, 0.5, { x:-Util.appWidth, alpha:0, onComplete: onScrollComplete } );
		}
		
		private function updateBtStates():void
		{				 
			var maxPage:int = Math.round(FasthandUtil.getListCat().length / Constants.CAT_PER_PAGE);
			currentPage = currentPage < 0 ? 0:currentPage;
			currentPage = currentPage >=maxPage ? maxPage-1:currentPage;
			
			backPageBt.isDisable = currentPage <= 0;
			nextPageBt.isDisable = currentPage >= maxPage -1;
			
			sprCurr.touchable = false;
			sprNext.touchable = false;
		}
		
		private function onScrollComplete():void 
		{
			var spr:Sprite = sprCurr;
			sprCurr = sprNext;
			sprNext = spr;	
			
			sprCurr.touchable = true;
		}
		
		private function onBackPage():void 
		{
			sprNext.x = -Util.appWidth;
			sprNext.y = 0;
			currentPage--;
			updateBtStates();
			updatePage(sprNext, currentPage);
			Starling.juggler.tween(sprNext, 0.5, { x:0, alpha: 1 } );
			Starling.juggler.tween(sprCurr, 0.5, { x:Util.appWidth, alpha:0, onComplete: onScrollComplete } );
		}
		
	}

}