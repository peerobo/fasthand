package screen 
{	
	import base.Factory;
	import base.Graphics4Starling;
	import comp.LoadingIcon;
	import flash.display.Graphics;
	import res.ResMgr;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class LoadingScreen extends Sprite 
	{		
		private var loadingIcon:LoadingIcon;
		
		public function LoadingScreen() 
		{
			super();
			loadingIcon = new LoadingIcon();
			loadingIcon.x = Util.appWidth - loadingIcon.width >>1;
			loadingIcon.y = Util.appHeight - loadingIcon.height >> 1;
			addChild(loadingIcon);
			
			addEventListener(Event.ENTER_FRAME, onFrame);					
		}				
		
		private function onFrame(e:Event):void 
		{			
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			loadingIcon.progressString = resMgr.assetProgress * 100 + "%";
			if (resMgr.assetProgress == 1)
			{
				var gameScreen:GameScreen = Factory.getInstance(GameScreen);
				var p:DisplayObjectContainer = this.parent;
				p.addChild(gameScreen);				
				this.removeFromParent();
			}
		}
	}

}