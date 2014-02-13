package comp 
{
	import base.BFConstructor;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.Graphics4Starling;
	import base.LangUtil;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.IconAsset;
	import res.ResMgr;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import flash.display.Graphics;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class LoadingIcon extends LoopableSprite
	{	
		//private var mc:MovieClip;
		
		private var stars:Array;
		private var pageFooter:PageFooter;
		private var currentProgress:int;
		static private const NUM_LOADING:Number = 4;
		
		public function LoadingIcon() 
		{
			super();
			interval = 0.4;		
			pageFooter = new PageFooter();
			var img:Image = Asset.getBaseImage(BackgroundAsset.BG_SQUARE) as Image;
			var c:ColorMatrixFilter = new ColorMatrixFilter();
			c.adjustBrightness(0.3);
			c.adjustHue(0.5);	
			pageFooter.initTexture(img, Asset.getBaseImage(BackgroundAsset.BG_SQUARE_ALPHA) as Image,72);
			pageFooter.filter = c;
			currentProgress = 0;
		}
		
		override public function onRemoved(e:Event):void 
		{
			pageFooter.removeFromParent();
			super.onRemoved(e);
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			pageFooter.setState(currentProgress, NUM_LOADING);
			addChild(pageFooter);
			/*stars = [];
			var loading:BaseBitmapTextField  = BFConstructor.getTextField(1, 1, LangUtil.getText("loading"), BFConstructor.BANHMI);
			loading.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;			
			addChild(loading);
			var posY:int = loading.height + 6;
			for (var i:int = 0; i < 3; i++) 
			{
				var star:DisplayObject = Asset.getBaseImage(IconAsset.ICO_STAR);
				star.x = 80 * i + (star.width >> 1);
				star.y = posY + (star.height >> 1);
				star.pivotX = star.width >> 1;
				star.pivotY = star.height >> 1;
				star.alpha = 0.8;
				addChild(star);
				stars.push(star);
			}			
			loading.x = this.width - loading.width >> 1;*/
		}				
		
		override public function update(time:Number):void 
		{
			super.update(time);
			
			pageFooter.setState(currentProgress, NUM_LOADING);
			currentProgress++;
			currentProgress = currentProgress >= NUM_LOADING?0:currentProgress;
		}
	}

}