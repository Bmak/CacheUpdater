package events 
{
	import flash.events.Event;
	/**
	 * События утилиты обновления кэша
	 * @author ProBigi
	 */
	public class UtilityEvent extends Event
	{
		/** Событие отправки пакета на обновление кэша */
		public static const UPDATE_CACHE:String = "update_cache";
		
		/** Событие сохранения xml конфигурации */
		public static const SAVE_XML:String = "save_xml";
		
		/** Событие загрузки xml конфигурации */
		public static const LOAD_XML:String = "load_xml";
		
		public function UtilityEvent(type:String) 
		{
			super(type);
		}
		
	}

}