package fasthand.comp 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.Factory;
	import base.LangUtil;
	import base.LayerMgr;
	import base.PopupMgr;
	import comp.LoopableSprite;
	import fasthand.Fasthand;
	import res.asset.ButtonAsset;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class PauseDialog extends LoopableSprite 
	{
		public var callbackUnPaused:Function
		
		public function PauseDialog() 
		{
			super();
			
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			var quad:Quad = Factory.getObjectFromPool(Quad);
			quad.width = Util.appWidth;
			quad.height = Util.appHeight;
			quad.color = 0x0;
			addChild(quad);
			
			var txtField:TextField = BFConstructor.getTextField(Util.appWidth, Util.appHeight- 360, LangUtil.getText("paused"), BFConstructor.BANHMI);			
			addChild(txtField);
			
			var bt:BaseButton = ButtonAsset.getBaseBt(ButtonAsset.BT_PLAY_AGAIN);
			addChild(bt);
			bt.setCallbackFunc(onResume);
			Util.g_centerScreen(bt);
			bt.y += 240;					
		}
		
		private function onResume():void 
		{
			callbackUnPaused();
			
			PopupMgr.removePopup(this);			
			LayerMgr.getLayer(LayerMgr.LAYER_GAME).unflatten();
		}
		
	}

}