package base 
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ndp
	 */
	public class PopupMgr 
	{
		private static var root:Sprite;
		static private var quadBg:Quad;
		
		static private var queue:Array;
		static public var current:DisplayObject;
		
		static private var tween:Tween;
		
		public function PopupMgr() 
		{						
		}
		
		public static function init(layer:Sprite):void
		{
			root = layer;
			quadBg = new Quad(Util.appWidth, Util.appHeight, 0x0);
			quadBg.alpha = 0.8;
			quadBg.visible = false;
			root.addChild(quadBg);
			queue = [];
			tween = new Tween(null, 0.75);
			Util.registerRelayoutAfterAd(onAdShow, true);
		}
		
		static private function onAdShow(isAdShow:Boolean):void 
		{
			if (current)
			{
				Util.g_centerScreen(current);
				if (isAdShow)
				{
					current.y -= Util.adBannerHeight;
				}
			}
		}
		
		public static function addPopUp(disp:DisplayObject, withAnim:Boolean = false):void
		{						
			quadBg.visible = true;
			if(!current)
			{
				root.addChild(disp);
				current = disp;
				Util.g_centerScreen(disp);				
				if (Util.isBannerAdShowed)
					disp.y -= Util.adBannerHeight;
				if (withAnim)
				{
					Starling.juggler.tween(disp, 0.75, { x:disp.x, y:disp.y, scaleX:1, scaleY:1, transition:Transitions.EASE_IN_OUT_BOUNCE } );					
					disp.scaleX = disp.scaleY = 0.1;
					Util.g_centerScreen(disp);					
				}
			}
			else if (current != disp)			
			{
				queue.push(disp);
			}
			
		}

		public static function removePopup(disp:DisplayObject= null):void
		{			
			if(!disp || (current == disp && disp))
			{
				current.removeFromParent();
				current = null;
				if (queue.length > 0)
				{
					disp = queue[0];
					queue.splice(0, 1);
					root.addChild(disp);
					current = disp;
					Util.g_centerScreen(disp);
					if (Util.isBannerAdShowed)
						disp.y -= Util.adBannerHeight;
				}
				else
				{
					quadBg.visible = false;
				}
			}			
			else if (queue.indexOf(disp) > -1)
			{
				queue.splice(queue.indexOf(disp), 1);
			}
		}
		
		public static function flush():void
		{
			queue = [];
			if (current)
				current.removeFromParent();
			current = null;
			quadBg.visible = false;
		}
		
	}

}