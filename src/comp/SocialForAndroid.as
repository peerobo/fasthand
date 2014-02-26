package comp 
{
	import base.CallbackObj;
	import com.freshplanet.ane.AirFacebook.Facebook;
	import flash.display.BitmapData;
	import flash.net.URLRequestMethod;
	/**
	 * ...
	 * @author ndp
	 */
	public class SocialForAndroid 
	{
		private var fb:Facebook;
		private var fbUserID:String;
		
		public static const FACEBOOK_TYPE:int = 0;		
		private const FB_PERMISSIONS:Array = ["email", "user_about_me", "publish_stream"];
		private var callbackFBObj:CallbackObj;
		
		public function SocialForAndroid() 
		{
			fb = Facebook.getInstance();			
		}
		
		public function init():void
		{
			if (Facebook.isSupported)
			{
				fb.setUsingStage3D(true);
				fb.init(Constants.FACEBOOK_APP_ID);					
				fbUserID = "";
			}
		}
		
		private function onFBPermissionResponse(success:Boolean, userCancelled:Boolean, error:String = null):void 
		{
			FPSCounter.log("FB success", success, ", user canceled", userCancelled, ", error String", error);
			if (success)
			{
				fb.requestWithGraphPath("/me", null, URLRequestMethod.GET, onFBUserinfoComplete);
			}
		}
		
		private function onFBUserinfoComplete(data:Object):void 
		{			
			fbUserID = data.id;
			callbackFBObj.execute();
		}
		
		public function share(type:int, msg:String, image:BitmapData):void		
		{
			if (type == FACEBOOK_TYPE)
			{
				FPSCounter.log("share facebook");
				if (fb.isSessionOpen)
				{
					if(fbUserID == "")
					{
						fb.requestWithGraphPath("/me", null, URLRequestMethod.GET, onFBUserinfoComplete);
					}
					else
					{						
						callbackFBObj = new CallbackObj(postFBPhoto, [msg, image]);
					}
				}
				else
				{
					callbackFBObj = new CallbackObj(postFBPhoto, [msg, image]);
					fb.openSessionWithPublishPermissions(FB_PERMISSIONS, onFBPermissionResponse, false);					
				}
			}
		}
		
		private function postFBPhoto(msg:String, image:BitmapData):void
		{
			var parameters:Object = { };
			parameters.source = image;
			parameters.message = msg;				
			fb.requestWithGraphPath("/" + fbUserID + "/photos", parameters, URLRequestMethod.POST, onPostComplete);
		}
		
		private function onPostComplete():void 
		{
			FPSCounter.log("post fb complete");
		}
		
	}

}