package views 
{
	import controllers.SocketUpdater;
	import events.UtilityEvent;
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import help.hint.Hint;
	import help.hint.HintsLibrary;
	import help.StaticHelp;
	import models.AppModel;
	import views.panels.MessageEditorPanel;
	import views.panels.ServerSetPanel;
	import xml.LoadXML;
	import xml.SaveXML;
	/**
	 * Основное представление приложения
	 * @author ProBigi
	 */
	public class AppView extends Sprite
	{
		private var _container:Sprite;
		private var _model:AppModel;
		
		private var _serverPanel:ServerSetPanel;
		private var _messageEditorPanel:MessageEditorPanel;
		
		private var _xmlSaveBtn:Button;
		private var _xmlLoadBtn:Button;
		
		public function AppView(model:AppModel) 
		{
			_model = model;
			init();
			
			addListeners();
		}
		
		private function init():void 
		{
			initPanels();
			initBtns();
			
		}
		
		private function addListeners():void 
		{
			_xmlSaveBtn.addEventListener(MouseEvent.CLICK, onSaveXML);
			HintsLibrary.instance.addFile(_xmlSaveBtn, "Сохранить конфигурацию утилиты. Будьте внимательны предыдущие конфигурационные данные будут перезаписаны");
			_xmlLoadBtn.addEventListener(MouseEvent.CLICK, onLoadXML);
			HintsLibrary.instance.addFile(_xmlLoadBtn, "Загрузить конфигурацию утилиты");
			_messageEditorPanel.addEventListener(UtilityEvent.UPDATE_CACHE, onUpdateCache);
		}
		
		private function initPanels():void 
		{
			_serverPanel = new ServerSetPanel(this, _model);
			_messageEditorPanel = new MessageEditorPanel(this, _model);
		}
		
		private function initBtns():void 
		{
			_xmlSaveBtn = StaticHelp.addButton("save xml", Main.WIDTH - 110, 10);
			this.addChild(_xmlSaveBtn);
			
			_xmlLoadBtn = StaticHelp.addButton("load xml", Main.WIDTH - 110, 40);
			this.addChild(_xmlLoadBtn);
		}
		
		private function onSaveXML(e:MouseEvent):void 
		{
			if (Main.TEST) {
				Hint.instance.showHint("В тестовом режиме эта опция недоступна");
				return;
			}
			
			
			_serverPanel.save();
			_messageEditorPanel.save();
			var save:SaveXML = new SaveXML(_model);
		}
		
		private function onLoadXML(e:MouseEvent):void 
		{
			_serverPanel.allClear();
			_messageEditorPanel.allClear();
			_model.allClear();
			
			var load:LoadXML = new LoadXML(_model);
			load.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			var load:LoadXML = e.currentTarget as LoadXML;
			load.removeEventListener(Event.COMPLETE, onLoadComplete);
			
			_serverPanel.update();
			_messageEditorPanel.update();
		}
		
		private function onUpdateCache(e:UtilityEvent):void 
		{
			if (Main.TEST) {
				Hint.instance.showHint("В тестовом режиме эта опция недоступна");
				return;
			}
			
			_serverPanel.updateCache();
			
			var ip:String = _model.ip;
			var port:uint = uint(_model.port);
			var type:int = int(_model.id);
			var message:String = _model.message;
			
			var socketUpdater:SocketUpdater = new SocketUpdater(ip, port);
			socketUpdater.update(type, message);
		}
		
	}

}