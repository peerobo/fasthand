package res.asset 
{
	import base.Factory;
	import base.SoundManager;
	
	/**
	 * sound list
	 * @author ndp
	 */
	public class SoundAsset 
	{
		public static const FOLDER:String = "asset/sounds/";
		public static const INVENTORY:String = "inventory/";
		public static const SKILL:String = "skill/";
		public static const OBJECT:String = "object/";
		
		public static const CASTLE_DESTROYED:String = OBJECT + "castle_destroyed.mp3";
		public static const CITY_MUSIC:String = "Main.mp3";
		public static const CITY_LOST_MUSIC:String = "Main-bi-bat.mp3";
		public static const BATTLE_MUSIC:String = "Battle.mp3";
		public static const WIN_BATTLE_THEME:String = "win_battle_theme.mp3";
		public static const LOSE_BATTLE_THEME:String = "lose_battle_theme.mp3";	
		
		//-----------> inventory
		public static const ARMOR_SOUND:String = INVENTORY + "armor.mp3";
		public static const GLOVES_SOUND:String = INVENTORY + "gloves.mp3";
		public static const HELMET_SOUND:String = INVENTORY + "helmet.mp3";
		public static const NECKLACE_SOUND:String = INVENTORY + "necklace.mp3";
		public static const RING_SOUND:String = INVENTORY + "ring.mp3";
		public static const SHIELD_SOUND:String = INVENTORY + "shield.mp3";
		public static const SHOES_SOUND:String = INVENTORY + "shoes.mp3";
		public static const WEAPON_SOUND:String = INVENTORY + "weapon.mp3";
		
		public static var currProgress:int;
		private static var listSound:Object;
		private static var currCat:String;
		
		public static function preload():void
		{
			/*SoundManager.getSound(RESOURCE_COMPLETE);
			SoundManager.getSound(RESOURCE_HOUSE_BUILT_COMPLETE);
			SoundManager.getSound(RESOURCE_RUN);
			SoundManager.getSound(UNIT_COMPLETE);
			SoundManager.getSound(UNIT_HOUSE_BUILT_COMPLETE);
			SoundManager.getSound(UNIT_RUN);
			SoundManager.getSound(GOLD);
			SoundManager.getSound(GUI_OPEN);
			SoundManager.getSound(UPGRADE_ITEM);
			SoundManager.getSound(BUILD_HOUSE);
			SoundManager.getSound(COLLECT_HOUSE);			
			SoundManager.getSound(STAR_1);
			SoundManager.getSound(STAR_2);
			SoundManager.getSound(STAR_3);
			SoundManager.getSound(STAR_4);
			SoundManager.getSound(HERO_UNLOCK);
			SoundManager.getSound(LVL_UP);
			SoundManager.getSound(ARMOR_SOUND);
			SoundManager.getSound(GLOVES_SOUND);
			SoundManager.getSound(HELMET_SOUND);
			SoundManager.getSound(NECKLACE_SOUND);
			SoundManager.getSound(RING_SOUND);
			SoundManager.getSound(SHIELD_SOUND);
			SoundManager.getSound(SHOES_SOUND);
			SoundManager.getSound(WEAPON_SOUND);
			
			SoundManager.getSound(CASTLE_DESTROYED);
			SoundManager.getSound(WIN_BATTLE_THEME);
			SoundManager.getSound(LOSE_BATTLE_THEME);*/
			if (!listSound)
				listSound = { };
		}
		
		public static function download(cat:String, list:Array):void
		{
			if (!listSound)
			{
				listSound = { };
				currCat = null;
			}
			listSound[cat] = false;
			currCat = cat;
			currProgress = 0;
			var soundManager:SoundManager = Factory.getInstance(SoundManager);
			for (var i:int = 0; i < list.length; i++) 
			{
				soundManager.queueSound(FOLDER + cat + "/" + list[i] + ".mp3",getName(cat,list[i]));
			}
			soundManager.loadAll(onDownloadDone);
		}
		
		static private function onDownloadDone(progress:Number):void 
		{
			currProgress = progress;
			if (progress == 1)
			{
				listSound[currCat]
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