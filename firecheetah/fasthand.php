<?php

	// Include and instantiate the class.
	require_once 'lib/Mobile_Detect.php';
	$detect = new Mobile_Detect;
	 
	// Any mobile device (phones or tablets).
	if ( $detect->isMobile() || $detect->isTablet()) {
		if( $detect->isiOS() ){
			header('Location: http://appstore.com/fast-hand-english');
		}
		else
		{
			header('Location: market://details?id=com.fc.FastHandEnglish');
		}
	}
	else
	{
		header( 'Location: http://firecheetah.com/' ) ;
	}
?>