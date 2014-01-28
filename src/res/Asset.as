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
		
		public static function get scaleRecCollection():Object
		{
			return scaleRecs;
		}
		
		static public function getBasicTextureURL():Array // png/atf, xml 
		{
			return [
				ASSET_FOLDER + BASE_GUI + contentSuffix + ".atf", 
				ASSET_FOLDER + BASE_GUI + contentSuffix + ".xml",
				TEXT_FOLDER + BFConstructor.BANHMI_ASSET
				]
		}
		
		static public function getTextureURL(name:String):Array // png/atf, xml 
		{
			return [ASSET_FOLDER + name + contentSuffix + ".atf", ASSET_FOLDER + name + contentSuffix + ".xml"]
		}
		
		public static function getBaseImage(str:String):DisplayObject
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			var tex:Texture = resMgr.getTexture(Asset.BASE_GUI + Asset.contentSuffix, str);
			if (getRec(str))
			{				
				var simg:Scale9Image = Factory.getObjectFromPool(Scale9Image);				
				//var simg:Scale9Image = new Scale9Image(new Scale9Textures(tex, getRec(str)));
				simg.textures = new Scale9Textures(tex, getRec(str));				
				simg.readjustSize();
				simg.width = tex.width;
				simg.height = tex.height;
				return simg;
			}
			else
			{
				var img:Image = Factory.getObjectFromPool(Image);
				img.texture = tex;
				img.readjustSize();
				return img;
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
			scaleRecs = { };
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