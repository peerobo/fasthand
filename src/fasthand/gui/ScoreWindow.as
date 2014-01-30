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
	import fasthand.screen.MainScreen;
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
		public var bestScoreTxt:BaseBitmapTextField;
		public var closeBt:BaseButton;
		public var againBt:BaseButton;
		public var changeSubjectBt:BaseButton;
		public var scoreRect:Rectangle;
		
		private var scoreSpr:SpriteNumber;
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
			
			scoreSpr = Factory.getObjectFromPool(SpriteNumber);
			scoreSpr.init(Asset.getBaseTextures(IconAsset.ICO_NUMBER));
			addChild(scoreSpr);
			
			againBt.setCallbackFunc(onAgainBt);
			closeBt.setCallbackFunc(onCategoryBt);
			changeSubjectBt.setCallbackFunc(onCategoryBt);		
			
			addChild(particleSys);
			particleSys.x = width >> 1;			
			particleSys.y = 60;
			SoundManager.playSound(SoundAsset.SOUND_END_GAME);
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
		
		public function setScore(score:int, scoreBest:int):void
		{
			scoreSpr.text = Util.numberWithCommas(score);
			bestScoreTxt.setContent(LangUtil.getText("yourbestscore") + " ", Util.numberWithCommas(scoreBest));
			bestScoreTxt.setContentColor(Color.WHITE, Color.YELLOW);
			
			Util.g_fit(scoreSpr, scoreRect);
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