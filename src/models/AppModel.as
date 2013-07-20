package models 
{
	import views.items.MessageItem;
	import views.items.PortItem;
	import views.items.ServerItem;
	/**
	 * Модель данных приложения
	 * @author ProBigi
	 */
	public class AppModel 
	{
		/** IP сервера */
		private var _ip:String;
		
		/** Port сервера */
		private var _port:String;
		
		/** Константа сообщения */
		private var _id:String;
		
		/** Содержание сообщения */
		private var _message:String;
		
		private var _ipList:Vector.<ServerItem> = new Vector.<ServerItem>;
		private var _portList:Vector.<PortItem> = new Vector.<PortItem>;
		private var _items:Vector.<MessageItem> = new Vector.<MessageItem>;
		
		public function AppModel() 
		{
			
		}
		
		public function allClear():void 
		{
			_ip = "";
			_port = "";
			_id = "";
			_message = "";
			_ipList.length = 0;
			_portList.length = 0;
			_items.length = 0;
		}
		
		/**
		 * @private
		 */
		public function get ip():String { return _ip; }
		public function set ip(value:String):void { _ip = value; }
		
		/**
		 * @private
		 */
		public function get port():String { return _port; }
		public function set port(value:String):void { _port = value; }
		
		/**
		 * @private
		 */
		public function get id():String { return _id; }
		public function set id(value:String):void { _id = value; }
		
		/**
		 * @private
		 */
		public function get message():String { return _message; }
		public function set message(value:String):void { _message = value; }
		
		
		public function get ipList():Vector.<ServerItem> { return _ipList; }
		
		public function get portList():Vector.<PortItem> { return _portList; }
		
		public function get items():Vector.<MessageItem> { return _items; }
	}
}