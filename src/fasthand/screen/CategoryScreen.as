package fasthand.screen 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.LangUtil;
	import base.LayerMgr;
	import base.SoundManager;
	import comp.LoopableSprite;
	import fasthand.Fasthand;
	import fasthand.gui.CategorySelector;
	import res.Asset;
	import res.asset.ButtonAsset;
	import res.asset.SoundAsset;
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
		
		public function CategoryScreen() 
		{
			super();	
			catChooser = new CategorySelector();
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
			btBack.name = "hello";
			
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
		}
		
		private function onBackToMainScreen():void 
		{
			var mainScreen:MainScreen = Factory.getInstance(MainScreen);
			LayerMgr.getLayer(LayerMgr.LAYER_GAME).addChild(mainScreen);
			this.removeFromParent();
			
			SoundManager.playSound(SoundAsset.SOUND_CLICK);
		}
		
		override public function onRemoved(e:Event):void 
		{		
			catChooser.removeFromParent();
			super.onRemoved(e);			
		}
		
	}

}