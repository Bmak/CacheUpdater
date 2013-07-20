package views.items 
{
	/**
	 * Итемка сервера с информацией
	 * @author ProBigi
	 */
	public class ServerItem
	{
		private var _ip:String = "ip";
		private var _info:String = "ept";
		
		public function ServerItem() 
		{
			
		}
		
		public function get ip():String 
		{
			return _ip;
		}
		
		public function set ip(value:String):void 
		{
			_ip = value;
		}
		
		public function get info():String 
		{
			return _info;
		}
		
		public function set info(value:String):void 
		{
			_info = value;
		}
		
	}

}