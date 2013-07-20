package views.items
{
	
	/**
	 * Итемка константы сообщения
	 * @author ProBigi
	 */
	public class MessageItem
	{
		private var _title:String = "title";
		private var _messages:Vector.<Object> = new Vector.<Object>;
		private var _info:String = "info";
		private var _id:String = "0";
		
		public function MessageItem()
		{
		
		}
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = value;
		}
		
		public function get messages():Vector.<Object> 
		{
			return _messages;
		}
		
		public function get info():String
		{
			return _info;
		}
		
		public function set info(value:String):void
		{
			_info = value;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function set id(value:String):void 
		{
			_id = value;
		}
		
	}

}