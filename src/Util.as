package
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.CallbackObj;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.GlobalInput;
	import base.IAP;
	import base.LangUtil;
	import base.PopupMgr;
	import com.adobe.ane.social.SocialServiceType;
	import com.adobe.ane.social.SocialUI;
	import com.freshplanet.ane.AirDeviceId;
	import com.revmob.airextension.events.RevMobAdsEvent;
	import com.revmob.airextension.RevMob;
	import fasthand.gui.InfoDlg;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import starling.core.RenderSupport;	
	import comp.AdEmulator;
	import comp.LoadingIcon;
	import comp.TileImage;
	import fasthand.gui.ConfirmDlg;
	import fasthand.gui.PurchaseDlg;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.data.EncryptedLocalStore;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.net.URLRequest;
	import so.cuo.platform.admob.Admob;
	import so.cuo.platform.admob.AdmobEvent;
	import so.cuo.platform.admob.AdmobPosition;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class Util
	{
		public static const HOVER_FILTER:int = 0;
		public static const DISABLE_FILTER:int = 1;
		public static const DOWN_FILTER:int = 2;
		private static var isInitAd:Boolean;
		static private var revmob:RevMob;
		static private var isCreatingFullscreenAd:Boolean;
		static private var isCreatingBanner:Boolean;
		public static var root:Sprite;				
		
		public static function getFilter(type:int):FragmentFilter
		{
			var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
			switch (type)
			{
				case HOVER_FILTER: 
					colorMatrixFilter.adjustBrightness(0.1);
					colorMatrixFilter.adjustContrast(0.05);
					break;
				case DISABLE_FILTER: 
					colorMatrixFilter.adjustSaturation(-1);
					break;
				case DOWN_FILTER: 
					colorMatrixFilter.adjustBrightness(0.2);
					colorMatrixFilter.adjustContrast(0.4);
					break;
			}
			return colorMatrixFilter;
		}
		
		public function Util()
		{
		
		}	
		
		public static function get isFullApp():Boolean
		{
			var iap:IAP = Factory.getInstance(IAP);
			var ret:Boolean = Util.isIOS ? iap.checkBought(Constants.IOS_PRODUCT_IDS[0]) : false;
			return ret;
		}
		
		public static function shareOnIOS(type:String,msg:String,image:BitmapData):void
		{
			if(SocialUI.isSupported)
			{
				var sUI:SocialUI = new SocialUI(type);
				sUI.setMessage(msg);
				sUI.addImage(image);
				sUI.addEventListener(Event.COMPLETE,onShareIOSDone);
				sUI.addEventListener(ErrorEvent.ERROR,onShareIOSDone);
				sUI.addEventListener(Event.CANCEL,onShareIOSDone);
				sUI.launch();
				var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
				globalInput.setDisableTimeout(3);
			}
			else
			{
				var str:String = LangUtil.getText("shareUnavailable");
				str = Util.replaceStr(str, ["@type"], [type == SocialServiceType.FACEBOOK ? "Facebook":"Twitter"]);
				var infoDlg:InfoDlg = Factory.getInstance(InfoDlg);
				infoDlg.text = str;
				PopupMgr.addPopUp(infoDlg);
			}
		}
		
		private static function onShareIOSDone(e:Event):void 
		{
			switch (e.type) 
			{
				case Event.COMPLETE:
					
				break;
				case Event.CANCEL:
					
				break;
				case ErrorEvent.ERROR:
					
				break;
				default:
			}
			var ed:EventDispatcher = e.currentTarget as EventDispatcher;
			ed.removeEventListener(Event.COMPLETE,onShareIOSDone);
			ed.removeEventListener(ErrorEvent.ERROR,onShareIOSDone);
			ed.removeEventListener(Event.CANCEL,onShareIOSDone);			
		}
		
		public static function rateMe():void
		{			
			navigateToURL(new URLRequest(Constants.SHORT_LINK));
		}
		
		public static function get deviceID():String
		{
			return AirDeviceId.getInstance().getID(Constants.APP_NAME);
		}
		
		public static function g_centerScreen(disp:DisplayObject):void
		{
			disp.x = Util.appWidth - disp.width >> 1;
			disp.y = Util.appHeight - disp.height >> 1;
		}
		
		public static function g_replaceAndColorUp(textField:BaseBitmapTextField, strs2Replace:Array, strs2ReplaceWith:Array, colorup:Array = null):void		
		{
			var str:String = textField.text;
			if (colorup)
			{
				textField.colorRanges = [];
				textField.colors = [];
			}
			var len:int = strs2Replace.length;
			var regexp:RegExp;
			for (var i:int = 0; i < len; i++) 
			{
				regexp = new RegExp(strs2Replace[i]);
				var res:Array = regexp.exec(str);
				if (res)
				{
					str = str.replace(res[0], strs2ReplaceWith[i]);
					if (colorup)
					{
						textField.colors.push(null, colorup[i]);
						textField.colorRanges.push(res.index, res.index + strs2ReplaceWith[i].length);
					}
				}
			}
			textField.text = str;
		}
		
		public static function replaceStr(str:String, strs2Replace:Array, strs2ReplaceWith:Array):String		
		{
			var len:int = strs2Replace.length;
			var regexp:RegExp;
			for (var i:int = 0; i < len; i++) 
			{
				regexp = new RegExp(strs2Replace[i]);
				var res:Array = regexp.exec(str);
				if (res)
				{
					str = str.replace(res[0], strs2ReplaceWith[i]);				
				}
			}
			return  str;
		}
		
		public static function g_centerChild(p:DisplayObject, c:DisplayObject):void
		{
			c.x = p.width - c.width >> 1;
			c.y = p.height - c.height >> 1;
		}
		
		public static function initAd():void
		{
			isInitAd = false;
			if (!Util.isFullApp)
			{
				if(!Util.isDesktop)
				{
					FPSCounter.log("init rev mob");
					revmob = new RevMob(Util.isIOS?Constants.REVMOB_IOS_ID:Constants.REVMOB_ANDROID_ID);
					revmob.setTestingMode(false);
					revmob.setTestingWithoutAds(false);
					revmob.printEnvironmentInformation();
					revmob.addEventListener( RevMobAdsEvent.AD_CLICKED, onRevMobAdEvent );
					revmob.addEventListener( RevMobAdsEvent.AD_DISMISS, onRevMobAdEvent );
					revmob.addEventListener( RevMobAdsEvent.AD_DISPLAYED, onRevMobAdEvent );
					revmob.addEventListener( RevMobAdsEvent.AD_NOT_RECEIVED, onRevMobAdEvent );
					revmob.addEventListener( RevMobAdsEvent.AD_RECEIVED, onRevMobAdEvent );
				}
				
				var admob:Admob = Admob.getInstance();
				if (admob.supportDevice)
				{
					admob.setKeys(Util.isIOS ? Constants.ADMOB_IOS_ID : Constants.ADMOB_ANDROID_ID);
					admob.addEventListener(AdmobEvent.onInterstitialReceive, onAdReceived);
					admob.addEventListener(AdmobEvent.onInterstitialFailedReceive, onAdReceived);
					admob.addEventListener(AdmobEvent.onBannerFailedReceive, onAdReceived);
				}
				isInitAd = true;
			}
		}
		
		static private function onRevMobAdEvent(e:RevMobAdsEvent):void 
		{
			switch(e.name)
			{
				case RevMobAdsEvent.AD_CLICKED:
				{				
					if (isCreatingFullscreenAd)
					{
						revmob.releaseFullscreen();
						//Util.showBannerAd();
						isCreatingFullscreenAd = false;
					}
					break;
				}
				case RevMobAdsEvent.AD_DISMISS:
				{		
					if (isCreatingFullscreenAd)
					{
						revmob.releaseFullscreen();
						//Util.showBannerAd();
						isCreatingFullscreenAd = false;
					}
					break;
				}
				case RevMobAdsEvent.AD_DISPLAYED:
				{					
					break;
				}
				case RevMobAdsEvent.AD_NOT_RECEIVED:
				{	
					FPSCounter.log(e.error, e.name);
					if(isCreatingFullscreenAd)
					{
						PopupMgr.removePopup(Factory.getInstance(LoadingIcon));
						isCreatingFullscreenAd = false;
					}
					else if (isCreatingBanner)
					{
						isCreatingBanner = false;
					}
					break;
				}
				case RevMobAdsEvent.AD_RECEIVED:
				{			
					if (isCreatingFullscreenAd)
					{
						PopupMgr.removePopup(Factory.getInstance(LoadingIcon));
						revmob.showFullscreen();
					}
					else if(isCreatingBanner)
					{			
						revmob.showBanner(0, Util.deviceHeight - 370);
						isCreatingBanner = false
					}
					break;
				}	
				default:
				{					
					break;
				}
			}
		}
		
		public static function g_showConfirm(msg:String, callbackFunc:Function):void
		{
			var confirmDlg:ConfirmDlg = Factory.getInstance(ConfirmDlg);
			confirmDlg.text = msg;
			confirmDlg.callback = callbackFunc;
			PopupMgr.addPopUp(confirmDlg);
		}
		
		public static function showBannerAd():void
		{
			if (isInitAd)
			{
				FPSCounter.log("show ad");
				var admob:Admob = Admob.getInstance();
				admob.showBanner(Admob.SMART_BANNER, AdmobPosition.BOTTOM_CENTER); //show banner with relation position			
				//if (isDesktop)
					//AdEmulator.showBannerAd();					
				//revmob.createBanner(0,Util.deviceHeight - 370);
				//isCreatingBanner = true;
				
			}
		}
		
		public static function hideBannerAd():void
		{
			var admob:Admob = Admob.getInstance();
			
			if(isInitAd)
			{
				//revmob.hideBanner();
				//revmob.releaseBanner();
				if(admob.supportDevice)
					admob.hideBanner();
			}
			if (isDesktop)
				AdEmulator.hideAd();
		}
		
		public static function showFullScreenAd():void
		{
			//Chartboost.getInstance().setInterstitialKeys("4f7b433509b602538043000002", "dd2d41b69ac01b80f44443f5b6cf06096d457f82bd");// app id and sign id created in chartboost.com site
			// then show chartboost Interstitial
			//Chartboost.getInstance().showInterstitial(); 
			//or show chartboost more app page
			//Chartboost.getInstance().showMoreAppPage();
			if (isInitAd)
			{
				//var admob:Admob = Admob.getInstance();
				//if (admob.supportDevice)
				//{
					//admob.cacheInterstitial();				
					//PopupMgr.addPopUp(Factory.getInstance(LoadingIcon));				
				//}
				//Util.hideBannerAd();
				
				revmob.createFullscreen();
				isCreatingFullscreenAd = true;
				PopupMgr.addPopUp(Factory.getInstance(LoadingIcon));				
				if (isDesktop)
					AdEmulator.showFullscreenAd();
			}
		}
		
		private static function closeAdLoadingDlg():void
		{
			PopupMgr.removePopup(Factory.getInstance(LoadingIcon));
		}
		
		public static function numberWithCommas(number:Number):String
		{
			var str:String = number.toString();
			var pattern:RegExp = /(-?\d+)(\d{3})/;
			while (pattern.test(str))
				str = str.replace(pattern, "$1,$2");
			return str;
		}
		
		private static function onAdReceived(e:AdmobEvent):void
		{
			var admob:Admob = Admob.getInstance();
			if (e.type == AdmobEvent.onInterstitialReceive)
			{
				admob.showInterstitial();
				PopupMgr.removePopup(Factory.getInstance(LoadingIcon));
			}
			else if (e.type == AdmobEvent.onBannerFailedReceive)
			{
				FPSCounter.log(JSON.stringify(e.data));
			}
			else if (e.type == AdmobEvent.onInterstitialFailedReceive)
			{				
				PopupMgr.removePopup(Factory.getInstance(LoadingIcon));
			}
			 
		}
		
		public static function get appWidth():int
		{
			return Starling.current.stage.stageWidth;
		}
		
		public static function get appHeight():int
		{
			return Starling.current.stage.stageHeight;
		}
		
		public static function get deviceWidth():int
		{
			return Starling.current.nativeStage.fullScreenWidth;
		}
		
		public static function get deviceHeight():int
		{
			return Starling.current.nativeStage.fullScreenHeight;
		}
		
		public static function getLocalData(soName:String):SharedObject
		{
			var result:SharedObject = SharedObject.getLocal(App.APP_NAME + "_" + soName);
			return result;
		}
		
		public static function g_fit(disp:DisplayObject, fitObj:*):void
		{
			var rec:Rectangle;
			if (fitObj is Rectangle)
			{
				rec = fitObj;
			}
			else if (fitObj is DisplayObject)
			{
				rec = fitObj.getBounds(fitObj);
			}
			disp.width = disp.width > rec.width ? rec.width : disp.width;
			disp.scaleY = disp.scaleX;
			
			disp.height = disp.height > rec.height ? rec.height : disp.height;
			disp.scaleX = disp.scaleY;
			
			disp.x = rec.x + (rec.width - disp.width >> 1);
			disp.y = rec.y + (rec.height - disp.height >> 1);
		}
		
		public static function registerPool():void
		{
			Factory.registerPoolCreator(Image, function():Image
				{
					var img:Image = new Image(Texture.empty(1, 1));
					return img;
				}, function(img:Image):void
				{
					img.x = img.y = 0;
					img.scaleX = img.scaleY = 1;
					img.touchable = true;
					img.visible = true;
					img.filter = null;
					img.pivotY = img.pivotX = 0;
					img.rotation = 0;
					img.alpha = 1;
				});
			
			Factory.registerPoolCreator(MovieClip, function():MovieClip
				{
					var vc:Vector.<Texture> = new Vector.<Texture>();
					vc.push(Texture.empty(1, 1));
					var mc:MovieClip = new MovieClip(vc, 1);
					return mc;
				});
			
			Factory.registerPoolCreator(BaseBitmapTextField, function():BaseBitmapTextField
				{
					return new BaseBitmapTextField(1, 1, "");
				}, function(txt:BaseBitmapTextField):void
				{
					txt.reset();
				});
			
			Factory.registerPoolCreator(CallbackObj, function():CallbackObj
				{
					return new CallbackObj(null);
				}, function(c:CallbackObj):void
				{
					c.f = null;
					c.p = null;
					c.optionalData = null;
				});
			
			//Factory.registerPoolCreator(BaseButton, function():BaseButton {
			//var baseBt:BaseButton = new BaseButton();
			//return baseBt;
			//},
			//function (bt:BaseButton):void {										
			//bt.destroy();					
			//}
			//);
			
			Factory.registerPoolCreator(Quad, function():Quad
				{
					return new Quad(1, 1);
				});
			Factory.registerPoolCreator(Scale9Image, function():Scale9Image
				{
					var scale9Textures:Scale9Textures = new Scale9Textures(Texture.empty(1, 1), new Rectangle(0, 0, 0, 0));
					var scale9Img:Scale9Image = new Scale9Image(scale9Textures);
					return scale9Img;
				}, function(img:Scale9Image):void
				{
					img.x = img.y = 0;
					img.scaleX = img.scaleY = 1;
					img.touchable = true;
					img.visible = true;
					img.filter = null;
					img.pivotY = img.pivotX = 0;
					img.rotation = 0;
					img.alpha = 1;
				});
		}
		
		static public function showInAppPurchase():void
		{
			var purchaseDlg:PurchaseDlg = Factory.getInstance(PurchaseDlg);
			PopupMgr.addPopUp(purchaseDlg);
		}
		
		static public function get isIOS():Boolean
		{
			//return (Capabilities.manufacturer.indexOf("iOS") != -1);
			return AirDeviceId.getInstance().isOnIOS;
		}
		
		static public function get isAndroid():Boolean
		{
			//return (Capabilities.manufacturer.indexOf("Android") != -1);
			return AirDeviceId.getInstance().isOnAndroid;
		}
		
		static public function get isDesktop():Boolean
		{
			return (Capabilities.os.indexOf("Windows ") != -1);
		}
		
		static public function setPrivateValue(key:String, value:String):void
		{
			if (EncryptedLocalStore.isSupported)
			{
				var bytes:ByteArray = new ByteArray();
				bytes.writeUTFBytes(value);
				EncryptedLocalStore.setItem(Constants.APP_NAME + "_" + key, bytes);
			}
		}
		
		static public function getPrivateKey(key:String):String
		{
			if (EncryptedLocalStore.isSupported)
			{
				var storedValue:ByteArray = EncryptedLocalStore.getItem(Constants.APP_NAME + "_" + key);
				return storedValue ? storedValue.readUTFBytes(storedValue.length) : null;
			}
			return null;
		}				
		
		static public function g_takeSnapshot():BitmapData
		{
			var image:BitmapData = new BitmapData(Util.deviceWidth, Util.deviceHeight, true, 0xFFFFFFFF);
			Starling.current.stage.drawToBitmapData(image);
			return image;
		}
	}

}
