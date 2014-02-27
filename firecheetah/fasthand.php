<?php

	// Include and instantiate the class.
	require_once 'lib/Mobile_Detect.php';
	$detect = new Mobile_Detect;
	 
	// Any mobile device (phones or tablets).
	if ( $detect->isMobile() || $detect->isTablet()) {
		if( $detect->isiOS() ){
			header('Location: itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=820843454');
		}
		else
		{
			header('Location: market://details?id=com.chillingo.deadahead.rowgplay');
		}
	}
	else
	{
		header( 'Location: http://firecheetah.com/' ) ;
	}
?>