package res
{
	import base.BFConstructor;
	import base.Factory;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import res.asset.BackgroundAsset;
	import res.asset.ButtonAsset;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class Asset
	{
		public static const ASSET_FOLDER:String = "asset/textures/";
		public static const TEXT_FOLDER:String = "asset/texts/";
		
		public static const BASE_GUI:String = "gui";		
		
		public static var contentSuffix:String;
		static private var scaleRecs:Object;
		
		public function Asset()
		{
		
		}
		
		static public function getBasicTextureURL():Array // png/atf, xml 
		{
			return [
				ASSET_FOLDER + BASE_GUI + contentSuffix + ".png", 
				ASSET_FOLDER + BASE_GUI + contentSuffix + ".xml",
				TEXT_FOLDER + BFConstructor.BANHMI_ASSET
				]
		}
		
		static public function getTextureURL(name:String):Array // png/atf, xml 
		{
			return [ASSET_FOLDER + name + contentSuffix + ".png", ASSET_FOLDER + name + contentSuffix + ".xml"]
		}
		
		public static function getBaseImage(str:String):DisplayObject
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			var tex:Texture = resMgr.getTexture(Asset.BASE_GUI + Asset.contentSuffix, str);
			if (getRec(str))
			{
				var simg:Scale9Image = new Scale9Image(new Scale9Textures(tex, getRec(str)))
				return simg;
			}
			else
			{
				return new Image(tex);
			}
		}
		
		public static function getBaseTexture(str:String):Texture
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			var tex:Texture = resMgr.getTexture(Asset.BASE_GUI + Asset.contentSuffix, str);
			return tex;
		}
		
		static public function init():void
		{
			if (Starling.contentScaleFactor < 0.4)			
				contentSuffix = "-ld";			
			else if (Starling.contentScaleFactor < 0.7)
				contentSuffix = "-sd";
			else
				contentSuffix = "-hd";
			
		}
		
		public static function getRec(name:String):Rectangle
		{
			var rec:* = null;
			if (!scaleRecs)
				scaleRecs = { };
			if (!scaleRecs.hasOwnProperty(name))
			{
				switch (name)
				{					
					case BackgroundAsset.BG_ITEM: 					
						rec = new Rectangle(16,17,60,60);
						break;
					
					case BackgroundAsset.BG_TITLE: 
					{
						rec = new Rectangle(112, 39, 74, 8);
						break;
					}
					case BackgroundAsset.BG_TITLE_BAR: 
					{
						rec = new Rectangle(59, 37, 118, 7);
						break;
					}
					case BackgroundAsset.BG_WINDOW: 
					{					
						rec = new Rectangle(85, 143, 170, 19);
						break;
					}
					case BackgroundAsset.BG_HOUSE_STT: 
					{
						rec = new Rectangle(6, 6, 6, 6);
						break;
					}
					//case BackgroundAsset.BG_TILE:
						//rec = new Rectangle(12, 12, 18, 18);					
						//rec = new Rectangle(0, 0, 46, 39);					
					//break;
					case BackgroundAsset.BG_TILE_HEADER:
						rec = new Rectangle(24, 12, 54, 24);
					break;
					case ButtonAsset.BT_CYAN: 										
					{
						rec = new Rectangle(61,11,13,5);
						
						break;
					}
					case ButtonAsset.BT_CYAN: 										
					{
						rec = new Rectangle(61,11,13,5);					
						break;
					}
					case ButtonAsset.BT_LIGHT_BROWN: 										
					{
						rec = new Rectangle(57,11,13,6);						
						break;
					}
					default: 
					{
						
						rec = null;
						break;
					}
				}
				scaleRecs[name] = rec;
			}
			return scaleRecs[name];
		}
	
		public static function getTAName(cat:String):String
		{
			return cat + contentSuffix;
		}
	}

}