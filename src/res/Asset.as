package res
{
	import base.BFConstructor;
	import base.Factory;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.filesystem.File;
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
		
		static public const URL_EXTRA_RES:String = "http://firecheetah.com/mobile/fasthandres/";
		
		public static var contentSuffix:String;
		static private var scaleRecs:Object;
		
		public function Asset()
		{
		
		}
		
		public static function get scaleRecCollection():Object
		{
			return scaleRecs;
		}
		
		static public function getBasicTextureAtlURL():Array // png/atf, xml 
		{
			var list:Array = [ASSET_FOLDER + BASE_GUI + contentSuffix + ".atf", 
					ASSET_FOLDER + BASE_GUI + contentSuffix + ".xml"];
					
			for each(var s:String in BFConstructor.LIST_FONTS)
				list.push(TEXT_FOLDER + s + ".xml");
				
			//for each(s in WALL_LIST)
				//list.push(ASSET_FOLDER + s + Asset.contentSuffix +  ".atf", ASSET_FOLDER + s + Asset.contentSuffix + ".xml");
				
			return list;
		}
		
		
		
		static public function getTextureAtlURL(name:String, isExternal:Boolean =false):Array // png/atf, xml 
		{
			var arr:Array;
			if(!isExternal)
				arr = [ASSET_FOLDER + name + contentSuffix + ".atf", ASSET_FOLDER + name + contentSuffix + ".xml"];
			else
			{
				var file:String = name + "/" + name + contentSuffix;
				arr = [File.cacheDirectory.resolvePath( file + ".atf"), File.cacheDirectory.resolvePath(file + ".xml")];
			}
			return arr;
		}
		
		public static function getImage(texAtl:String,str:String):DisplayObject
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			var tex:Texture = resMgr.getTexture(texAtl + Asset.contentSuffix, str);
			if (getRec(str))
			{				
				var simg:Scale9Image = Factory.getObjectFromPool(Scale9Image);				
				//simg.useSeparateBatch = false;
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
		
		public static function getBaseImage(str:String):DisplayObject
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			var tex:Texture = resMgr.getTexture(Asset.BASE_GUI + Asset.contentSuffix, str);
			if (getRec(str))
			{				
				var simg:Scale9Image = Factory.getObjectFromPool(Scale9Image);				
				//simg.useSeparateBatch = false;
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
		
		public static function getBaseTextures(str:String):Vector.<Texture>
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			return resMgr.getTextures(Asset.BASE_GUI + Asset.contentSuffix, str);			
		}
		
		static public function init():void
		{
			var scale:int = int(Starling.contentScaleFactor * 1000)
			if (scale <= 250)
				contentSuffix = "@1x";
			else if (scale <= 375)
				contentSuffix = "@1.5x";
			else if (scale <= 500)
				contentSuffix = "@2x";
			else if (scale <= 750)			
				contentSuffix = "@3x";			
			else
				contentSuffix = "@4x";
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
		
		public static function getExtraContent(cat:String):Array
		{
			var urls:Array = [];
			urls.push(URL_EXTRA_RES + cat + "/" + cat + contentSuffix + ".atf");
			urls.push(URL_EXTRA_RES + cat + "/" + cat + contentSuffix + ".xml");
			urls.push(URL_EXTRA_RES + cat + "/" + cat + ".zip");
			return urls;
		}
	}

}