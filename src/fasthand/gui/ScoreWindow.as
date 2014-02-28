package fasthand.gui 
{
	import base.BaseButton;
	import base.BaseJsonGUI;
	import base.EffectMgr;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.GlobalInput;
	import base.LangUtil;
	import base.LayerMgr;
	import base.PopupMgr;
	import base.ScreenMgr;
	import base.SoundManager;
	import comp.GameService;
	import comp.LoadingIcon;
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
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.utils.Color;
	
	CONFIG::isIOS{
		import com.adobe.ane.social.SocialServiceType;	
	}	
	
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
		private var score:int;
		private var scoreBest:int;
		private var subjectPlayed:int;
		private var delayCalled:DelayedCall;
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
			
			var str:String = LangUtil.getText("result");
			contentTxt.text = str;
			var strs2Replace:Array = ["@score", "@best", "@subject"];
			var strs2ReplaceWith:Array = [score.toString(), scoreBest.toString(), subjectPlayed.toString() + "/" + FasthandUtil.getListCat().length];
			var colors:Array = [0x00FF40, Color.YELLOW, 0xFF8080];
			Util.g_replaceAndColorUp(contentTxt, strs2Replace, strs2ReplaceWith, colors );
			subjectTitleTxt.text = LangUtil.getText(_cat);
			
			if (celebrate)
			{
				SoundManager.playSound(SoundAsset.SOUND_HIGH_SCORE);
				particleSys.start(5);
			}
		}
		
		private function onBackBt():void 
		{
			ScreenMgr.showScreen(CategoryScreen);
		}
		
		private function shareOnIOS(type:String):void
		{				
			var text:String = LangUtil.getText("shareMsg");
			text = Util.replaceStr(text, ["@cat", "@url"], ["\"" + LangUtil.getText(_cat) + "\"", Constants.SHORT_LINK]);								
			
			CONFIG::isIOS{
				Util.shareOnIOS(type, text, Util.g_takeSnapshot());
			}
		}
		
		private function onFacebook():void 
		{
			CONFIG::isIOS{
				if(Util.isIOS)
				{
					shareOnIOS(SocialServiceType.FACEBOOK);
				}
			}
			CONFIG::isAndroid {
				if (Util.isAndroid)
				{
					var text:String = LangUtil.getText("shareMsg");
					text = Util.replaceStr(text, ["@cat", "@url"], ["\"" + LangUtil.getText(_cat) + "\"", Constants.SHORT_LINK]);
					Util.shareOnFBAndroid(text, Util.g_takeSnapshot(), onShareOnAnroidComplete);
					PopupMgr.removePopup(this);
					PopupMgr.addPopUp(Factory.getInstance(LoadingIcon));
					delayCalled = Starling.juggler.delayCall(onShareOnAnroidComplete, 15, false);
				}
			}
		}
		
		private function onShareOnAnroidComplete(success:Boolean):void 
		{
			Starling.juggler.remove(delayCalled);
			if(PopupMgr.current != this)
				EffectMgr.floatTextMessageEffectCenter(success ? LangUtil.getText("shareDone"):LangUtil.getText("shareFailed"),success?0xFFFFFF:0xC0C0C0);
			celebrate = false;
			PopupMgr.removePopup(Factory.getInstance(LoadingIcon));
			PopupMgr.addPopUp(this);			
		}
		
		private function onTwitter():void 
		{
			CONFIG::isIOS{
				if(Util.isIOS)
				{
					shareOnIOS(SocialServiceType.TWITTER);
				}
			}
			CONFIG::isAndroid {
				if (Util.isAndroid)
				{
					var text:String = LangUtil.getText("shareMsg");
					text = Util.replaceStr(text, ["@cat", "@url"], ["\"" + LangUtil.getText(_cat) + "\"", Constants.SHORT_LINK]);
					Util.shareOnTTAndroid(text, Util.g_takeSnapshot(), onShareOnAnroidComplete);
					PopupMgr.removePopup(this);
					PopupMgr.addPopUp(Factory.getInstance(LoadingIcon));
					delayCalled = Starling.juggler.delayCall(onShareOnAnroidComplete, 15, false);
				}
			}
		}
		
		private function onScoreBt():void 
		{
			var highscoreDB:GameService = Factory.getInstance(GameService);
			var logic:Fasthand = Factory.getInstance(Fasthand);
			var cat:String = logic.cat;			
			if(Util.isIOS)
			{			
				highscoreDB.showGameCenterHighScore(cat);
			}
			else if (Util.isAndroid)
			{
				highscoreDB.showGooglePlayLeaderboard(cat);
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
		}
		
		override public function onRemoved(e:Event):void 
		{
			Factory.removeMouseClickCallback(twitterBt);
			Factory.removeMouseClickCallback(facebookBt);
			particleSys.stop();
			particleSys.removeFromParent();
			LayerMgr.lockGameLayer = false;
			super.onRemoved(e);
		}
		
		public function setScore(score:int, scoreBest:int, subjectPlayed:int):void		
		{
			this.subjectPlayed = subjectPlayed;
			this.scoreBest = scoreBest;
			this.score = score;			
		}
		
		override public function update(time:Number):void 
		{
			super.update(time);
			
			particleSys.advanceTime(time);
		}
		
	}

}