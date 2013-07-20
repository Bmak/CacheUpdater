package controllers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	/**
	 * Класс для подключения к серверу и обновления кэша
	 * @author trein
	 */
	public class SocketUpdater extends EventDispatcher
	{
		private static const UPDATER:int = 5;
		//
		private var _ip:String = "127.0.0.1";
		private var _port:uint = 8430;
		private var _socket:Socket = null;
		//
		private var _message:String = null;
		private var _type:int = 0;
		//
		private var _buffer:ByteArray = null;
		//
		public function SocketUpdater(ip:String, port:uint)
		{
			if (!ip || ip.length == 0)
			{
				throw new ArgumentError("Некорректный адрес!!! IP = " + ip + " / PORT = " + port);
			}
			_ip = ip;
			_port = port;
			
			_socket = new Socket();
		}
		
		/**
		 * Обновляем кэш
		 * @param	type - тип обновления
		 * @param	message - кодовая последовательность
		 */
		public function update(type:int, message:String):void
		{
			if (!message || message.length == 0)
			{
				throw new ArgumentError("Некорректное сообщение!!! Message = " + message + " / type = " + type);
			}
			_message = message;
			_type = type;
			
			_socket.connect(_ip, _port);
			trace("CONNECT: " + "IP: " + _ip + " Port: " + _port);
			trace("Отправка пакета: " + "TYPE: " + _type + " MESSAGE: " + _message);
			
			_socket.addEventListener(Event.CONNECT, connectListener);
			_socket.addEventListener(Event.CLOSE, closeListener);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
		}
		
		private function securityErrorListener(event:SecurityErrorEvent):void
		{
			clearData();
			dispatchEvent(event);
			trace("SECURITY ERROR");
		}
		
		private function ioErrorListener(event:IOErrorEvent):void
		{
			clearData();
			dispatchEvent(event);
			trace("IO ERROR");
		}
		
		private function closeListener(event:Event):void
		{
			clearData();
			dispatchEvent(event);
			trace("CLOSE");
		}
		
		private function connectListener(event:Event):void
		{
			dispatchEvent(event);
			_buffer = new ByteArray();
			
			_buffer.length = 0;
			_buffer.position = 0;
			
			var buffer:ByteArray = new ByteArray();
			buffer.writeByte(UPDATER);
			buffer.writeByte(_type);
			buffer.writeUTFBytes(_message);
			buffer.position = 0;
			
			_buffer.writeShort(buffer.length);
			_buffer.writeBytes(buffer, 0, buffer.length);
			_buffer.position = 0;
			
			_socket.writeBytes(_buffer, 0, _buffer.bytesAvailable);
			_socket.flush();
			
			if (_socket.connected)
			{
				_socket.close();
			}
			trace("Пакет отправлен");
		}
		/**
		 * Очищаем данный модуль
		 */
		public function clearData():void
		{
			_socket.removeEventListener(Event.CONNECT, connectListener);
			_socket.removeEventListener(Event.CLOSE, closeListener);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
			if (_socket.connected) { _socket.close(); }
		}
	}
}