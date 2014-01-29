package comp 
{
	import base.BFConstructor;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.Graphics4Starling;
	import base.LangUtil;
	import res.Asset;
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
		
		public function LoadingIcon() 
		{
			super();
			interval = 0.033;			
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			/*mc = Factory.getObjectFromPool(MovieClip);
			for (var i:int = 0; i < mc.numFrames - 1; i++) 
			{
				mc.removeFrameAt(0);
			}
			var mvTexs:Vector.<Texture > = Asset.getBaseTextures(IconAsset.ICO_CLOCK);
			for (var j:int = 0; j < mvTexs.length; j++) 
			{
				mc.addFrame(mvTexs[j]);
				if (j == 0)
				{
					mc.texture = mvTexs[j];
					mc.readjustSize();
					mc.removeFrameAt(0);
				}
			}			
			mc.loop = true;			
			addChild(mc);
			mc.play();*/
			stars = [];
			var loading:BaseBitmapTextField  = BFConstructor.getShortTextField(1, 1, LangUtil.getText("loading"), BFConstructor.BANHMI);
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
			loading.x = this.width - loading.width >> 1;
		}
		
		override public function update(time:Number):void 
		{
			super.update(time);
			
			for (var i:int = 0; i < stars.length; i++) 
			{
				stars[i].rotation += deg2rad(10);
			}
		}
	}

}