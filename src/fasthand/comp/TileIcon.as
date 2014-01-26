package fasthand.comp 
{
	import base.Factory;
	import comp.LoopableSprite;
	import res.Asset;
	import res.ResMgr;
	import starling.animation.IAnimatable;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class TileIcon extends LoopableSprite
	{
		private var img:Image;
		private var mx_w:Number;
		private var mx_h:Number;		
		private var animateTween:Tween;
		
		public function TileIcon() 
		{
			super();	
			img = new Image(Texture.empty(1, 1));		
			addChild(img);
			touchable = false;
			
			animateTween = new Tween(img, 1);
			animateTween.repeatCount = 0;
			animateTween.reverse = true;	
			animateTween.animate("skewX", deg2rad(3));
			animateTween.animate("skewY", deg2rad(3));
		}
		
		public function setIcon(cat:String, name:String):void
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			var tex:Texture = resMgr.getTexture(Asset.getTAName(cat), name);
			img.texture = tex;
			img.scaleX = img.scaleY = 1;
			img.readjustSize();
			refreshImage();
		}
		
		private function refreshImage():void 
		{
			img.width = img.width > mx_w ? mx_w - 6 : img.width;
			img.scaleY =  img.scaleX;
			
			img.height = img.height > mx_h ? mx_h - 6 : img.height;
			img.scaleX =  img.scaleY;
			
			img.x = mx_w - img.width >> 1;
			img.y = mx_h - img.height >> 1;
			
			//animateTween.reset(img, 1);
			//animateTween.repeatCount = 0;
			//animateTween.reverse = true;
			
		}
		
		override public function advanceTime(time:Number):void 
		{
			animateTween.advanceTime(time);
		}
		
		public function setBound(w:Number,h:Number):void
		{
			mx_w = w;
			mx_h = h;
			refreshImage();
		}
		
		public function setScale(scale:Number):void
		{			
			//img.scaleX = img.scaleY = scale;			
			//animateTween.scaleTo(scale + 0.01);
		}			
	}

}