package models 
{
	/**
	 * Основные данные приложения
	 * @author ProBigi
	 */
	public class AppConfig 
	{
		public static function get TIME():String
		{
			var date:Date = new Date();
			return(String(date.time));
		}
		
		public static const FTP_HOST:String = "78.46.88.51";
		public static const FTP_USER:String = "u066910_ugoru_kingdom";
		public static const FTP_PASS:String = "7$EbTMxAgaEeCRBzk8k6XJUufQW1ksJZf7weo6U00d";
		
		/** Путь к серверу */
		//public static const PATH_SAVE:String = "http://78.46.88.51";
		public static const PATH:String = "http://kingdom.ugo.ru";
		
		/** Путь к серверу */
		public static const XML_LOAD_PATH:String = "/data/updater/updater.xml?" + TIME;
		
		/** Путь к серверу */
		public static const XML_UPLOAD_PATH:String = "/data/updater/updater.xml";
		
		
		public function AppConfig() 
		{
			
		}
		
	}

}