package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.CallbackObj;
	import base.Factory;
	import base.GlobalInput;
	import base.LangUtil;
	import base.SoundManager;
	import comp.PageFooter;
	import fasthand.comp.CatRenderer;
	import fasthand.Fasthand;
	import fasthand.FasthandUtil;
	import flash.geom.Rectangle;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.IconAsset;
	import res.asset.SoundAsset;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class CategorySelector extends BaseJsonGUI 
	{
		private var sprCurr:Sprite;
		private var sprNext:Sprite;		
		
		public var rectPlace:Array; // rectangle
		public var rectIcon:Rectangle;
		
		public var bg:Sprite;
		public var contentHolder:Sprite;
		public var page2:Sprite;
		
		public var currentPage:int;
		
		private var backCatIndicator:Sprite;
		private var nextCatIndicator:Sprite;
		private var pageFooter:PageFooter;
		
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
			initNextBackIndicator();
			pageFooter = new PageFooter();
			pageFooter.initTexture(Asset.getBaseImage(BackgroundAsset.BG_SQUARE) as Image, Asset.getBaseImage(BackgroundAsset.BG_SQUARE_ALPHA) as Image);
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
				item.clickCallbackObj = c;
				item.adjustColorIdx(i);
				item = new CatRenderer();
				item.x = rectPlace[i].x;
				item.y = rectPlace[i].y;
				item.name = "item" + i;				
				sprNext.addChild(item);
				item.align(rectPlace[i],rectIcon);
				c = Factory.getObjectFromPool(CallbackObj);
				c.f = onSelectCat;
				item.clickCallbackObj = c;
				item.adjustColorIdx(i);
			}			
			//backPageBt.setCallbackFunc(onBackPage);
			//nextPageBt.setCallbackFunc(onNextPage);	
			parent.addChild(backCatIndicator);
			parent.addChild(nextCatIndicator);
			updatePageFooter();
			updatePage(sprCurr, currentPage);
			updateBtStates();						
		}
		
		private function initNextBackIndicator():void 
		{
			backCatIndicator = new Sprite();
			var image:DisplayObject = Asset.getBaseImage(BackgroundAsset.BG_ITEM);
			image.height = 330;
			image.width = 156;
			var filter:ColorMatrixFilter = new ColorMatrixFilter();
			CatRenderer.editColorFilterByIdx(2,filter);			
			image.filter = filter;
			filter.cache();
			backCatIndicator.addChild(image);
			image = Asset.getBaseImage(BackgroundAsset.BG_ITEM);
			image.height = 330;
			image.width = 156;	
			image.y = 426;
			filter = new ColorMatrixFilter();
			CatRenderer.editColorFilterByIdx(5,filter);			
			image.filter = filter;
			filter.cache();
			backCatIndicator.addChild(image);
			backCatIndicator.y = Util.appHeight - backCatIndicator.height >> 1;
			backCatIndicator.x = -image.width / 3;
			
			nextCatIndicator = new Sprite();
			image = Asset.getBaseImage(BackgroundAsset.BG_ITEM);
			image.height = 330;
			image.width = 156;			
			filter = new ColorMatrixFilter();
			CatRenderer.editColorFilterByIdx(0,filter);			
			image.filter = filter;
			filter.cache();
			nextCatIndicator.addChild(image);
			image = Asset.getBaseImage(BackgroundAsset.BG_ITEM);
			image.height = 330;
			image.width = 156;
			image.y = 426;	
			filter = new ColorMatrixFilter();
			CatRenderer.editColorFilterByIdx(3,filter);			
			image.filter = filter;
			filter.cache();
			nextCatIndicator.addChild(image);
			nextCatIndicator.y = Util.appHeight - nextCatIndicator.height >> 1;
			nextCatIndicator.x = Util.appWidth - image.width*2/3;
		}
		
		private function onSelectCat(catRender:CatRenderer):void
		{
			SoundManager.playSound(SoundAsset.SOUND_CLICK);
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
				item.isLock = !Util.isFullApp ? (idx + i >= Constants.CAT_FREE_NUM) : false;
				//item.isLock = false;
			}			
		}
		
		private function updatePageFooter():void
		{
			pageFooter.removeFromParent();
			var maxPage:int = Math.round(FasthandUtil.getListCat().length / Constants.CAT_PER_PAGE);
			pageFooter.setState(currentPage, maxPage);
			pageFooter.y = this.height + 72;
			addChild(pageFooter);
			pageFooter.x = this.width - pageFooter.width >> 1;
			
		}
		
		
		override public function onRemoved(e:Event):void 
		{
			pageFooter.removeFromParent();
			nextCatIndicator.removeFromParent();
			backCatIndicator.removeFromParent();
			sprCurr.removeChildren();
			sprNext.removeChildren();
			
			super.onRemoved(e);						
		}
		
		public function onNextPage():void 
		{					
			var maxPage:int = Math.round(FasthandUtil.getListCat().length / Constants.CAT_PER_PAGE);
			if (currentPage == maxPage-1)			
				return;
			currentPage++;
			updatePageFooter();
			nextCatIndicator.visible = false;
			backCatIndicator.visible = false;
			sprNext.x = Util.appWidth;
			sprNext.y = 0;
			addChild(sprNext);			
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
			
			backCatIndicator.visible = currentPage > 0;
			nextCatIndicator.visible = currentPage < maxPage -1;			
		}
		
		private function onScrollComplete():void 
		{
			updateBtStates();
			
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
			currentPage--;
			updatePageFooter();
			nextCatIndicator.visible = false;
			backCatIndicator.visible = false;
			sprNext.x = -Util.appWidth;
			sprNext.y = 0;
			addChild(sprNext);			
			updatePage(sprNext, currentPage);
			
			Starling.juggler.tween(sprNext, 0.5, { x:0, alpha: 1 } );
			Starling.juggler.tween(sprCurr, 0.5, { x:Util.appWidth, alpha:0, onComplete: onScrollComplete } );
			var input:GlobalInput = Factory.getInstance(GlobalInput );
			input.disable = true;
		}
		
		public function refresh():void 
		{
			updatePage(sprCurr, currentPage);
		}
		
	}

}