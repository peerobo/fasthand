<?php

	// Include and instantiate the class.
	require_once 'lib/Mobile_Detect.php';
	$detect = new Mobile_Detect;	
	 
	// Any mobile device (phones or tablets).
	if ( $detect->isMobile() || $detect->isTablet()) {
		if( $detect->isiOS() ){
			header('Location: itms-apps://itunes.apple.com/app/fast-hand-english/id820835123?ls=1&mt=8');
		}
		else if( $detect->is('Kindle'))
		{		
			header('Location: http://www.amazon.com/gp/mas/dl/android?p=com.fc.FastHandEnglish');
		}
		else
		{
			header('Location: market://details?id=com.fc.FastHandEnglish');
		}
	}
	else
	{
		header( 'Location: http://firecheetah.com/welcome/#fasthandenglish' ) ;
	}
?>