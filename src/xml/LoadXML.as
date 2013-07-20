package xml 
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import help.xml.ProgressXML;
	import models.AppConfig;
	import models.AppModel;
	import views.items.MessageItem;
	import views.items.PortItem;
	import views.items.ServerItem;
	/**
	 * Загрузка конфигуратора приложения
	 * @author ProBigi
	 */
	public class LoadXML extends EventDispatcher
	{
		private var _configXML:XML;
		private var _model:AppModel;
		
		private var _fileRef:FileReference = new FileReference();
		
		public function LoadXML(model:AppModel)
		{
			_model = model;
			//onLoadXML();
			
			ProgressXML.instance.show(ProgressXML.LOAD);
			
			onSelectFile();
		}
		
		/**--------------------ЛОКАЛЬНАЯ ЗАГРУЗКА---------------------*/
		
		private function onSelectFile():void 
		{
			_fileRef = new FileReference();
			_fileRef.addEventListener(Event.SELECT, onFileSelected);
			_fileRef.addEventListener(Event.CANCEL, onFileCancel);
			_fileRef.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			var filter:FileFilter = new FileFilter("XML Files (*.xml)", "*.xml");
			_fileRef.browse([filter]);
		}
		/*Отмена выбора объекта*/
		private function onFileCancel(e:Event):void 
		{
			ProgressXML.instance.hide();
		}
		/*Выбираем объект*/
		private function onFileSelected(event:Event):void
		{
			_fileRef.addEventListener(Event.COMPLETE, onComplete);
			_fileRef.load();
		}
		/*Загрузка объекта завершена*/
		private function onComplete(event:Event):void
		{
			_fileRef.removeEventListener(Event.SELECT, onFileSelected);
			_fileRef.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_fileRef.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_fileRef.removeEventListener(Event.COMPLETE, onComplete);
			
			_configXML = new XML(_fileRef.data);
			
			parseXML();
		}
		/*Проверка на ошибки*/
		private function onIOError(event:IOErrorEvent):void
		{
			throw new Error("[LoadElements] Ошибка ВВОДА-ВЫВОДА: IO Error");
		}
		private function onSecurityError(event:Event):void
		{
			throw new Error("Ошибка БЕЗОПАСНОСТИ: Security Error");
		}
		
		
		/**--------------------ЗАГРУЗКА С СЕРВЕРА---------------------*/
		/*
		
		//Загружаем конфигурацию элементов
		private function onLoadXML():void {
			trace("[ON START LOAD]");
			var XML_URL:String = AppConfig.PATH + AppConfig.XML_LOAD_PATH; 
			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			var myLoader:URLLoader = new URLLoader(myXMLURL);
			
			myLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		//Проверка на ошибки
		private function onIOError(event:IOErrorEvent):void {
			trace("URL " + AppConfig.PATH + AppConfig.XML_LOAD_PATH);
			
			throw new IOError("[LoadConfig] Ошибка ввода/вывода");
		}
		//Загрузка завершена
		private function xmlLoaded(event:Event):void { 
			var myLoader:URLLoader = event.currentTarget as URLLoader;
			myLoader.removeEventListener(Event.COMPLETE, xmlLoaded);
			
			_configXML = new XML(myLoader.data);
			
			parseXML();
		}
		
		*/
		private function parseXML():void {
			loadIPList();
			
			loadPortList();
			
			loadPackets();
			
			ProgressXML.instance.hide();
			super.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function loadIPList():void 
		{
			var ipList:XMLList = _configXML.servers.server;
			
			for each (var server:XML in ipList) {
				var ip:ServerItem = new ServerItem;
				ip.ip = server.ip;
				ip.info = server.info;
				_model.ipList.push(ip);
			}
		}
		
		private function loadPortList():void 
		{
			var strPorts:String = _configXML.ports;
			var arrPorts:Array = strPorts.split(",");
			var len:int = arrPorts.length;
			for (var i:int = 0; i < len; ++i) {
				var port:PortItem = new PortItem;
				port.port = arrPorts[i];
				_model.portList.push(port);
			}
		}
		
		private function loadPackets():void 
		{
			var packList:XMLList = _configXML.packets.packet;
			for each (var packxml:XML in packList) {
				var packet:MessageItem = new MessageItem();
				
				packet.title = packxml.title;
				packet.id = packxml.id;
				
				var messageList:XMLList = packxml.messages.message;
				for each (var messagexml:XML in messageList) {
					var mesItem:Object = new Object;
					mesItem.title = messagexml.title;
					mesItem.message = messagexml.text;
					
					packet.messages.push(mesItem);
				}
				packet.info = packxml.info;
				
				_model.items.push(packet);
			}
		}
		
	}
}