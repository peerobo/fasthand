package res 
{
	import base.CallbackObj;
	import base.Factory;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author ndp
	 */
	public class ResMgr 
	{
		private var assetMgr:AssetManager;
		public var assetProgress:Number;
		
		// dynamic loading
		private var urlLoader:URLLoader;
		private var urlRequest:URLRequest;
		private var waitList:Array;	// CallbackObj
		
		public function ResMgr() 
		{
			assetMgr = new AssetManager(Starling.contentScaleFactor);			
			assetMgr.verbose = true;
			
			// for dynamic loading
			urlLoader = new URLLoader();			
			urlLoader.addEventListener(Event.COMPLETE, onLoadedItem);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadItemError);
			urlRequest = new URLRequest();
			
			waitList = [];
		}
		
		private function onLoadedItem(e:Event):void 
		{			
			var callbackObj:CallbackObj = waitList[0];
			if (!callbackObj.p)
				callbackObj.p = [];
			callbackObj.p.splice(0, 0, urlLoader.data);
			callbackObj.f.apply(this, callbackObj.p);
			waitList.splice(0, 1);
			if (waitList.length > 0)
				continueLoad();
		}
		
		private function onLoadItemError(e:IOErrorEvent):void 
		{
			waitList.splice(0, 1);
			if (waitList.length > 0)
				continueLoad();
		}
		
		/**
		 * load dynamic content
		 * @param	url url to load
		 * @param	dataType URLLoaderDataFormat.xxx
		 * @param	onComplete callback function with at least 1 param: f(loadedData:*):void
		 * @param	onCompleteParam optional params, ex: f(loadedData:*,param1,param2):void
		 */
		public function load(url:String, dataType:String, onComplete:Function, onCompleteParam:Array=null):void
		{
			var len:int = waitList.length;
			var item:CallbackObj = Factory.getObjectFromPool(CallbackObj);
			item.f = onComplete;
			item.p = onCompleteParam;
			item.optionalData = { url:url, dataType:dataType };				
			waitList.push(item);			
							
			if (waitList.length == 1)
			{
				continueLoad();
			}
			
		}
		
		private function continueLoad():void
		{
			var item:CallbackObj = waitList[0];
			var url:String = item.optionalData.url;
			var dataType:String = item.optionalData.dataType;
			
			urlRequest.url = url;
			urlLoader.dataFormat = dataType;
			urlLoader.load(urlRequest);
			
		}
		
		public function start():void
		{
			assetMgr.enqueue(Asset.getBasicTextureAtlURL());
			assetMgr.loadQueue(onAssetProgress);			
		}
		
		private function onAssetProgress(progress:Number):void 
		{
			assetProgress = progress;			
		}
		
		public function getTexture(texAtl:String,tex:String):Texture
		{
			return assetMgr.getTextureAtlas(texAtl).getTexture(tex);
		}
		
		public function getTextures(texAtl:String, tex:String):Vector.<Texture>
		{
			return assetMgr.getTextureAtlas(texAtl).getTextures(tex);
		}
		
		public function getXML(name:String):XML
		{
			return assetMgr.getXml(name);
		}
		
		/**
		 * load texture atlas
		 * @param	name texture name
		 * @param	onProgress function(progress:Number):void
		 * @return can download Texture
		 */
		public function loadTextureAtlas(name:String, onProgress:Function):Boolean		
		{			
			if (assetMgr.getTextureAtlas(name + Asset.contentSuffix))
			{
				onProgress(1);
				return true;
			}
			// TODO: check if assetMgr is free or not
			// code here
			if (assetMgr.numQueuedAssets < 1)
			{
				assetMgr.enqueue(Asset.getTextureAtlURL(name));
				assetMgr.loadQueue(onProgress);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function removeTextureAtlas(name:String):void
		{
			assetMgr.removeTextureAtlas(name + Asset.contentSuffix,true);
		}
		
	}

}