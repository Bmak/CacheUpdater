package xml
{
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import help.xml.ProgressXML;
	import models.AppConfig;
	import models.AppModel;
	import ugo.net.ftp.events.FTPErrorEvent;
	import ugo.net.ftp.events.FTPEvent;
	import ugo.net.ftp.FTPClient;
	import views.items.MessageItem;
	import views.items.PortItem;
	import views.items.ServerItem;
	
	/**
	 * Сохранение конфигуратора приложения
	 * @author ProBigi
	 */
	public class SaveXML
	{
		private var _configXML:XML;
		private var _model:AppModel;
		
		private var _ftpClient:FTPClient = new FTPClient;
		
		public function SaveXML(model:AppModel)
		{
			_model = model;
			//onSaveChanges();
			ProgressXML.instance.show(ProgressXML.SAVE);
			
			onSaveXML();
		}
		
		/**
		 * Сохраняет конфигурацию приложения в xml, и загружает файл на сервер.
		 */
		private function onSaveChanges():void
		{
			if (!_ftpClient.connected)
			{
				_ftpClient.addEventListener(FTPEvent.CONNECTED, uploadOnConnected);
				_ftpClient.connect(AppConfig.FTP_HOST, 21, AppConfig.FTP_USER, AppConfig.FTP_PASS);
			}
			else
			{
				uploadOnConnected();
			}
		}
		
		private function uploadOnConnected(event:FTPEvent = null):void
		{
			trace("FTP has CONNECTED");
			
			onSaveXML();
			
			//var task:FTPUploadTask;
			//var file:File;
			var contents:ByteArray;
			
			contents = new ByteArray;
			contents.writeUTFBytes(_configXML.toXMLString());
			
			_ftpClient.addEventListener(FTPEvent.UPLOADED, onXMLUploaded);
			_ftpClient.addEventListener(FTPErrorEvent.UPLOAD_ERROR, onXMLUploadError);
			_ftpClient.put(AppConfig.XML_UPLOAD_PATH, contents);
		}
		
		/**
		 * Загрузка файла конфигурации завершена
		 */
		private function onXMLUploaded(event:FTPEvent):void
		{
			trace("XML UPLOADED");
			
			_ftpClient.removeEventListener(FTPEvent.UPLOADED, onXMLUploaded);
			_ftpClient.removeEventListener(FTPErrorEvent.UPLOAD_ERROR, onXMLUploadError);
		
		}
		
		private function onXMLUploadError(event:FTPErrorEvent):void
		{
			trace("Ошибка загрузки XML(connected=" + _ftpClient.connected + ")");
			
			_ftpClient.removeEventListener(FTPEvent.UPLOADED, onXMLUploaded);
			_ftpClient.removeEventListener(FTPErrorEvent.UPLOAD_ERROR, onXMLUploadError);
			
			trace("Code: " + event.response.code + ", response: " + event.response.text);
			
			//throw new Error( "XML Upload Error: " + "Code: " + event.code + ", response: " + event.response );
			
			return this.cleanAfterUpload();
		}
		
		private function onConnectionError(event:FTPErrorEvent):void
		{
			connectFTP();
		}
		
		private function onConnectionClosed(event:FTPErrorEvent):void
		{
			connectFTP();
		}
		
		private function connectFTP():void
		{
			if (!_ftpClient.connected)
			{
				_ftpClient.connect(AppConfig.FTP_HOST, 21, AppConfig.FTP_USER, AppConfig.FTP_PASS);
			}
			
			_ftpClient.addEventListener(FTPErrorEvent.CONNECTION_ERROR, onConnectionError);
			_ftpClient.addEventListener(FTPErrorEvent.CONNECTION_CLOSED, onConnectionClosed);
		}
		
		private function cleanAfterUpload():void
		{
			_ftpClient.removeEventListener(FTPEvent.UPLOADED, onXMLUploaded);
			_ftpClient.removeEventListener(FTPErrorEvent.UPLOAD_ERROR, onXMLUploadError);
		}
		
		private function onSaveXML():void
		{
			_configXML = new XML( 
				<configuration>
				
				</configuration>
				);
			
			var servers:XML =  <servers/>;
			for each (var server:ServerItem in _model.ipList)
			{
				var servxml:XML =  <server/>;
				servxml.ip = server.ip;
				servxml.info = server.info;
				servers.appendChild(servxml);
			}
			_configXML.appendChild(servers);
			
			var portsArr:Array = [];
			for each (var port:PortItem in _model.portList)
			{
				portsArr.push(port.port);
			}
			_configXML.ports = portsArr.toString();
			
			var packets:XML =  <packets/>;
			for each (var packetItem:MessageItem in _model.items)
			{
				var packet:XML =  <packet/>;
				packet.title = packetItem.title;
				packet.id = packetItem.id;
				
				var messages:XML = <messages/>;
				for each (var mesItem:Object in packetItem.messages) {
					var message:XML = <message/>;
					message.title = mesItem.title;
					message.text = mesItem.message;
					
					messages.appendChild(message);
				}
				packet.appendChild(messages);
				
				
				packet.info = packetItem.info;
				
				packets.appendChild(packet);
			}
			_configXML.appendChild(packets);
			
			
			var fileRef:FileReference = new FileReference();
			fileRef.save(_configXML, "updater.xml");
			fileRef.addEventListener(Event.CANCEL, onCancel);
			fileRef.addEventListener(Event.COMPLETE, onComplete);
			
			//trace(_configXML.toXMLString());
		}
		
		private function onCancel(e:Event):void 
		{
			ProgressXML.instance.hide();
		}
		
		private function onComplete(e:Event):void 
		{
			ProgressXML.instance.hide();
		}
	
	}

}