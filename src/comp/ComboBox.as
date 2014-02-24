package comp 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.Factory;
	import res.Asset;
	import res.asset.IconAsset;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Color;
	/**
	 * ...
	 * @author ndp
	 */
	public class ComboBox extends LoopableSprite 
	{
		private var boxBgTex:String;
		private var dropDownTex:String;
		public var list:Array;
		public var selectedIdx:int;
		private var dropDownSpr:LoopableSprite;
		private var onSelectItem:Function;	// onSelectItem(idx):void;
		private var optionalParam:Array;
		private var iconDropDownStr:String;
		
		public function ComboBox() 
		{
			super();
			dropDownSpr = new LoopableSprite();
		}
		
		public function init(boxBG:String, dropDownItemBG:String, iconDropDownStr:String):void
		{
			this.iconDropDownStr = iconDropDownStr;
			boxBgTex = boxBG;
			dropDownTex =  dropDownItemBG;
		}
		
		public function initList(list:Array, defaultIdx:int, onItemSelected:Function, optionalParam:Array):void
		{
			this.optionalParam = optionalParam;
			this.list = list;
			selectedIdx =  defaultIdx;
			onSelectItem = onItemSelected;
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			var boxBG:DisplayObject = Asset.getBaseImage(boxBgTex);
			addChild(boxBG);
			
			var w:int = 0;
			var len:int = list.length;
			var textField:TextField = BFConstructor.getTextField(1, 1, "", BFConstructor.ARIAL, Color.YELLOW);
			textField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textField.touchable = false;
			textField.name = "selectedT";
			for (var i:int = 0; i < len; i++) 
			{
				textField.text = list[i];
				w = textField.width > w ? textField.width : w;				
			}
			boxBG.width = w + BaseButton.PADDNG*2;
			boxBG.height = textField.height + BaseButton.PADDNG * 2;
			textField.text = list[selectedIdx];
			textField.x = BaseButton.PADDNG;
			textField.y = BaseButton.PADDNG;
			addChild(textField);
			Factory.addMouseClickCallback(boxBG, onTouchCboBox);
			
			addChild(dropDownSpr);
			for (var j:int = 0; j < len; j++) 
			{
				var itemBG:DisplayObject = Asset.getBaseImage(dropDownTex);				
				dropDownSpr.addChild(itemBG);
				itemBG.y = boxBG.height * j;
				itemBG.height = boxBG.height;
				itemBG.width = boxBG.width;
				var text:TextField = BFConstructor.getTextField(itemBG.width, itemBG.height, list[j], BFConstructor.ARIAL);
				if (j == selectedIdx)
					text.color = Color.YELLOW;
				text.x = itemBG.x;
				text.y = itemBG.y;
				text.touchable = false;
				text.name = "text" + j;
				dropDownSpr.addChild(text);
				Factory.addMouseClickCallback(itemBG,onTouchItem, [j]);
			}
			dropDownSpr.y = boxBG.height;
			dropDownSpr.visible = false;			
			
			var iconDropDown:DisplayObject = Asset.getBaseImage(IconAsset.ICO_DROP_DOWN);
			iconDropDown.name = "ico";
			addChild(iconDropDown);
			iconDropDown.x = boxBG.width;
			boxBG.width += iconDropDown.width + BaseButton.PADDNG;
			dropDownSpr.x = iconDropDown.width + BaseButton.PADDNG;
			iconDropDown.y = boxBG.height -iconDropDown.height >> 1;
		}
		
		private function onTouchItem(idx:int):void 
		{
			if (dropDownSpr.visible)
			{
				for (var i:int = 0; i < list.length; i++) 
				{
					var textF:TextField = dropDownSpr.getChildByName("text" + i) as TextField;
					if (i == idx)
						textF.color = Color.YELLOW;
					else
						textF.color = Color.WHITE;
				}
				selectedIdx = idx;
				textF = getChildByName("selectedT") as TextField;
				textF.text = list[idx];
				dropDownSpr.visible = false;
				
				var ico:DisplayObject = getChildByName("ico");
				ico.scaleY = 1;
				ico.y -= ico.height;
				
				if (optionalParam)
				{
					var p:Array = optionalParam.concat();
					p.splice(0, 0, idx);
					onSelectItem.apply(this, p);
				}
				else
				{
					onSelectItem(idx);			
				}								
			}
		}
		
		private function onTouchCboBox():void 
		{
			var ico:DisplayObject;
			if (!dropDownSpr.visible)
			{
				dropDownSpr.visible = true;
				ico = getChildByName("ico");
				ico.scaleY = -1;
				ico.y += ico.height;
			}
			else
			{
				dropDownSpr.visible = false;
				ico = getChildByName("ico");
				ico.scaleY = 1;
				ico.y -= ico.height;
			}
		}
		
		override public function onRemoved(e:Event):void 
		{
			dropDownSpr.removeFromParent();
			super.onRemoved(e);
		}
		
	}

}