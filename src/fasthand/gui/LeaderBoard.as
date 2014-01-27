package fasthand.gui 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.font.BaseBitmapTextField;
	import base.LayerMgr;
	import base.PopupMgr;
	import comp.LoopableSprite;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.ButtonAsset;
	import res.asset.IconAsset;
	import res.asset.ParticleAsset;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	/**
	 * ...
	 * @author ndp
	 */
	public class LeaderBoard extends LoopableSprite
	{
		private var particleSys:PDParticleSystem;
		private var txtField:BaseBitmapTextField;
		public var callback:Function;
		
		public function LeaderBoard() 
		{
			var img:DisplayObject = Asset.getBaseImage(BackgroundAsset.BG_WINDOW);
			img.width = 420;
			img.height = 420
			txtField = BFConstructor.getTextField(img.width, img.height - 60, "", BFConstructor.BANHMI);
			txtField.y = 18;
			var okBt:BaseButton = ButtonAsset.getBaseBt(ButtonAsset.BT_ORANGE);			
			okBt.icons[0].width = 180;
			okBt.icons[0].height = 87;
			okBt.y = img.height - okBt.icons[0].height - 12;
			okBt.x = img.width - okBt.icons[0].width >>1;
			okBt.setLabel(BFConstructor.getShortTextField(okBt.icons[0].width, okBt.icons[0].height, "Dong", BFConstructor.BANHMI));
			okBt.setCallbackFunc(onCloseLeaderBoard);
			addChild(img);
			addChild(txtField);
			addChild(okBt);
			
			particleSys = ParticleAsset.getUniqueParticleSys(ParticleAsset.PARTICLE_STAR_COMPLETE, Asset.getBaseTexture(IconAsset.ICO_STAR));
			particleSys.x = img.width >> 1;
			addChild(particleSys);
		}
		
		public function setText(text:String):void
		{
			txtField.text = text;
		}
		
		
		private function onCloseLeaderBoard():void 
		{
			PopupMgr.removePopup();
			callback();
			particleSys.stop();
			LayerMgr.getLayer(LayerMgr.LAYER_GAME).unflatten();
		}
				
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			LayerMgr.getLayer(LayerMgr.LAYER_GAME).flatten();
			particleSys.start(5);			
		}
		
		override public function advanceTime(time:Number):void 
		{
			super.advanceTime(time);
			
			particleSys.advanceTime(time);
		}
		
	}

}