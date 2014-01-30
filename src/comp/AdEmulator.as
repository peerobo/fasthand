package comp 
{
	import base.Factory;
	import base.LayerMgr;
	import so.cuo.platform.admob.AdmobSize;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.utils.Color;
	/**
	 * ...
	 * @author ndp
	 */
	public class AdEmulator extends LoopableSprite 
	{
		
		public function AdEmulator() 
		{
			super();
			
		}
		
		public static function showBannerAd():void
		{
			var colors:Array = [Color.AQUA, Color.BLUE, Color.GREEN, Color.NAVY];
			var color:int = colors[int(Math.random()*colors.length)];
			var quad:Quad = new Quad(320 / Starling.contentScaleFactor, 50 / Starling.contentScaleFactor, color);
			LayerMgr.getLayer(LayerMgr.LAYER_TOOLTIP).addChild(quad);
			Util.g_centerScreen(quad);
			quad.y = Util.appHeight - quad.height;
		}
		
		public static function showFullscreenAd():void
		{
			var quad:Quad = new Quad(Util.appWidth, Util.appHeight, Color.RED);			
			LayerMgr.getLayer(LayerMgr.LAYER_TOOLTIP).addChild(quad);					
			Factory.addMouseClickCallback(quad, hideAd);
		}
		
		public static function hideAd():void
		{
			LayerMgr.getLayer(LayerMgr.LAYER_TOOLTIP).removeChildren();
		 
		}
	}

}