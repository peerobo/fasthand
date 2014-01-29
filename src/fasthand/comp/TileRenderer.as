package fasthand.comp 
{
	import base.BaseButton;
	import base.Factory;
	import comp.LoopableSprite;
	import flash.geom.Rectangle;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.ButtonAsset;
	import res.ResMgr;
	import starling.display.Image;
	import starling.events.Event;
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
			
			img = Factory.getObjectFromPool(Image);
			img.texture = Texture.empty(1, 1);
			img.readjustSize();
			img.touchable = false;
			addChild(img);
		}
		
		private function onTouch():void 
		{
			touchCallback(this);
		}
		
		public function setWord(cat:String, word:String):void
		{
			this.word = word;
			this.cat = cat;
			
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			var tex:Texture = resMgr.getTexture(Asset.getTAName(cat), word);
			img.texture = tex;
			img.scaleX = img.scaleY = 1;
			img.readjustSize();
			refreshImage();
		}
		
		private function refreshImage():void 
		{
			var rec:Rectangle = new Rectangle(6, 6, baseButton.width - 12, baseButton.height - 12);
			Util.g_fit(img, rec);
		}
		
		override public function set width(value:Number):void 
		{
			baseButton.background.width = value;
		} 
				
		override public function set height(value:Number):void 
		{
			baseButton.background.height = value;
		}
		
		public function reset():void
		{
			img.texture = Texture.empty(1, 1);
			img.readjustSize();
		}
		
	}

}