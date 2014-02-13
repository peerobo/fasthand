package fasthand.comp 
{
	import base.BaseButton;
	import base.Factory;
	import base.LayerMgr;
	import comp.LoopableSprite;	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.ButtonAsset;
	import res.ResMgr;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class TileRenderer extends LoopableSprite 
	{
		private var baseButton:BaseButton;
		public var cat:String;
		public var word:String;
		private var img:Image;
		
		public var touchCallback:Function;	// function(tile:TileRender)
		
		public function TileRenderer() 
		{
			super();			
		}	
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			baseButton = ButtonAsset.getBaseBt(BackgroundAsset.BG_ITEM);
			addChild(baseButton);
			baseButton.setCallbackFunc(onTouch);
			var cMF:ColorMatrixFilter = new ColorMatrixFilter();
			cMF.adjustHue(115/180);
			baseButton.colorFilter = cMF;
			
			img = Factory.getObjectFromPool(Image);
			img.texture = Texture.empty(1, 1);
			img.readjustSize();
			img.touchable = false;
			LayerMgr.getLayer(LayerMgr.LAYER_EFFECT).addChild(img);
			//addChild(img);
		}
		
		private function onTouch():void 
		{
			touchCallback(this);
		}
		
		public function setWord(cat:String, word:String):DisplayObject
		{
			this.word = word;
			this.cat = cat;
			
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			var tex:Texture = resMgr.getTexture(Asset.getTAName(cat), word);
			img.texture = tex;			
			img.readjustSize();
			img.scaleX = img.scaleY = 1;
			refreshImage();
			return img;
		}
		
		override public function onRemoved(e:Event):void 
		{
			img.removeFromParent();
			super.onRemoved(e);
		}
		
		
		private function refreshImage():void 
		{
			var pt:Point = this.localToGlobal(new Point(0, 0));
			var rec:Rectangle = new Rectangle(6 + pt.x, 6 + pt.y, baseButton.width - 12, baseButton.height - 12);
			Util.g_fit(img, rec);
		}
		
		override public function set width(value:Number):void 
		{
			baseButton.background.width = value;
			flatten();
		} 
				
		override public function set height(value:Number):void 
		{
			baseButton.background.height = value;			
		}
		
		public function reset():void
		{
			img.texture = Texture.empty(1, 1);
			img.readjustSize();
			alpha = 1;			
		}
		
	}

}