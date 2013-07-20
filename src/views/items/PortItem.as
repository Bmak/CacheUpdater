package views.items 
{
	/**
	 * Итемка порта
	 * @author ProBigi
	 */
	public class PortItem 
	{
		private var _port:String = "port";
		
		public function PortItem() 
		{
			
		}
		
		public function get port():String 
		{
			return _port;
		}
		
		public function set port(value:String):void 
		{
			_port = value;
		}
		
	}

}