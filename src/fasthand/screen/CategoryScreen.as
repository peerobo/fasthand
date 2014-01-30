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
	import comp.LoadingIcon;
	import comp.LoopableSprite;
	import fasthand.Fasthand;
	import fasthand.FasthandUtil;
	import fasthand.gui.CategorySelector;
	import res.Asset;
	import res.asset.ButtonAsset;
	import res.asset.SoundAsset;
	import res.ResMgr;
	import starling.events.Event;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Color;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class CategoryScreen extends LoopableSprite 
	{
		private var btBack:BaseButton;
		private var title:BaseBitmapTextField;
		private var catChooser:CategorySelector;
		private var cb:CallbackObj;
		
		private var waitTime2ShowAd:int;
		private var wait4Sound:Boolean;
		
		public function CategoryScreen() 
		{
			super();	
			catChooser = new CategorySelector();
			catChooser.onSelectCategoryCallback = selectCategory;
			waitTime2ShowAd = Constants.AD_FULL_WAITTIME;
		}
		
		private function selectCategory(cat:String):void 
		{			
			var logic:Fasthand = Factory.getInstance(Fasthand);
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
												
			addChild(catChooser);
			Util.g_centerScreen(catChooser);
			
			btBack = ButtonAsset.getBaseBt(ButtonAsset.BT_BACK);
			btBack.setCallbackFunc(onBackToMainScreen);
			addChild(btBack);
			btBack.x = 30;
			btBack.y = 18;
			
			var str:String = " " + LangUtil.getText("currentMode");
			title = BFConstructor.getTextField(Util.appWidth, 1, "", BFConstructor.BANHMI,Color.WHITE);
			title.autoSize = TextFieldAutoSize.VERTICAL;
			title.touchable = false;
			addChild(title);
			title.y = 0;
			
			var logic:Fasthand = Factory.getInstance(Fasthand);
			title.text = LangUtil.getText("chooseCategory");
			var parts:Array = str.split("@mode");
			title.add(parts[0], Color.SILVER);
			title.add(logic.difficult ? LangUtil.getText("fast"):LangUtil.getText("slow"), logic.difficult ? Color.RED:Color.GREEN);
			title.add(parts[1], Color.SILVER);
			
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			cb = globalInput.registerSwipe(onSwipe);
			
			waitTime2ShowAd--;
			if (waitTime2ShowAd == 0)
			{
				Util.showFullScreenAd();
				waitTime2ShowAd = Constants.AD_FULL_WAITTIME;
			}
		}
		
		private function onSwipe(mode:int):void 
		{
			if (mode == GlobalInput.INPUT_SWIPE_LEFT)
				catChooser.onBackPage();
			else if (mode == GlobalInput.INPUT_SWIPE_RIGHT)
				catChooser.onNextPage();
		}
		
		private function onBackToMainScreen():void 
		{			
			ScreenMgr.showScreen(MainScreen);
			
			SoundManager.playSound(SoundAsset.SOUND_CLICK);
		}
		
		override public function onRemoved(e:Event):void 
		{		
			catChooser.removeFromParent();
			
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