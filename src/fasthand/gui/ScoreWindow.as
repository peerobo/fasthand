package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.GlobalInput;
	import base.LangUtil;
	import base.LayerMgr;
	import base.PopupMgr;
	import base.ScreenMgr;
	import base.SoundManager;
	import com.adobe.ane.social.SocialServiceType;	
	import comp.HighscoreDB;
	import comp.SpriteNumber;
	import fasthand.Fasthand;
	import fasthand.FasthandUtil;	
	import fasthand.screen.CategoryScreen;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import res.Asset;
	import res.asset.IconAsset;
	import res.asset.ParticleAsset;
	import res.asset.SoundAsset;
	import starling.core.Starling;
	import starling.display.DisplayObject;
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
		public var twitterBt:DisplayObject;
		public var facebookBt:DisplayObject;
		private var particleSys:PDParticleSystem;
		private var _cat:String;
		private var prevF:Function;
		
		public var closeCallback:Function;
		public var isChangeSubject:Boolean;
		public var celebrate:Boolean;
		
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
			
			Factory.addMouseClickCallback(twitterBt, onTwitter);
			Factory.addMouseClickCallback(facebookBt, onFacebook);
			
			addChildAt(particleSys,1);
			particleSys.y = 0;
			particleSys.x = width >> 1;
			
			SoundManager.playSound(SoundAsset.SOUND_END_GAME);	
			
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			prevF = globalInput.getCurrentKeyHandler(Keyboard.BACK);
			globalInput.registerKey(Keyboard.BACK, onBackBt);
			
			LayerMgr.lockGameLayer = true;
		}
		
		private function onBackBt():void 
		{
			ScreenMgr.showScreen(CategoryScreen);
		}
		
		private function shareOnIOS(type:String):void
		{				
			var text:String = LangUtil.getText("shareMsg");
			text = Util.replaceStr(text, ["@cat", "@url"], ["\"" + LangUtil.getText(_cat) + "\"", Constants.SHORT_LINK]);								
			
			Util.shareOnIOS(type, text, Util.g_takeSnapshot());
		}
		
		private function onFacebook():void 
		{
			if(Util.isIOS)
			{
				shareOnIOS(SocialServiceType.FACEBOOK);
			}
		}
		
		private function onTwitter():void 
		{
			if(Util.isIOS)
			{
				shareOnIOS(SocialServiceType.TWITTER);
			}
		}
		
		private function onScoreBt():void 
		{
			var highscoreDB:HighscoreDB = Factory.getInstance(HighscoreDB);
			var logic:Fasthand = Factory.getInstance(Fasthand);
			var cat:String = logic.cat;			
			if(Util.isIOS)
			{			
				highscoreDB.showGameCenterHighScore(cat);
			}
		}
		
		private function openSelfAgain():void 
		{			
			PopupMgr.addPopUp(this);
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
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);			
			globalInput.registerKey(Keyboard.BACK, prevF);
		}
		
		public function setTitle(subject:String):void
		{
			_cat = subject;
			subjectTitleTxt.text = LangUtil.getText(subject);
		}
		
		override public function onRemoved(e:Event):void 
		{
			particleSys.stop();
			particleSys.removeFromParent();
			LayerMgr.lockGameLayer = false;
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
			
			if (celebrate)
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