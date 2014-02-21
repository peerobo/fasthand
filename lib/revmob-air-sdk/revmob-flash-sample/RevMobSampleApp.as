package {

	import com.revmob.airextension.RevMob;
	import com.revmob.airextension.events.RevMobAdsEvent;

	import flash.desktop.NativeApplication;
	import flash.system.Capabilities;
	import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
	
	public class RevMobSampleApp extends MovieClip {

		// Just replace the IDs below with your appIDs.
		const ANDROID_APP_ID:String = "5106bea78e5bd71500000098";
		const IOS_APP_ID:String = "5106be9d0639b41100000052";

		var revmob:RevMob;
		
		public function RevMobSampleApp() {
			btnStartSession.addEventListener(MouseEvent.CLICK, startSession);
			btnDisableTestMode.addEventListener(MouseEvent.CLICK, disableTestMode);
			btnTestWithAds.addEventListener(MouseEvent.CLICK, testWithAds);
			btnTestWithoutAds.addEventListener(MouseEvent.CLICK, testWithoutAds);
			btnShowPopup.addEventListener(MouseEvent.CLICK, showPopup);
			btnCreatePopup.addEventListener(MouseEvent.CLICK, createPopup);
			btnShowFullscreen.addEventListener(MouseEvent.CLICK, showFullscreen);
			btnHideFullscreen.addEventListener(MouseEvent.CLICK, hideFullscreen);
			btnCreateFullscreen.addEventListener(MouseEvent.CLICK, createFullscreen);
			btnReleaseFullscreen.addEventListener(MouseEvent.CLICK, releaseFullscreen);
			btnShowBanner.addEventListener(MouseEvent.CLICK, showBanner);
			btnCreateBanner.addEventListener(MouseEvent.CLICK, createBanner);
			btnReleaseBanner.addEventListener(MouseEvent.CLICK, releaseBanner);
			btnHideBanner.addEventListener(MouseEvent.CLICK, hideBanner);
			btnShowCustomBanner.addEventListener(MouseEvent.CLICK, showCustomBanner);
			btnOpenLink.addEventListener(MouseEvent.CLICK, openLink);
			btnCreateLink.addEventListener(MouseEvent.CLICK, createLink);
		}

		public function startSession(event:MouseEvent):void {
			var appId:String = null;
			
			if ( isIOS() ) 
			{
				appId = IOS_APP_ID;
			} 
			else if ( isAndroid() ) 
			{
				appId = ANDROID_APP_ID;
			} 
			
			revmob = new RevMob(appId);
			revmob.printEnvironmentInformation();
			
			// Register the events that you want to listen
			revmob.addEventListener( RevMobAdsEvent.AD_CLICKED, onAdsEvent );
			revmob.addEventListener( RevMobAdsEvent.AD_DISMISS, onAdsEvent );
			revmob.addEventListener( RevMobAdsEvent.AD_DISPLAYED, onAdsEvent );
			revmob.addEventListener( RevMobAdsEvent.AD_NOT_RECEIVED, onAdsEvent );
			revmob.addEventListener( RevMobAdsEvent.AD_RECEIVED, onAdsEvent );
		}

		public function disableTestMode(event:MouseEvent):void {
			revmob.setTestingMode(false);
			revmob.setTestingWithoutAds(false);
		}

		public function testWithAds(event:MouseEvent):void {
			revmob.setTestingMode(true);
			revmob.setTestingWithoutAds(false);
		}

		public function testWithoutAds(event:MouseEvent):void {
			revmob.setTestingMode(false);
			revmob.setTestingWithoutAds(true);
		}

		public function showPopup(event:MouseEvent):void {
			revmob.showPopup();
		}
		
		public function createPopup(event:MouseEvent):void {
			revmob.createPopup();
		}

		public function showFullscreen(event:MouseEvent):void {
			revmob.showFullscreen();
		}

		public function hideFullscreen(event:MouseEvent):void{
			revmob.hideFullscreen();
		}
		
		public function createFullscreen(event:MouseEvent):void{
			revmob.createFullscreen();
		}
		
		public function releaseFullscreen(event:MouseEvent):void{
			revmob.releaseFullscreen();
		}
		
		protected function showBanner(event:MouseEvent):void {
			revmob.showBanner();
		}
		
		protected function showCustomBanner(event:MouseEvent):void {
			revmob.showBanner(10, 100, 400, 50);
		}
		
		protected function hideBanner(event:MouseEvent):void {
			revmob.hideBanner();
		}
		
		protected function createBanner(event:MouseEvent):void {
			revmob.createBanner();
		}
		
		protected function releaseBanner(event:MouseEvent):void {
			revmob.releaseBanner();
		}

		public function openLink(event:MouseEvent):void {
			revmob.openAdLink();
		}
		
		public function createLink(event:MouseEvent):void {
			revmob.createAdLink();
		}

		public function exitApp(event:MouseEvent):void {
			NativeApplication.nativeApplication.exit(0);
		}

		private function isIOS():Boolean {
			return Capabilities.os.toLowerCase().indexOf("ip") > -1;
		}

		private function isAndroid():Boolean {
			return Capabilities.os.toLowerCase().indexOf("linux") > -1;
		}

		private function onAdsEvent( event:RevMobAdsEvent ):void {
			switch(event.name)
			{
				case RevMobAdsEvent.AD_CLICKED:
				{
					lblAdsEvent.text = "Ad clicked";
					break;
				}
				case RevMobAdsEvent.AD_DISMISS:
				{
					lblAdsEvent.text = "Ad dismissed";
					break;
				}
				case RevMobAdsEvent.AD_DISPLAYED:
				{
					lblAdsEvent.text = "Ad displayed";
					break;
				}
				case RevMobAdsEvent.AD_NOT_RECEIVED:
				{
					lblAdsEvent.text = "RevMob ad not received: " + event.error;
					break;
				}
				case RevMobAdsEvent.AD_RECEIVED:
				{
					lblAdsEvent.text = "RevMob ad received";
					break;
				}	
				default:
				{
					lblAdsEvent.text = "";
					break;
				}
			}
		}
	
	}
}