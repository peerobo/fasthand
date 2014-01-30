package  base
{
	import base.font.BaseBitmapFont;
	import base.font.BaseBitmapTextField;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.text.BitmapFontTextFormat;
	import flash.display.Bitmap;
	import flash.geom.Point;		
	import res.Asset;
	import res.ResMgr;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author ndp
	 */
	public class BFConstructor implements IAnimatable
	{		
		public static const BANHMI:String = "banhmi";			
		public static const ARIAL:String = "arial";			
		
		public static const LIST_FONTS:Array = [BANHMI,ARIAL];
		private var xmls:Object = { };
		
		public function BFConstructor() 
		{	
		}					
		
		public static function getTextImage(width:int,height:int,text:String,font:String,color:int=0xFFFFFF,hAlign:String="center",vAlign:String="center",autoscale:Boolean=false):Sprite
		{
			return TextField.getBitmapFont(font).createSprite(width, height, text, -1, color, hAlign, vAlign, autoscale);
		}
		
		public static function getBitmapChar(font:String, charCode:int):Texture
		{
			return TextField.getBitmapFont(font).getChar(charCode).texture;
		}
		
		public static function getTextField(width:int, height:int, text:String,font:String, color:int = 0xFFFFFF, hAlign:String = "center", vAlign:String = "center", autoscale:Boolean = false):BaseBitmapTextField
		{			
			var bitmapFont:BitmapFont = TextField.getBitmapFont(font);			
			var textField:BaseBitmapTextField = Factory.getObjectFromPool(BaseBitmapTextField);
			textField.width = width;
			textField.height = height;
			textField.fontName = font;
			textField.fontSize = bitmapFont.size;
			textField.color = color;
			textField.hAlign = hAlign;
			textField.vAlign = vAlign;			
			textField.autoScale = autoscale;	
			textField.text = text;
			return textField;
		}
		
		public static function getNativeSize(font:String):int
		{			
			return TextField.getBitmapFont(font).size;
		}
		
		/**
		 * use when textfield has only 10-15 characters
		 * @param	width
		 * @param	height
		 * @param	text
		 * @param	font
		 * @param	color
		 * @param	hAlign
		 * @param	vAlign
		 * @param	autoscale
		 * @return
		 */
		public static function getShortTextField(width:int, height:int, text:String, font:String, color:int = 0xFFFFFF, hAlign:String = "center", vAlign:String = "center", autoscale:Boolean = false):BaseBitmapTextField
		{
			var txtField:BaseBitmapTextField = getTextField(width, height, text, font, color, hAlign, vAlign, autoscale);
			txtField.batchable = true;
			return txtField;
		}
		
		static public function init():void 
		{
			Starling.juggler.add(Factory.getTmpInstance(BFConstructor));
		}
		
		static public function storeXML(xml:XML, name:String):void 
		{
			var ins:BFConstructor = Factory.getTmpInstance(BFConstructor);
			ins.xmls[name] = xml.copy();
		}
		
		static public function getFontBySize(fontSize:int):String 
		{
			if(fontSize >=54)
				return BANHMI;
			else
				return ARIAL;
		}
		
		/* INTERFACE starling.animation.IAnimatable */
		
		public function advanceTime(time:Number):void 
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			if (resMgr.assetProgress == 1)
			{				
				for each (var name:String in LIST_FONTS) 
				{
					var xml:XML = this.xmls[name];
					var fontTex:Texture = Asset.getBaseTexture(name);
					var bmpFont:BaseBitmapFont = new BaseBitmapFont(fontTex, xml);
					TextField.registerBitmapFont(bmpFont, name);					
				}
				
				Starling.juggler.remove(this);
			}
		}
	}

}