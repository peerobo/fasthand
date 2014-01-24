package res.asset
{
	import base.Factory;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import res.Asset;
	import res.ResMgr;
	import starling.extensions.ParticleSystem;
	
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class ParticleAsset
	{				
		public static const PARTICLE_STAR_COMPLETE:String = "starCompleteBattle";
	
		private static var cfgList:Object;
		
		public function ParticleAsset()
		{
			
		}		
		
		static public function loadCfg():void 
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			resMgr.load(Asset.TEXT_FOLDER + PARTICLE_STAR_COMPLETE + ".pex", URLLoaderDataFormat.TEXT, loadComplete, [PARTICLE_STAR_COMPLETE]);
		}
		
		private static function loadComplete(xmlData:String,name:String):void
		{
			if (!cfgList)
			{
				cfgList = { };				
			}			
						
			cfgList[name] = new XML(xmlData);
		}
		
		static public function getUniqueParticleSys(name:String, tex:Texture):PDParticleSystem		
		{
			var particleSystem:PDParticleSystem = new PDParticleSystem( cfgList[name], tex);
			return particleSystem;
		}
	}
}