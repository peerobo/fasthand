package comp 
{
	import base.CallbackObj;	
	import com.facebook.graph.data.FacebookSession;
	import com.facebook.graph.FacebookMobile;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.events.ErrorEvent;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import starling.core.Starling;
	/**
	 * ...
	 * @author ndp
	 */
	public class SocialForAndroid 
	{		
		public static const FACEBOOK_TYPE:int = 0;		
		public static const TWITTER_TYPE:int = 1;				
		
		private const FB_PUBLISH_PERMISSION:String = "publish_actions";
		private const FB_READ_PERMISSIONS:Array = ["email"];
		private const FB_KEY:String = "fbacesstoken";		
				
		private var callbackFBObj:CallbackObj;
		
		private var fbAccessToken:String;
		private var fbLoginSuccess:Boolean;
		private var fbUserID:String;
		
		private var webView:StageWebView;
		private var msg:String;
		private var image:BitmapData;
		private var onComplete:Function;
		private var canPostFBRightNow:Boolean;
		
		public function SocialForAndroid() 
		{			
		}
		
		public function init():void
		{
			fbAccessToken = Util.getPrivateKey(FB_KEY);
			FacebookMobile.init(Constants.FACEBOOK_APP_ID, onInitFBDone, fbAccessToken);			
		}				
		
		public function share(type:int, msg:String, image:BitmapData, onComplete:Function):void		
		{
			this.onComplete = onComplete;
			this.image = image;
			this.msg = msg;
			
			if (type == FACEBOOK_TYPE)
			{				
				if (canPostFBRightNow)
				{
					postFBPhoto(msg, image);
				}
				else
				{
					if(!fbLoginSuccess)
					{
						FPSCounter.log("request login");					
						FacebookMobile.login(onLoginFBComplete, Starling.current.nativeStage, FB_READ_PERMISSIONS, prepareWebView());					
					}
					else
					{
						FPSCounter.log("request permission");					
						FacebookMobile.requestExtendedPermissions(onRequestFBPermissionComplete, prepareWebView(), FB_PUBLISH_PERMISSION);
					}
				}				
			}
		}
		
		//////////////////////////////////////////////////////////    FACEBOOK
		
		private function onInitFBDone(success:Object, fail:Object):void
		{
			if (success)
			{
				var session:FacebookSession = success as FacebookSession;
				fbAccessToken = session.accessToken;
				fbLoginSuccess = true;
				fbUserID = session.uid;
				Util.setPrivateValue(FB_KEY, fbAccessToken);
				FPSCounter.log("init fb ok");
			}
			else
			{
				FPSCounter.log("init fb failed");
				fbLoginSuccess = false;
			}		
		}
		
		private function onLoginFBComplete(success:Object,fail:Object):void 
		{
			if (success)
			{
				var session:FacebookSession = success as FacebookSession;
				fbAccessToken = session.accessToken;
				fbLoginSuccess = true;
				fbUserID = session.uid;
				FPSCounter.log("login fb success");
				Util.setPrivateValue(FB_KEY, fbAccessToken);				
				FacebookMobile.api("/me", onWaitForUserInfoDone);
				
			}
			else
			{
				FPSCounter.log("login fb failed");
				fbLoginSuccess = false;
				onComplete(false);
			}
		}
		
		private function onWaitForUserInfoDone(result:Object,fail:Object):void 
		{
			// use to delay call for requesting publish permission
			if (fail)
			{
				FPSCounter.log("request fb info failed:", JSON.stringify(fail));
				revokeFBPermission();
			}
			else if (result)
			{
				FPSCounter.log("request fb info success:", result.email);
				FacebookMobile.requestExtendedPermissions(onRequestFBPermissionComplete, prepareWebView(), FB_PUBLISH_PERMISSION);
			}
		}
		
		private function onRequestFBPermissionComplete(success:Object,fail:Object):void 
		{
			FPSCounter.log("post fb");
			if(success)
				postFBPhoto(msg, image);
			else
				revokeFBPermission();
		}
		
		private function revokeFBPermission():void 
		{
			FPSCounter.log("request login in revoke permission");
			FacebookMobile.login(onLoginFBComplete, Starling.current.nativeStage, FB_READ_PERMISSIONS, prepareWebView());
		}
		
		private function postFBPhoto(msg:String, image:BitmapData):void
		{			
			var bArr:ByteArray = new ByteArray();
			image.encode(new Rectangle(0, 0, image.width, image.height), new JPEGEncoderOptions(80), bArr);
			
			var p:Object = { 
				source: bArr,
				message: msg,
				fileName: "highscore.jpg"
			}; 
			FacebookMobile.api("/" + fbUserID + "/photos", onPostFBComplete, p, URLRequestMethod.POST); 			
		}
		
		private function onPostFBComplete(result:Object,fail:Object):void 
		{
			FPSCounter.log("post fb complete");
			if (fail)
			{	
				FPSCounter.log(JSON.stringify(fail));
				onComplete(false);
			}
			else
			{
				canPostFBRightNow = true;
				FPSCounter.log("post fb true! check fb wall!");
				onComplete(true);
			}
		}				
		
		private function prepareWebView():StageWebView
		{
			if(webView)
			{
				webView.removeEventListener(ErrorEvent.ERROR, onNavigateToFBError);
				webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, onConnect2FB);
			}
			
			webView = new StageWebView();			
			var rec:Rectangle = new Rectangle(0, 0, Util.deviceWidth - Util.deviceWidth / 3, Util.deviceHeight - Util.deviceHeight / 3);
			rec.x = Util.deviceWidth - rec.width >> 1;
			rec.y = Util.deviceHeight - rec.height >> 1;
			webView.viewPort = rec;
			webView.stage = Starling.current.nativeStage;
			webView.addEventListener(ErrorEvent.ERROR, onNavigateToFBError);
			webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onConnect2FB);
			return webView;
		}
		
		private function onConnect2FB(e:LocationChangeEvent):void 
		{
			webView.stage = Starling.current.nativeStage;
		}
		
		private function onNavigateToFBError(e:ErrorEvent):void 
		{
			webView.stage = null;
			FPSCounter.log("cannot connect to FB");
			onComplete(false);
		}
		
		
		//////////////////////////////////////////////////////////    TWITTER
	}

}