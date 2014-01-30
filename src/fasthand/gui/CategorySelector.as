package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.CallbackObj;
	import base.Factory;
	import base.GlobalInput;
	import base.LangUtil;
	import fasthand.comp.CatRenderer;
	import fasthand.Fasthand;
	import fasthand.FasthandUtil;
	import flash.geom.Rectangle;
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
		public var rectIcon:Rectangle;
		
		public var bg:Sprite;
		public var contentHolder:Sprite;
		public var page2:Sprite;
		
		public var currentPage:int;
		
		/**
		 * a callback function: c(cat:String):void
		 */
		public var onSelectCategoryCallback:Function;
		
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
			sprNext.alpha = 0;
			addChild(sprNext);
			addChild(sprCurr);		
			
			
			var len:int = rectPlace.length;			
			var c:CallbackObj;
			for (var i:int = 0; i < len; i++) 
			{
				var item:CatRenderer = new CatRenderer();
				item.x = rectPlace[i].x;
				item.y = rectPlace[i].y;
				sprCurr.addChild(item);
				item.align(rectPlace[i],rectIcon);
				item.name = "item" + i;	
				c = Factory.getObjectFromPool(CallbackObj);
				c.f = onSelectCat;
				item.clickCallbackObj = c
				item = new CatRenderer();
				item.x = rectPlace[i].x;
				item.y = rectPlace[i].y;
				item.name = "item" + i;				
				sprNext.addChild(item);
				item.align(rectPlace[i],rectIcon);
				c = Factory.getObjectFromPool(CallbackObj);
				c.f = onSelectCat;
				item.clickCallbackObj = c;
			}			
			backPageBt.setCallbackFunc(onBackPage);
			nextPageBt.setCallbackFunc(onNextPage);			
			updatePage(sprCurr, currentPage);
			updateBtStates();
		}
		
		private function onSelectCat(catRender:CatRenderer):void
		{
			if (catRender.isLock)
			{
				Util.showInAppPurchase();
			}
			else
			{
				if(onSelectCategoryCallback is Function)
					onSelectCategoryCallback(catRender.cat);				
			}
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
				{
					item.setIcon(IconAsset.PREFIX + listCat[idx + i],listCat[idx + i]);
				}
				else
				{
					item.setComingSoon();
				}
				item.isLock = idx + i >= Constants.CAT_FREE_NUM;
			}
		}
		
		override public function onRemoved(e:Event):void 
		{
			sprCurr.removeChildren();
			sprNext.removeChildren();
			super.onRemoved(e);						
		}
		
		public function onNextPage():void 
		{		
			var maxPage:int = Math.round(FasthandUtil.getListCat().length / Constants.CAT_PER_PAGE);
			if (currentPage == maxPage-1)			
				return;
			sprNext.x = Util.appWidth;
			sprNext.y = 0;
			addChild(sprNext);
			currentPage++;
			updateBtStates();
			updatePage(sprNext, currentPage);
						
			Starling.juggler.tween(sprNext, 0.5, { x:0, alpha: 1 } );
			Starling.juggler.tween(sprCurr, 0.5, { x: -Util.appWidth, alpha:0, onComplete: onScrollComplete } );
			
			var input:GlobalInput = Factory.getInstance(GlobalInput );
			input.disable = true;
		}
		
		private function updateBtStates():void
		{				 
			var maxPage:int = Math.round(FasthandUtil.getListCat().length / Constants.CAT_PER_PAGE);
			currentPage = currentPage < 0 ? 0:currentPage;
			currentPage = currentPage >=maxPage ? maxPage-1:currentPage;
			
			backPageBt.visible = currentPage > 0;
			nextPageBt.visible = currentPage < maxPage -1;			
		}
		
		private function onScrollComplete():void 
		{
			var spr:Sprite = sprCurr;
			sprCurr = sprNext;
			sprNext = spr;	
						
			sprNext.x = 0;
			
			var input:GlobalInput = Factory.getInstance(GlobalInput );
			input.disable = false;
		}
		
		public function onBackPage():void 
		{
			if (currentPage == 0)
				return;
			sprNext.x = -Util.appWidth;
			sprNext.y = 0;
			addChild(sprNext);
			currentPage--;
			updateBtStates();
			updatePage(sprNext, currentPage);
			
			Starling.juggler.tween(sprNext, 0.5, { x:0, alpha: 1 } );
			Starling.juggler.tween(sprCurr, 0.5, { x:Util.appWidth, alpha:0, onComplete: onScrollComplete } );
			var input:GlobalInput = Factory.getInstance(GlobalInput );
			input.disable = true;
		}
		
	}

}