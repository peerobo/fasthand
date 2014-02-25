READ ME - LeadBolt extension for Adobe Air (iOS & Android)

Version 2.1      date: 2014-01-30
================================================================================================================== 


Requirements
------------

1. You must have atleast one of the following: 
	- Flash Professional CS5.5 or later, or 
	- Flash Builder 4.6.0 or later, or
	- FlashDevelop

2. You must have accessed your leadbolt account to register your app and have created ads, retrieved the relevant section ids.

NOTE: This extension package already includes iOS 4.1 & Android 6.1 LeadBolt SDKs, so there is no need to additionally retrieve the Leadbolt SDKs



If using Flash Professional
-----------------------------
To include the Leadbolt extension in youe Flash Professional project

1. In Flash professional, set up a new AIR for iOS or Android project.

2. Download and Unzip the Leadbolt Adobe Air Extension zip file, you will get a sample flex project, two extension files and this README.txt.

3. Choose "File" -> "Publish settings".

4. Click the wrench icon next to Script for ActionScript settings.

5. Select the "Library Path" tab, and click "Browse for Native Extension (ANE) File", and browse to LeadboltANE.ane, then click open. You should now see LeadboltANE.ane listed


If using Flex
---------------
To include the Leadbolt extension in your AIR project you need to 

1. In Flash Builder, set up a new Flex Mobile Project.

2. Download and Unzip the Leadbolt Adobe Air Extension zip file, you will get a sample flex project, two extension files and this README.txt.

3. In your project's properties, select "Flex Build Path" section on the left-hand side column, then click the "Native Extensions" tab on the right-hand side, which allows you to target any ANE files that your application needs.

4. Click Add and browse to the LeadboltANE.ane file and then click OPEN. 

5. Make sure "Update AIR application descriptor" is ticked, then click OK. You should now see LeadboltNAE.ane listed under the Native Extensions tab. Click OK to finish.
    
6. Go to "Properties" -> "Flex Build Packaging", select "Apple iOS" on the left-hand side column, and then click the "Native Extensions" tab. Make sure that the checkbox in the Package column of your native extension is checked. Click Apply. 


If using FlashDevelop
-----------------------
To include the Leadbolt extension in youe FlashDevelop project

1. In FlashDevelop, set up a new project.

2. Copy LeadboltANE.swc file to your project folder.

3. In the explorer panel, right-click the "SWC" and select "Add To Library"

4. Right-click the SWC file in the explorer panel again, select "Options" and then select "External Library"



Using this extension
---------------------
1. Import the API classes 
	import com.leadbolt.aslib.LeadboltController; 
Then call the necessary functions to get started. 
Please refer to the sample code in "HelloLeadbolt/src/views/SampleProjectMainView.mxml". 

* Android developers should add the following manifest permissions in the project's app.xml file.
	<!--THE FOLLOWING PERMISSION ARE NEEDED FOR LEADBOLT ADS -->
		<!-- *** needed for all ads *** -->
	<uses-permission android:name="android.permission.INTERNET"/>
	<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
	<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
		<!-- *** needed for location-based targeting *** -->
	<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
	<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
	<uses-permission android:name="android.permission.ACCESS_LOCATION_EXTRA_COMMANDS"/>
		<!--The ACCESS_NETWORK_STATE and ACCESS_WIFI_STATE permissions should be toggled together in order to use AIR's NetworkInfo APIs-->
	<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
		<!-- *** needed for re-engagement *** -->
	<uses-permission android:name="android.permission.WAKE_LOCK"/>
	<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
	<!--The ACCESS_NETWORK_STATE and ACCESS_WIFI_STATE permissions should be toggled together in order to use AIR's NetworkInfo APIs-->
	<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
	<!-- The DISABLE_KEYGUARD and WAKE_LOCK permissions should be toggled together in order to access AIR's SystemIdleMode APIs-->
	<uses-permission android:name="android.permission.DISABLE_KEYGUARD"/>
	<application android:enabled="true"> 
		<service android:name="com.publishersdk.ReEngagementService"/>
		<receiver android:name="com.publishersdk.ReEngagement"/>
		<receiver android:name="<YOUR_APP_NAME>.BootReceiver">
			<intent-filter>
				<action android:name="android.intent.action.BOOT_COMPLETED"/>
			</intent-filter>
		</receiver>
	</application>
Where <YOUR_APP_NAME> should be replaced by the name of your app.
Please refer to "HelloLeadbolt/src/SampleProject-app.mxml" for reference.


2. Make sure to add the ID of this extension (com.leadbolt.LeadboltANE) into your <project>-app.xml
	eg.
    	<extensions>
        	<extensionID>com.leadbolt.LeadboltANE</extensionID>
    	</extensions> 
Please refer to the end of SampleProject-app.xml in "HelloLeadbolt/src" folder for reference.  

3. Package your application with an extra option at the end: -ext  path/to/the/extension 
	eg. 
adt -package -target ipa-ad-hoc -storetype pkcs12 -keystore ../AppleDistribution.p12 -provisioning-profile AppleDistribution.mobileprofile myApp.ipa myApp-app.xml myApp.swf icons Default.png -extdir path/to/the/extensionsDir



Going Live 
-----------
Once your app is working you can now go-live with real ads.

1. Access the LeadBolt publisher portal and for your app click the go-live button if present.

2. Your app will be submited for approval and once approved will receive live ads when tested on device.
NOTE: Ads will only be available on Android and iOS DEVICES.
