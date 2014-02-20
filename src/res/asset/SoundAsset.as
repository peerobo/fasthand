package res.asset 
{
	import base.Factory;
	import base.SoundManager;
	import flash.filesystem.File;
	
	/**
	 * sound list
	 * @author ndp
	 */
	public class SoundAsset 
	{
		public static const FOLDER:String = "asset/sounds/";
		public static const GUI:String = "gui/";		
		
		public static const THEME_SONG:String = FOLDER + GUI + "theme.mp3";		
		public static const SOUND_TIMEOUT:String = FOLDER + GUI + "timeout.mp3";		
		public static const SOUND_END_GAME:String = FOLDER + GUI + "endgame.mp3";		
		public static const SOUND_HIGH_SCORE:String = FOLDER + GUI + "highscore.mp3";		
		public static const SOUND_CLICK:String = FOLDER + GUI + "click.mp3";		
		
		public static var currProgress:int;
		private static var listSound:Object;
		private static var currCat:String;				
		
		public static function preload():void
		{		
			SoundManager.getSound(SOUND_CLICK);
			SoundManager.getSound(SOUND_TIMEOUT);			
			SoundManager.getSound(SOUND_END_GAME);
			SoundManager.getSound(SOUND_HIGH_SCORE);
			if (!listSound)
				listSound = { };
		}
		
		public static function download(cat:String, list:Array, isExternal:Boolean = false):void
		{
			if (!listSound)
			{
				listSound = { };
				currCat = null;
			}
			if (listSound[cat])
			{
				onDownloadDone(1);
				return;
			}
			listSound[cat] = false;
			currCat = cat;
			currProgress = 0;
			var soundManager:SoundManager = Factory.getInstance(SoundManager);
			for (var i:int = 0; i < list.length; i++) 
			{
				if(!isExternal)
					soundManager.queueSound(FOLDER + cat + "/" + list[i] + ".mp3", getName(cat, list[i]));
				else 
					soundManager.queueSound(File.cacheDirectory.resolvePath(cat + "/" + list[i] + ".mp3"), getName(cat, list[i]));
			}
			soundManager.loadAll(onDownloadDone);
		}
		
		static private function onDownloadDone(progress:Number):void 
		{
			currProgress = progress;
			if (progress == 1)
			{
				listSound[currCat] = true;
				currCat = null;				
			}
		}
		
		
		public function SoundAsset() 
		{
			
		}
				
		public static function getName(cat:String, file:String):String
		{
			return cat + "_" + file;
		}
	}

}