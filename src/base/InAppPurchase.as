package base 
{	
	/*import com.vitapoly.nativeextensions.iap.events.InitializationEvent;
	import com.vitapoly.nativeextensions.iap.IAP;*/
	import fasthand.gui.ConfirmDlg;
	import flash.events.Event;
	/**
	 * ...
	 * @author ndp
	 */
	public class InAppPurchase 
	{
		
		public function InAppPurchase() 
		{
			
		}
		
		public static function get canPurchase():Boolean
		{
			return/* IAP.instance.canMakePayments*/true;
		}
		
		static public function initInAppPurchase():void 
		{
			//IAP.instance.addEventListener(IAP.INITIALIZATION_DONE_EVENT, onInitDone);
			//IAP.instance.addEventListener(IAP.INITIALIZATION_FAILED_EVENT, onInitFalse);
			//IAP.instance.init([Constants.IN_APP_PURCHASE_ID]);
		}
		
		static private function onInitFalse(e:Event):void 
		{
			var confirmDlg:ConfirmDlg = Factory.getInstance(ConfirmDlg);
			confirmDlg.text = "init false";
			confirmDlg.callback = function(bool:Boolean):void { };
			PopupMgr.addPopUp(confirmDlg);
		}
		
		static private function onInitDone(e:Event):void 
		{
			var confirmDlg:ConfirmDlg = Factory.getInstance(ConfirmDlg);
			confirmDlg.text = "init ok";
			confirmDlg.callback = function(bool:Boolean):void { };
			PopupMgr.addPopUp(confirmDlg);
		}		
	}

}