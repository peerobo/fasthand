package fasthand.screen 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.CallbackObj;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.GlobalInput;
	import base.LangUtil;
	import base.LayerMgr;
	import base.PopupMgr;
	import base.ScreenMgr;
	import base.SoundManager;
	import comp.FlatSwitchButton;
	import comp.LoadingIcon;
	import comp.LoopableSprite;
	import fasthand.Fasthand;
	import fasthand.FasthandUtil;
	import fasthand.gui.CategorySelector;
	import res.Asset;
	import res.asset.ButtonAsset;
	import res.asset.SoundAsset;
	import res.ResMgr;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Color;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class CategoryScreen extends LoopableSprite 
	{		
		private var title:BaseBitmapTextField;
		private var catChooser:CategorySelector;
		private var cb:CallbackObj;
		
		private var waitTime2ShowAd:int;
		private var wait4Sound:Boolean;
		private var switchDiff:FlatSwitchButton;
		private const COLOR_RND:Array = [0xF9F900, 0xFFFF06, 0xFFFF11, 0xFFFF1A, 0xFFFF20, 0xFFFF28, 0xFFFF2D, 0xFFFF3C, 0xFFFF42, 0xFFFF48, 0xFFFF4F, 0xFFFF53, 0xFFFF59, 0xFFFF5E, 0xFFFF64, 0xFFFF6A, 0xFFFF6F];		
		
		public function CategoryScreen() 
		{
			super();	
			SoundManager.playSound(SoundAsset.THEME_SONG, true, 0, 0.7);
			catChooser = new CategorySelector();
			catChooser.onSelectCategoryCallback = selectCategory;
			waitTime2ShowAd = Constants.AD_FULL_WAITTIME;
		}
		
		private function selectCategory(cat:String):void 
		{			
			var logic:Fasthand = Factory.getInstance(Fasthand);
			if (cat != logic.cat)
			{
				var resMgr:ResMgr = Factory.getInstance(ResMgr);
				resMgr.removeTextureAtlas(logic.cat);
			}
			logic.cat = cat;
			PopupMgr.addPopUp(Factory.getInstance(LoadingIcon));
			loadContent(cat);	
		}
		
		private function loadContent(cat:String):void 
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			resMgr.loadTextureAtlas(cat, contentLoaded);
		}
		
		private function contentLoaded(progress:Number):void 
		{			
			if (progress == 1)
			{
				var logic:Fasthand = Factory.getInstance(Fasthand);				
				wait4Sound = true;
				SoundAsset.download(logic.cat, FasthandUtil.getListWords(logic.cat));
			}
		}
		
		private function moveToGameScreen():void
		{
			PopupMgr.removePopup(Factory.getInstance(LoadingIcon));
			ScreenMgr.showScreen(GameScreen);				
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			var disp:DisplayObject = Asset.getImage(Asset.WALL_CATEGORY, Asset.WALL_CATEGORY);
			addChild(disp);
			Util.g_centerScreen(disp);
			
			addChild(catChooser);
			Util.g_centerScreen(catChooser);			
						
			title = BFConstructor.getTextField(Util.appWidth, 1, "", BFConstructor.BANHMI, Color.YELLOW);			
			title.autoSize = TextFieldAutoSize.VERTICAL;
			title.touchable = false;
			addChild(title);
			title.y = 30;
			
			var logic:Fasthand = Factory.getInstance(Fasthand);
			title.text = LangUtil.getText("welcome");		
			var len:int = title.text.length;
			title.colors = [];
			title.colorRanges = [];
			var len1:int = COLOR_RND.length;
			for (var i:int = 0; i < len; i++) 
			{
				//var cIDx:int = Math.random() * len1;
				//var c:int = COLOR_RND[cIDx];
				var c:int = COLOR_RND[i];
				title.colors.push(c);
				title.colorRanges.push(i + 1);
			}
			
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			cb = globalInput.registerSwipe(onSwipe);
			
			waitTime2ShowAd--;
			if (waitTime2ShowAd == 0)
			{
				Util.showFullScreenAd();
				waitTime2ShowAd = Constants.AD_FULL_WAITTIME;
			}
			
			switchDiff = new FlatSwitchButton();
			switchDiff.init(LangUtil.getText("fast"), LangUtil.getText("slow"), ButtonAsset.BT_BLUE, ButtonAsset.BT_DARK_GRAY,onSwitchDiff);
			switchDiff.value = logic.difficult;
			addChild(switchDiff );
			switchDiff.y = title.y;
			switchDiff.x = Util.appWidth - 36 - switchDiff.width;			
			
			var rateBt:BaseButton = ButtonAsset.getBaseBt(ButtonAsset.BT_BLUE);
			rateBt.background.width = 288;
			rateBt.background.height = 120;
			rateBt.setText(LangUtil.getText("rate"),true);
			rateBt.setCallbackFunc(onRateMe);
			addChild(rateBt);
			rateBt.y = title.y;
			rateBt.x = 30;						
		}
		
		private function onRateMe():void 
		{
			SoundManager.playSound(SoundAsset.SOUND_CLICK);
		}
		
		private function onSwitchDiff(isDiff:Boolean):void 
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);
			logic.difficult = isDiff;
		}
		
		private function onSwipe(mode:int):void 
		{
			if (mode == GlobalInput.INPUT_SWIPE_LEFT)
				catChooser.onBackPage();
			else if (mode == GlobalInput.INPUT_SWIPE_RIGHT)
				catChooser.onNextPage();
		}				
		
		override public function onRemoved(e:Event):void 
		{		
			catChooser.removeFromParent();
			switchDiff.destroy();
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			globalInput.unregisterSwipe(cb);
			super.onRemoved(e);			
		}
		
		override public function update(time:Number):void 
		{
			super.update(time);
			if (wait4Sound)
			{
				if (SoundAsset.currProgress == 1)
				{
					moveToGameScreen();
					wait4Sound = false;
				}
			}
		}
		
	}

}