package comp 
{
	import base.BaseButton;
	import base.CallbackObj;	
	import base.LangUtil;
	import base.LayerMgr;
	import base.TwitterAlt;
	import com.facebook.graph.data.FacebookSession;
	import com.facebook.graph.FacebookMobile;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import isle.susisu.twitter.events.TwitterErrorEvent;
	import isle.susisu.twitter.events.TwitterRequestEvent;
	import isle.susisu.twitter.TwitterRequest;
	import res.asset.ButtonAsset;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	/**
	 * ...
	 * @author ndp
	 */
	public class SocialForAndroid implements IAnimatable
	{		
		public static const FACEBOOK_TYPE:int = 0;		
		public static const TWITTER_TYPE:int = 1;				
		
		private const FB_PUBLISH_PERMISSION:String = "publish_actions";
		private const FB_READ_PERMISSIONS:Array = ["email"];		
				
		private var callbackFBObj:CallbackObj;
		
		private var fbAccessToken:String;
		private var fbLoginSuccess:Boolean;
		private var fbUserID:String;
		private var fbUserName:String;
		
		private var webView:StageWebView;
		private var msg:String;
		private var image:BitmapData;
		private var onComplete:Function;
		private var canPostFBRightNow:Boolean;
		
		private var twitter:TwitterAlt;
		private var twitterLogged:Boolean;
		private var twitterUsername:String;
		
		private var closeBt:BaseButton;
		
		public function SocialForAndroid() 
		{			
			fbUserName = null;
			twitterUsername = null;			
		}
		
		public function get FBName():String
		{
			return fbUserName;
		}
		
		public function get TwitterName():String
		{
			return twitterUsername;
		}
		
		public function init():void
		{
			fbAccessToken = Util.getPrivateKey(Constants.FB_KEY);
			FacebookMobile.init(Constants.FACEBOOK_APP_ID, onInitFBDone, fbAccessToken);			
			var twitterToken:String = Util.getPrivateKey(Constants.TWITTER_KEY);
			if(twitterToken)
			{
				var tokenSet:Object = JSON.parse(twitterToken);
				twitter = new TwitterAlt(tokenSet.consumerKey, tokenSet.consumerKeySecret, tokenSet.oauthToken, tokenSet.oauthTokenSecret);
				twitterLogged = true;
				var twitterRequest:TwitterRequest = twitter.account_verifyCredentials();				
				twitterRequest.addEventListener(TwitterRequestEvent.COMPLETE, onGetTwitterAccountInfoComplete);
				FPSCounter.log("twitter logged");				
			}
			else
			{
				twitterLogged = false;
				twitter = new TwitterAlt(Constants.TWITTER_PUBLIC_CONSUMER, Constants.TWITTER_SECRET_CONSUMER);
				twitter.callbackURL = Constants.TWITTER_URL_CALLBACK;						
				FPSCounter.log("twitter init failed");
			}			
		}				
		
		public function share(type:int, msg:String, image:BitmapData, onComplete:Function):void		
		{
			this.onComplete = onComplete;
			this.image = image;
			this.msg = msg;			
			if (!closeBt)
			{
				closeBt = ButtonAsset.getBaseBt(ButtonAsset.BT_BLUE);
				closeBt.destroyOnRemove = false;
				closeBt.setText(LangUtil.getText("cancel"),true);
				closeBt.setCallbackFunc(cancelShare );
			}
			if (type == FACEBOOK_TYPE)
			{				
				if (canPostFBRightNow)
				{
					postFBPhoto(msg, image);
				}
				else
				{
					Starling.juggler.add(this);
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
			else if (type == TWITTER_TYPE)
			{
				if (twitterLogged)
				{
					postTwitterPhoto(msg, image);					
				}
				else
				{
					Starling.juggler.add(this);
					var request:TwitterRequest = twitter.oauth_requestToken();
					request.addEventListener(TwitterRequestEvent.COMPLETE, onTwitterOauthTokenComplete);
				}
				
			}
		}
		
		private function cancelShare():void 
		{
			webView.stage = null;
			webView.stop();
			webView.removeEventListener(ErrorEvent.ERROR, onNavigateToServiceError);
			webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, onChangeLocation);			
			webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onChangeLocation);
			webView = null;
			closeBt.removeFromParent();
			onComplete(false);
		}
		
		private function prepareWebView():StageWebView
		{
			if(webView)
			{
				webView.removeEventListener(ErrorEvent.ERROR, onNavigateToServiceError);
				webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, onChangeLocation);			
				webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onChangeLocation);
			}
			
			webView = new StageWebView();	
			webView.stage = Starling.current.nativeStage;
			var rec:Rectangle = new Rectangle(0, 0, Util.deviceWidth - Util.deviceWidth / 3, Util.deviceHeight - Util.deviceHeight / 3);
			rec.x = Util.deviceWidth - rec.width >> 1;
			rec.y = 60*Starling.contentScaleFactor;
			webView.viewPort = rec;				
			webView.addEventListener(ErrorEvent.ERROR, onNavigateToServiceError);
			webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onChangeLocation);			
			webView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onChangeLocation);
			return webView;
		}
		
		private function onChangeLocation(e:LocationChangeEvent):void 
		{
			//FPSCounter.log(e.location);
			var url:String = e.location;			
			if (url.indexOf(Constants.TWITTER_URL_CALLBACK) > -1)	// get pin for twitter authorize
			{
				webView.stage = null;
				var search:String = "oauth_verifier=";				
				var startIndex:int = url.lastIndexOf(search);
				if (startIndex == -1)
				{
					onComplete(false);
					return;
				}
				var ourPin:String = url.substr(startIndex + search.length, url.length);				
				var authorizeRequest:TwitterRequest = twitter.oauth_accessToken(ourPin);
				authorizeRequest.addEventListener(TwitterRequestEvent.COMPLETE, onTwitterAuthorizeComplete);
				authorizeRequest.addEventListener(TwitterErrorEvent.CLIENT_ERROR, onTwitterAuthorizeError);				
				authorizeRequest.addEventListener(TwitterErrorEvent.SERVER_ERROR, onTwitterAuthorizeError);				
			}					
		}
		
		private function onNavigateToServiceError(e:ErrorEvent):void 
		{
			webView.stage = null;			
			onComplete(false);
		}
		
		//////////////////////////////////////////////////////////    FACEBOOK
		
		public function logoutFB():void
		{
			FacebookMobile.logout(function facebookLogout(result:Object):void { Util.setPrivateValue(Constants.FB_KEY,"") }, "https://apps.facebook.com/firecheetahstudio/");
		}		
		
		private function onInitFBDone(success:Object, fail:Object):void
		{	
			if (success)
			{
				var session:FacebookSession = success as FacebookSession;
				fbAccessToken = session.accessToken;
				fbLoginSuccess = true;
				fbUserID = session.uid;
				Util.setPrivateValue(Constants.FB_KEY, fbAccessToken);
				FacebookMobile.api("/me", onRequestFBName);
				FPSCounter.log("init fb ok");
			}
			else
			{
				FPSCounter.log("init fb failed");
				fbLoginSuccess = false;
			}		
		}
		
		private function onRequestFBName(result:Object,fail:Object):void 
		{
			// use to delay call for requesting publish permission
			if (fail)
			{
				FPSCounter.log("request fb info failed:", JSON.stringify(fail));
			}
			else if (result)
			{
				fbUserName = result.name;
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
				Util.setPrivateValue(Constants.FB_KEY, fbAccessToken);				
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
				fbUserName = result.name;
				FacebookMobile.requestExtendedPermissions(onRequestFBPermissionComplete, prepareWebView(), FB_PUBLISH_PERMISSION);
			}
		}
		
		private function onRequestFBPermissionComplete(success:Object,fail:Object):void 
		{
			FPSCounter.log("post fb");
			trace("fail", fail);
			trace("success", success);
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
 			image = null;
			msg = null;
		}
		
		private function onPostFBComplete(result:Object,fail:Object):void 
		{
			FPSCounter.log("post fb complete");
			Starling.juggler.remove(this);
			closeBt.removeFromParent();
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
		
		
		//////////////////////////////////////////////////////////    TWITTER
		
		private function postTwitterPhoto(msg:String, image:BitmapData):void
		{			
			var bArr:ByteArray = new ByteArray();
			image.encode(new Rectangle(0, 0, image.width, image.height), new JPEGEncoderOptions(80), bArr);			
			var twitterRequest:TwitterRequest = twitter.statuses_updateWithMedia(msg, bArr);
			twitterRequest.addEventListener(TwitterRequestEvent.COMPLETE, onTwitterPostComplete );
			twitterRequest.addEventListener(TwitterErrorEvent.CLIENT_ERROR, onTwitterPostFail );
			twitterRequest.addEventListener(TwitterErrorEvent.SERVER_ERROR, onTwitterPostFail );			
			msg = null;
			image = null;
		}
		
		private function onTwitterPostFail(e:TwitterErrorEvent):void 
		{
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterRequestEvent.COMPLETE, onTwitterPostComplete);
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterErrorEvent.CLIENT_ERROR, onTwitterPostFail);
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterErrorEvent.CLIENT_ERROR, onTwitterPostFail);
			onComplete(false);
			closeBt.removeFromParent();
			Starling.juggler.remove(this);
		}
		
		private function onTwitterPostComplete(e:TwitterRequestEvent):void 
		{		
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterRequestEvent.COMPLETE, onTwitterPostComplete);
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterErrorEvent.CLIENT_ERROR, onTwitterPostFail);
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterErrorEvent.CLIENT_ERROR, onTwitterPostFail);
			onComplete(true);			
			closeBt.removeFromParent();
			Starling.juggler.remove(this);
		}
		
		private function onTwitterOauthTokenComplete(e:TwitterRequestEvent):void 
		{
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterRequestEvent.COMPLETE, onTwitterOauthTokenComplete);
			
			var url:String = twitter.getOAuthAuthorizeURL();
			prepareWebView();
			webView.loadURL(url);
		}
		
		private function onTwitterAuthorizeError(e:TwitterErrorEvent):void 
		{
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterRequestEvent.COMPLETE, onTwitterAuthorizeComplete);
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterErrorEvent.CLIENT_ERROR, onTwitterAuthorizeError);
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterErrorEvent.CLIENT_ERROR, onTwitterAuthorizeError);
			onComplete(false);
			trace(e.message);
		}
		
		private function onTwitterAuthorizeComplete(e:TwitterRequestEvent):void 
		{
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterRequestEvent.COMPLETE, onTwitterAuthorizeComplete);
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterErrorEvent.CLIENT_ERROR, onTwitterAuthorizeError);
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterErrorEvent.CLIENT_ERROR, onTwitterAuthorizeError);							
			Util.setPrivateValue(Constants.TWITTER_KEY, JSON.stringify(twitter.accessTokenSet));
			
			twitterLogged = true;
			
			var twitterRequest:TwitterRequest = twitter.account_verifyCredentials();				
			twitterRequest.addEventListener(TwitterRequestEvent.COMPLETE, onGetTwitterAccountInfoComplete);			
		}
		
		private function onGetTwitterAccountInfoComplete(e:TwitterRequestEvent):void 
		{
			(e.currentTarget as EventDispatcher).removeEventListener(TwitterRequestEvent.COMPLETE, onGetTwitterAccountInfoComplete);
			var request:TwitterRequest = e.currentTarget as TwitterRequest;
			var response:Object = JSON.parse(request.response);
			twitterUsername = response.name;	
			
			if (image && msg)
				postTwitterPhoto(msg, image);
		}
		
		public function logoutTwitter():void
		{
			Util.setPrivateValue(Constants.TWITTER_KEY, null);			
		}
		
		/* INTERFACE starling.animation.IAnimatable */
		
		public function advanceTime(time:Number):void 
		{					
			if (webView && webView.stage && webView.viewPort && !closeBt.parent)
			{
				FPSCounter.log("show cancel bt");
				var rec:Rectangle = webView.viewPort;
				closeBt.y = rec.bottom / Starling.contentScaleFactor + 24;
				closeBt.x = (rec.x + (rec.width - closeBt.width*Starling.contentScaleFactor >> 1))/Starling.contentScaleFactor;
				LayerMgr.getLayer(LayerMgr.LAYER_EFFECT).addChild(closeBt);								
			}
			else if((!webView || !webView.stage || !webView.viewPort) && closeBt.parent)
			{				
				FPSCounter.log("hide cancel bt");
				closeBt.removeFromParent();
			}
		}
	}

}