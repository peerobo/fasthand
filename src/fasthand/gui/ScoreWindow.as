package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.LangUtil;
	import base.PopupMgr;
	import base.SoundManager;
	import comp.SpriteNumber;
	import fasthand.FasthandUtil;	
	import flash.geom.Rectangle;
	import res.Asset;
	import res.asset.IconAsset;
	import res.asset.ParticleAsset;
	import res.asset.SoundAsset;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.utils.Color;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class ScoreWindow extends BaseJsonGUI 
	{
		public var subjectTitleTxt:BaseBitmapTextField;
		public var contentTxt:BaseBitmapTextField;
		public var scoreBt:BaseButton;
		public var againBt:BaseButton;
		public var changeSubjectBt:BaseButton;
		public var scoreRect:Rectangle;
				
		private var particleSys:PDParticleSystem;
		
		public var closeCallback:Function;
		public var isChangeSubject:Boolean;
		
		public function ScoreWindow() 
		{
			super("ScoreWindow");
			
			particleSys = ParticleAsset.getUniqueParticleSys(ParticleAsset.PARTICLE_STAR_COMPLETE, Asset.getBaseTexture(IconAsset.ICO_STAR));						
		}
		
		override public function onAdded(e:Event):void 
		{
			
			
			super.onAdded(e);
			
			subjectTitleTxt.batchable = true;					
			
			againBt.setCallbackFunc(onAgainBt);			
			changeSubjectBt.setCallbackFunc(onCategoryBt);		
			scoreBt.setCallbackFunc(onScoreBt);
			
			addChild(particleSys);			
			particleSys.y = 0;
			particleSys.x = width >> 1;
			
			SoundManager.playSound(SoundAsset.SOUND_END_GAME);
		}
		
		private function onScoreBt():void 
		{
			
		}
		
		private function onCategoryBt():void 
		{
			PopupMgr.removePopup(this);
			isChangeSubject = true;
			closeCallback();
			closeCallback = null;			
		}
		
		private function onAgainBt():void 
		{
			PopupMgr.removePopup(this);			
			isChangeSubject = false;
			closeCallback();
			closeCallback  = null;
		}
		
		public function setTitle(subject:String):void
		{
			subjectTitleTxt.text = subject;
		}
		
		override public function onRemoved(e:Event):void 
		{
			particleSys.stop();
			particleSys.removeFromParent();
			super.onRemoved(e);
		}
		
		public function setScore(score:int, scoreBest:int, subjectPlayed:int):void		
		{
			var str:String = LangUtil.getText("result");
			contentTxt.text = str;
			var strs2Replace:Array = ["@score", "@best", "@subject"];
			var strs2ReplaceWith:Array = [score.toString(), scoreBest.toString(), subjectPlayed.toString() + "/" + FasthandUtil.getListCat().length];
			var colors:Array = [0x00FF40, Color.YELLOW, 0xFF8080];
			Util.g_replaceAndColorUp(contentTxt, strs2Replace, strs2ReplaceWith, colors );
			
			if (score > scoreBest)
			{
				SoundManager.playSound(SoundAsset.SOUND_HIGH_SCORE);
				particleSys.start(5);
			}
		}
		
		override public function update(time:Number):void 
		{
			super.update(time);
			
			particleSys.advanceTime(time);
		}
		
	}

}