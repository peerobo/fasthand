package res 
{
	import air.net.URLMonitor;
	import base.CallbackObj;
	import base.Factory;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import org.as3commons.zip.Zip;
	import org.as3commons.zip.ZipFile;
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
		private var monitor:URLMonitor;
		
		private var extraContentList:Array;
		private var extraOnCompleteFunc:Function;
		private var extraOnAdvanceFunction:Function;
		private var extraCurrentIdx:int;
		private var extraURLLoader:URLLoader;
		private var extraURLRequest:URLRequest;
		public var extraCurrentByte:uint;
		public var extraCurrentByte2Load:uint;
		public var extraCurrentSaveDirectory:String;
		public var extraCurrentProgressStr:String;
		
		public function ResMgr() 
		{
			assetMgr = new AssetManager(Starling.contentScaleFactor);			
			assetMgr.verbose = false;
			
			// for dynamic loading
			urlLoader = new URLLoader();			
			urlLoader.addEventListener(Event.COMPLETE, onLoadedItem);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadItemError);
			urlRequest = new URLRequest();
			
			// for extra content download
			extraURLLoader = new URLLoader();
			extraURLRequest = new URLRequest();
			extraURLLoader.dataFormat = URLLoaderDataFormat.BINARY;
			extraURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onExtraContentSecurityError);
			extraURLLoader.addEventListener(IOErrorEvent.IO_ERROR, onExtraIOError);
			extraURLLoader.addEventListener(ProgressEvent.PROGRESS, onExtraDonwloadProgress);
			extraURLLoader.addEventListener(Event.OPEN, onExtraStartDownloadNewItem);
			extraURLLoader.addEventListener(Event.COMPLETE, onCompleteAnItem);
			extraCurrentIdx = -1;
			
			waitList = [];		
			checkInternet();
			NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onNetworkChange);			
			
		}				
		
		private function updateInternalProgress():void
		{
			if (extraCurrentIdx > -1)
			{
				extraCurrentByte = extraURLLoader.bytesLoaded;
				extraCurrentByte2Load = extraURLLoader.bytesTotal;				
			}
			Starling.juggler.delayCall(updateInternalProgress, 0.2);
		}
		
		private function onNetworkChange(e:Event):void 
		{
			checkInternet();
		}
		
		public function checkInternet():void
		{
			monitor = new URLMonitor(new URLRequest("http://www.yahoo.com"));		
			monitor.addEventListener(StatusEvent.STATUS, onMonitor);
			monitor.start();
		}
		
		private function onMonitor(e:StatusEvent):void 
		{
			trace("internet available:", monitor.available,getTimer());
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
			updateInternalProgress();
			
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
		
		/**
		 * get extra content from remote server
		 * @param	assetList
		 * @param	onComplete function():void
		 * @param	onAdvanceFunction function(idx:int):void
		 * @param	onProgressFunction function(progress,idx):void
		 */ 		
		public function getExtraContent(assetList:Array = null, onComplete:Function = null, onAdvanceFunction:Function = null):void
		{
			//onComplete();
			//onAdvanceFunction(idx:int);
			//onProgressFunction(progress:Number, idx:int);
			if(assetList)
			{	extraContentList = assetList.concat();
				extraOnCompleteFunc = onComplete;
				extraOnAdvanceFunction = onAdvanceFunction;				
				extraCurrentIdx = 0;
			}						

			while (checkCacheDirectoryForFiles([extraContentList[extraCurrentIdx]]))
			{				
				onAdvanceFunction(extraCurrentIdx);
				extraCurrentIdx++;
				if (extraCurrentIdx == extraContentList.length)
				{
					extraCurrentIdx = -1;
					onComplete();
					return;
				}
			}
			onAdvanceFunction(extraCurrentIdx);
			downloadExtraContent();			
		}
		
		private function downloadExtraContent():void 
		{
			extraURLRequest.url = extraContentList[extraCurrentIdx];
			extraURLLoader.load(extraURLRequest);
		}
		
		public function checkCacheDirectoryForFiles(urls:Array):Boolean
		{
			var check:Boolean = true;
			for (var i:int = 0; i < urls.length; i++) 
			{
				var entryFile:File = File.cacheDirectory.resolvePath(urls[i]);				
				check &&= entryFile.exists;
				if (!check)
					break;
			}
			return check;
		}
		
		private function onCompleteAnItem(e:Event):void 
		{
			var byteArray:ByteArray = extraURLLoader.data;
			var fileName:String = extraURLRequest.url;
			if (fileName.indexOf("zip"))
			{
				extraCurrentProgressStr = "Extracting sounds...";
				extractZip();
			}
			else
			{
				extraCurrentProgressStr = "Saving...";
				// save file to cache folder
				var regexp:RegExp = /\/(\w*\.\w+)/;
				var result:Array = regexp.exec(fileName);
				if (result)
					fileName = result[1];
				var file:File = File.cacheDirectory.resolvePath(extraCurrentSaveDirectory + fileName);
				var fr:FileStream = new FileStream();
				fr.open(file, FileMode.WRITE);
				fr.writeBytes(byteArray);
				fr.close();				
			}												
			getExtraContent();
		}
		
		private function extractZip():void 
		{
			var zip:Zip = new Zip();
			zip.loadBytes(extraURLLoader.data);
			var count:int = zip.getFileCount();
			for (var i:int = 0; i < count; i++) 
			{
				var zipFile:ZipFile = zip.getFileAt(i);
				
				var file:File = File.cacheDirectory.resolvePath(extraCurrentSaveDirectory + zipFile.filename);
				var fr:FileStream = new FileStream();
				fr.open(file, FileMode.WRITE);
				fr.writeBytes(zipFile.content);
				fr.close();				
			}
		}
		
		private function onExtraStartDownloadNewItem(e:Event):void 
		{
			extraCurrentProgressStr = "Requesting..." + extraURLRequest.url;
			extraCurrentByte = 0;
			extraCurrentByte2Load = 0;
			trace(extraCurrentProgressStr);
		}
		
		private function onExtraDonwloadProgress(e:ProgressEvent):void 
		{
			extraCurrentProgressStr = "Downloading...";
			extraCurrentByte2Load = extraURLLoader.bytesTotal;
			extraCurrentByte = extraURLLoader.bytesLoaded;
			trace(extraCurrentProgressStr);
		}
		
		private function onExtraIOError(e:IOErrorEvent):void 
		{
			extraCurrentProgressStr = "IO Error on link: " + extraURLRequest.url + ". Please contact us!";
			trace(extraCurrentProgressStr);
		}
		
		private function onExtraContentSecurityError(e:SecurityErrorEvent):void 
		{
			extraCurrentProgressStr = "Security Error on link: " + extraURLRequest.url + ". Please contact us!";
			trace(extraCurrentProgressStr);
		}
	}

}