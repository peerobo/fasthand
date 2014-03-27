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
	import comp.ComboBox;
	import comp.FlatSwitchButton;
	import comp.GameService;
	import comp.LoadingIcon;
	import comp.LoopableSprite;
	import comp.PageFooter;
	import fasthand.gui.AdultDlg;
	import flash.system.System;
	import starling.display.Quad;
	CONFIG::isAndroid{
		import comp.SocialForAndroid;
		import com.fc.FCAndroidUtility;
	}
	import fasthand.Fasthand;
	import fasthand.FasthandUtil;
	import fasthand.gui.CategorySelector;
	import fasthand.gui.ConfirmDlg;
	import fasthand.gui.DLCDlg;
	import fasthand.gui.InfoDlg;
	import flash.data.EncryptedLocalStore;
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
		private var switchDiff:ComboBox;
		private const COLOR_RND:Array = [0xF9F900, 0xFFFF06, 0xFFFF11, 0xFFFF1A, 0xFFFF20, 0xFFFF28, 0xFFFF2D, 0xFFFF3C, 0xFFFF42, 0xFFFF48, 0xFFFF4F, 0xFFFF53, 0xFFFF59, 0xFFFF5E, 0xFFFF64, 0xFFFF6A, 0xFFFF6F];
		private var pageFooter:PageFooter;
		private var isExternalContent:Boolean;
		
		public static var fullApp:Boolean;
		private var cheatCountActivate:int;
		
		public function CategoryScreen()
		{
			super();
			SoundManager.playSound(SoundAsset.THEME_SONG, true, 0, 0.7);
			SoundManager.instance.muteMusic = false;
			catChooser = new CategorySelector();
			catChooser.onSelectCategoryCallback = selectCategory;
			waitTime2ShowAd = Constants.AD_FULL_WAITTIME;
			cheatCountActivate = 0;
			
			var idxDiff:int = parseInt(Util.getPrivateKey("difficultMode"));			
			switchDiff = new ComboBox();
			switchDiff.init(ButtonAsset.BT_BLUE, ButtonAsset.BT_DARK_GRAY, IconAsset.ICO_DROP_DOWN);			
			var values:Array = [LangUtil.getText("slow"), LangUtil.getText("fast")];
			switchDiff.initList(values, idxDiff, onSwitchDiff, [values]);
			
			Util.showBannerAd();			
		}
		
		public function selectCategory(cat:String):void
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);
			if (cat != logic.cat && logic.cat != null )
			{
				var resMgr:ResMgr = Factory.getInstance(ResMgr);
				resMgr.removeTextureAtlas(logic.cat);
				SoundAsset.unload(logic.cat, FasthandUtil.getListWords(logic.cat));
			}
			logic.cat = cat;			
			isExternalContent = FasthandUtil.getListCat().indexOf(cat) >= 6;
			CONFIG::isIOS{
				isExternalContent = FasthandUtil.getListCat().indexOf(cat) >= Constants.CAT_INTERNAL;
			}
			CONFIG::isAndroid{
				isExternalContent = FasthandUtil.getListCat().indexOf(cat) >= Constants.CAT_INTERNAL;
			}			
			loadContent(cat);
		}
		
		private function loadContent(cat:String):void
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			if (!isExternalContent)
			{
				resMgr.loadTextureAtlas(cat, contentLoaded);
				PopupMgr.addPopUp(Factory.getInstance(LoadingIcon));
			}
			else // cache-download-play
			{
				var downloadDLC:DLCDlg = Factory.getInstance(DLCDlg);
				PopupMgr.addPopUp(downloadDLC);
				var fileList:Array = Asset.getExtraContent(cat);
				resMgr.getExtraContent(fileList, onDownloadCompleted, onProgressNextFile);
			}
		}
		
		private function onProgressNextFile(idx:int):void
		{
			var idxCat:int = idx / 3 + 6;
			var idxFile:int = idx % 3;
			var listCat:Array = FasthandUtil.getListCat();
			var catLen:int = listCat.length - 6;
			var str:String = LangUtil.getText("extraContentLoad");
			str = Util.replaceStr(str, ["@cat", "@idxCat", "@totalCat", "@idxFile", "@totalFile"], [LangUtil.getText(listCat[idxCat]), "" + (idxCat - 5), "" + catLen, "" + (idxFile + 1), "3"]);
			var downloadDLC:DLCDlg = Factory.getInstance(DLCDlg);
			downloadDLC.msg = str;
		}
		
		private function onDownloadCompleted():void
		{
			var downloadDLC:DLCDlg = Factory.getInstance(DLCDlg);
			PopupMgr.removePopup(downloadDLC);
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			var logic:Fasthand = Factory.getInstance(Fasthand);
			PopupMgr.addPopUp(Factory.getInstance(LoadingIcon));
			resMgr.loadTextureAtlas(logic.cat, contentLoaded, true);
		}
		
		private function contentLoaded(progress:Number):void
		{
			if (progress == 1)
			{
				var logic:Fasthand = Factory.getInstance(Fasthand);
				wait4Sound = true;
				SoundAsset.download(logic.cat, FasthandUtil.getListWords(logic.cat), isExternalContent);
			}
		}
		
		private function moveToGameScreen():void
		{
			wait4Sound = false;
			PopupMgr.removePopup(Factory.getInstance(LoadingIcon));
			ScreenMgr.showScreen(GameScreen);
		}
		
		override public function onAdded(e:Event):void
		{
			super.onAdded(e);
			
			fullApp = Util.isFullApp;
			
			//var disp:DisplayObject = Asset.getImage(Asset.WALL_CATEGORY, Asset.WALL_CATEGORY);
			//addChild(disp);
			var disp:Quad = Factory.getObjectFromPool(Quad);
			disp.color = 0x9F6311;
			disp.width = Util.appWidth;
			disp.height = Util.appHeight;
			addChild(disp);
			//Util.g_centerScreen(disp);
			
			addChild(catChooser);
			//catChooser.visible = false;
			Util.g_centerScreen(catChooser);
			Util.registerRelayoutAfterAd(onAdChange, false);
			if(Util.isBannerAdShowed)
				catChooser.y -= Util.adBannerHeight;
			
			title = BFConstructor.getTextField(Util.appWidth, 1, "", BFConstructor.BANHMI, Color.YELLOW);
			title.autoSize = TextFieldAutoSize.VERTICAL;
			title.touchable = true;
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
				var c:int = COLOR_RND[i];
				title.colors.push(c);
				title.colorRanges.push(i + 1);
			}
			
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			cb = globalInput.registerSwipe(onSwipe);
			CONFIG::isAndroid {				
				FCAndroidUtility.instance.isHandleBackKey = true;				
				FCAndroidUtility.instance.onBackKeyHandle = onBackAndroidBt;
			}
			//if (Util.isAndroid)
				//globalInput.registerKey(Keyboard.BACK, onBackAndroidBt);
			
			waitTime2ShowAd--;
			if (waitTime2ShowAd == 0)
			{
				Util.showFullScreenAd();
				waitTime2ShowAd = Constants.AD_FULL_WAITTIME;
			}
			
			addChild(switchDiff);
			switchDiff.y = title.y;
			switchDiff.x = Util.appWidth - 36 - switchDiff.width;
			logic.difficult = switchDiff.list[switchDiff.selectedIdx] == LangUtil.getText("fast");
			
			var rateBt:BaseButton = ButtonAsset.getBaseBt(ButtonAsset.BT_BLUE);
			rateBt.background.width = 288;
			rateBt.background.height = 120;
			rateBt.setText(LangUtil.getText("rate"), true);
			rateBt.setCallbackFunc(onRateMe);
			addChild(rateBt);
			rateBt.y = title.y;
			rateBt.x = 30;
			
			Factory.addMouseClickCallback(title, onCheat);			
		}
		
		private function onAdChange(adshowed:Boolean):void 
		{
			Util.g_centerScreen(catChooser)
			if(adshowed)
				catChooser.y -= Util.adBannerHeight;
		}
		
		private function onCheat():void 
		{
			cheatCountActivate++;
			if (cheatCountActivate >= 7)
			{
				EncryptedLocalStore.reset();
				var infoDlg:InfoDlg = new InfoDlg();
				infoDlg.text = "App reset! Exit App pls!";
				PopupMgr.addPopUp(infoDlg);
				cheatCountActivate = 0;
				CONFIG::isAndroid {
					var socialForAndroid:SocialForAndroid = Factory.getInstance(SocialForAndroid);
					socialForAndroid.logoutFB();
					var gameService:GameService = Factory.getInstance(GameService);
					gameService.logout();
				}
			}
		}
		
		
		private function onBackAndroidBt():void
		{
			if (Util.isAndroid)
			{
				//var cDlg:ConfirmDlg = Factory.getInstance(ConfirmDlg);
				//cDlg.text = LangUtil.getText("onExit");
				//cDlg.callback = onConfirmExit;
				//PopupMgr.addPopUp(cDlg);
				
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
			CONFIG::isIOS{
				var confirm:AdultDlg = Factory.getInstance(AdultDlg);
				confirm.callback = Util.rateMe;
				PopupMgr.addPopUp(confirm);
			}
			CONFIG::isAndroid{
				Util.rateMe();
			}
		}
		
		private function onSwitchDiff(idx:int, list:Array):void
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);			
			logic.difficult = list[idx] == LangUtil.getText("fast");
			Util.setPrivateValue("difficultMode", idx.toString());
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
			Util.registerRelayoutAfterAd(onAdChange, true);
			Factory.removeMouseClickCallback(title);
			catChooser.removeFromParent();			
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			globalInput.unregisterSwipe(cb);
			//Util.hideBannerAd();
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
				}
			}
			System.pauseForGCIfCollectionImminent(0);
		}
		
		public function refresh():void
		{
			catChooser.refresh();
		}
	
	}

}