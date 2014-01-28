package base 
{
	/**
	 * ...
	 * @author ndp
	 */
	public class CallbackObj 
	{
		public var f:Function;
		public var p:Array;
		public var optionalData:Object;
		
		public function CallbackObj() 
		{
			
		}
		
		public function execute():void
		{
			f.apply(this, p);
		}
		
	}

}