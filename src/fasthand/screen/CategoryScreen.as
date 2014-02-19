package fasthand.screen 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.CallbackObj;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.GlobalInput;
	import base.IAP;
	import base.LangUtil;
	import base.LayerMgr;
	import base.PopupMgr;
	import base.ScreenMgr;
	import base.SoundManager;
	import comp.FlatSwitchButton;
	import comp.HighscoreDB;
	import comp.LoadingIcon;
	import comp.LoopableSprite;
	import comp.PageFooter;
	import fasthand.Fasthand;
	import fasthand.FasthandUtil;
	import fasthand.gui.CategorySelector;
	import fasthand.gui.ConfirmDlg;
	import fasthand.gui.DLCDlg;
	import fasthand.gui.InfoDlg;
	import flash.desktop.NativeApplication;
	import flash.ui.Keyboard;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.ButtonAsset;
	import res.asset.IconAsset;
	import res.asset.SoundAsset;
	import res.ResMgr;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	
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
		private var pageFooter:PageFooter;
		private var isRemindGC:Boolean;
		
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
			//catChooser.visible = false;
			Util.g_centerScreen(catChooser);			
						
			title = BFConstructor.getTextField(Util.appWidth, 1, "", BFConstructor.BANHMI, Color.YELLOW);			
			title.autoSize = TextFieldAutoSize.VERTICAL;
			title.touchable = false;
			addChild(title);
			title.y = 30;
			/*
			var text:BaseBitmapTextField = BFConstructor.getTextField(1, 1, "FULL", BFConstructor.BANHMI);
			text.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			text.x = (Util.appWidth >> 1) + 380;
			text.y = title.y + 100;
			text.scaleX = text.scaleY = 0.5;		
			//if(Util.isFullApp)
				addChild(text);	
			
			var icon:DisplayObject = Asset.getBaseImage(IconAsset.ICO_RIBBON);
			icon.x = 450;
			icon.y = 42;
			addChild(icon);*/
			
			var logic:Fasthand = Factory.getInstance(Fasthand);
			title.text = LangUtil.getText("welcome");		
			var len:int = title.text.length;
			title.colors = [];
			title.colorRanges = [];
			var len1:int = COLOR_RND.length;
			for (var i:int = 0; i < len; i++) 
			{
				var c:int = COLOR_RND[i];
				title.colors.push(c);
				title.colorRanges.push(i + 1);
			}
			
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			cb = globalInput.registerSwipe(onSwipe);
			if(Util.isAndroid)
				globalInput.registerKey(Keyboard.BACK, onBackAndroidBt);
			
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
						
			// test download
			//var downloadDLC:DLCDlg = Factory.getInstance(DLCDlg);
			//PopupMgr.addPopUp(downloadDLC);
			//var resMgr:ResMgr = Factory.getInstance(ResMgr);
			//var arr:Array = new Array();
			//arr = arr.concat(Asset.getExtraContent(FasthandUtil.getListCat()[6]));
			//arr = arr.concat(Asset.getExtraContent(FasthandUtil.getListCat()[7]));
			//arr = arr.concat(Asset.getExtraContent(FasthandUtil.getListCat()[8]));
			//arr = arr.concat(Asset.getExtraContent(FasthandUtil.getListCat()[9]));
			//resMgr.getExtraContent(arr,
				//function():void{downloadDLC.msg = "complete!"},
				//function(idx:int):void{downloadDLC.msg = ""}	
			//);
			
		}
		
		private function onBackAndroidBt():void 
		{
			if (Util.isAndroid)
			{
				var cDlg:ConfirmDlg = Factory.getInstance(ConfirmDlg);
				cDlg.text = LangUtil.getText("onExit");
				cDlg.callback = onConfirmExit;
				PopupMgr.addPopUp(cDlg);
				NativeApplication.nativeApplication.exit();
			}
		}
		
		private function onConfirmExit(isYes:Boolean):void 
		{			
			if (isYes)
				NativeApplication.nativeApplication.exit();		
		}
		
		private function onRateMe():void 
		{
			SoundManager.playSound(SoundAsset.SOUND_CLICK);
			Util.rateMe();					
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
		
		public function refresh():void 
		{
			catChooser.refresh();
		}
		
	}

}