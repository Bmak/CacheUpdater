package views.panels 
{
	import events.UtilityEvent;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import help.hint.Hint;
	import help.hint.HintsLibrary;
	import help.StaticHelp;
	import models.AppModel;
	import views.items.MessageItem;
	/**
	 * Панель редактирования пакета информации по обновлению кэша на сервере
	 * @author ProBigi
	 */
	public class MessageEditorPanel extends Sprite
	{
		private var _container:Sprite;
		private var _model:AppModel;
		
		private var _packBox:ComboBox;
		private var _namePack:TextInput;
		private var _idPack:TextInput;
		private var _mesTitle:TextInput;
		private var _message:TextInput;
		private var _info:TextInput;
		private var _mesBox:ComboBox;
		private var _mesIndex:int = -1;
		
		private var _packIndex:int = -1;
		private var _items:Vector.<MessageItem>;
		
		private var _newBtn:NewBtnView;
		private var _deleteBtn:DeleteBtnView;
		private var _saveItemInfo:Button;
		private var _updateBtn:Button;
		
		private var _newMesBtn:NewBtnView;
		private var _deleteMesBtn:DeleteBtnView;
		
		public function MessageEditorPanel(container:Sprite, model:AppModel) 
		{
			_container = container;
			_model = model;
			this.x = 20;
			this.y = 250;
			_container.addChild(this);
			
			var title:TextField = StaticHelp.addTxt("Настройка пакета информации", 200, 0);
			this.addChild(title);
			
			initBoxes();
			initPanel();
			initBtns();
			
			addListeners();
		}
		
		public function save():void 
		{
			_model.items.length = 0;
			var len:int = _items.length;
			for (var i:int = 0; i < len; ++i) {
				_model.items.push(_items[i]);
			}
		}
		
		public function allClear():void 
		{
			_packBox.removeAll();
			_mesBox.removeAll();
			_items.length = 0;
		}
		
		public function update():void 
		{
			var len:int = _model.items.length;
			for (var i:int = 0; i < len; ++i) {
				var item:MessageItem = _model.items[i];
				_items.push(item);
				_packBox.addItem( { label: item.title } );
				_packBox.selectedIndex = _packIndex = i;
				_packBox.selectedItem.label = item.title;
			}
			updatePanel();
		}
		
		private function addListeners():void 
		{
			_newBtn.addEventListener(MouseEvent.CLICK, onAddItem);
			HintsLibrary.instance.addFile(_newBtn, "Добавить константу пакета");
			_saveItemInfo.addEventListener(MouseEvent.CLICK, onSaveItem);
			HintsLibrary.instance.addFile(_saveItemInfo, "Сохранить информацию о пакете");
			_deleteBtn.addEventListener(MouseEvent.DOUBLE_CLICK, onDeleteItem);
			HintsLibrary.instance.addFile(_deleteBtn, "Удалить константу пакета");
			_updateBtn.addEventListener(MouseEvent.CLICK, onUpdateCache);
			HintsLibrary.instance.addFile(_updateBtn, "Отправить пакет обновления данных");
			
			_newMesBtn.addEventListener(MouseEvent.CLICK, onAddMes);
			HintsLibrary.instance.addFile(_newMesBtn, "Добавить сообщение");
			_deleteMesBtn.addEventListener(MouseEvent.DOUBLE_CLICK, onDeleteMes);
			HintsLibrary.instance.addFile(_deleteMesBtn, "Удалить сообщение");
			
			_packBox.addEventListener(Event.CHANGE, onChangePack);
			_mesBox.addEventListener(Event.CHANGE, onChangeMes);
		}
		
		private function initBoxes():void 
		{
			var boxLabel:Label = StaticHelp.addLabel("Выберите константу пакета:", 0, 50);
			this.addChild(boxLabel);
			_packBox = new ComboBox;
			_packBox.setSize(300, 22);
			_packBox.x = 0;
			_packBox.y = 70;
			this.addChild(_packBox);
			
			var mesBoxLabel:Label = StaticHelp.addLabel("Список сообщений:", 100, 110);
			this.addChild(mesBoxLabel);
			_mesBox = new ComboBox;
			_mesBox.setSize(200, 22);
			_mesBox.x = 100;
			_mesBox.y = 130;
			this.addChild(_mesBox);
		}
		
		private function initPanel():void 
		{
			var nameLabel:Label = StaticHelp.addLabel("Имя константы:", 350, 30);
			this.addChild(nameLabel);
			_namePack = StaticHelp.addTextInput("name", 350, 50, 250, 20);
			this.addChild(_namePack);
			
			var idLabel:Label = StaticHelp.addLabel("ID константы:", 620, 30);
			this.addChild(idLabel);
			_idPack = StaticHelp.addTextInput("ID", 620, 50, 50, 20);
			_idPack.restrict = "0-9";
			_idPack.maxChars = 3;
			this.addChild(_idPack);
			
			var nameMesLabel:Label = StaticHelp.addLabel("Название сообщения:", 350, 80);
			this.addChild(nameMesLabel);
			_mesTitle = StaticHelp.addTextInput("title", 470, 80, 130);
			this.addChild(_mesTitle);
			
			var mesLabel:Label = StaticHelp.addLabel("Сообщение:", 350, 100);
			this.addChild(mesLabel);
			_message = StaticHelp.addTextInput("message", 350, 120, 400, 70);
			_message.textField.wordWrap = true;
			_message.textField.multiline = true;
			this.addChild(_message);
			
			var infoLabel:Label = StaticHelp.addLabel("Комментарии:", 350, 200);
			this.addChild(infoLabel);
			_info = StaticHelp.addTextInput("info", 350, 220, 300, 40);
			_info.textField.wordWrap = true;
			_info.textField.multiline = true;
			this.addChild(_info);
			
			_items = new Vector.<MessageItem>;
		}
		
		private function initBtns():void 
		{
			_newBtn = new NewBtnView;
			_newBtn.buttonMode = true;
			_newBtn.x = 250;
			_newBtn.y = 45;
			this.addChild(_newBtn);
			
			_deleteBtn = new DeleteBtnView;
			_deleteBtn.buttonMode = true;
			_deleteBtn.doubleClickEnabled = true;
			_deleteBtn.x = 280;
			_deleteBtn.y = 45;
			this.addChild(_deleteBtn);
			
			_saveItemInfo = StaticHelp.addButton("сохранить", 350, 280);
			this.addChild(_saveItemInfo);
			
			_updateBtn = StaticHelp.addButton("обновить", 460, 280);
			this.addChild(_updateBtn);
			
			_newMesBtn = new NewBtnView;
			_newMesBtn.buttonMode = true;
			_newMesBtn.x = 250;
			_newMesBtn.y = 105;
			this.addChild(_newMesBtn);
			
			_deleteMesBtn = new DeleteBtnView;
			_deleteMesBtn.buttonMode = true;
			_deleteMesBtn.doubleClickEnabled = true;
			_deleteMesBtn.x = 280;
			_deleteMesBtn.y = 105;
			this.addChild(_deleteMesBtn);
		}
		
		private function onChangePack(e:Event):void 
		{
			_packIndex = _packBox.selectedIndex;
			updatePanel();
		}
		
		private function onAddItem(e:MouseEvent):void 
		{
			var item:MessageItem = new MessageItem();
			item.title = "name " + _items.length;//_namePack.text;
			item.id = "ID"; //_idPack.text;
			var mes:Object = new Object;
			mes.title = "title " + item.messages.length;
			mes.message = "new message";
			item.messages.push(mes);
			item.info = "info";//_info.text;
			
			_packIndex = _items.length;
			_packBox.addItem( { label: item.title } );
			_packBox.selectedIndex = _packIndex;
			_packBox.selectedItem.label = item.title;
			_items.push(item);
			
			_mesBox.addItem( { label: mes.message } );
			_mesBox.selectedIndex = _mesIndex = 0;
			_mesBox.selectedItem.label = mes.title;
			
			updatePanel();
		}
		
		private function onSaveItem(e:MouseEvent):void 
		{
			var item:MessageItem = _items[_packIndex];
			item.title = _namePack.text;
			item.id = _idPack.text;
			item.messages[_mesIndex].title = _mesTitle.text;
			item.messages[_mesIndex].message = _message.text;
			item.info = _info.text;
			
			_packBox.selectedIndex = _packIndex;
			_packBox.selectedItem.label = item.title;
			
			_mesBox.selectedIndex = _mesIndex;
			_mesBox.selectedItem.label = _mesTitle.text;
		}
		
		private function onDeleteItem(e:MouseEvent):void 
		{
			if (_packBox.length) { 
				_items.splice(_packIndex, 1);
				_packBox.removeItemAt(_packIndex);
				_packIndex = _packBox.selectedIndex = 0;
				if (!_packBox.length) { _packBox.removeAll(); }
			} else { _packBox.removeAll(); }
		}
		
		private function onAddMes(e:MouseEvent):void 
		{
			if (checkItems) { return; }
			
			var item:MessageItem = _items[_packIndex];
			
			var mes:Object = new Object;
			mes.title = "title " + item.messages.length;
			mes.message = "new message";
			item.messages.push(mes);
			
			_mesIndex = item.messages.length - 1;
			
			_mesBox.addItem( { label: mes.message } );
			_mesBox.selectedIndex = _mesIndex;
			_mesBox.selectedItem.label = mes.title;
			
			_mesTitle.text = mes.title;
			_message.text = mes.message;
		}
		
		private function get checkItems():Boolean 
		{
			if (!_items.length) {
				Hint.instance.showHint("Сперва создайте пакет");
				return true;
			}
			return false;
		}
		
		private function onDeleteMes(e:MouseEvent):void 
		{
			if (checkItems) { return; }
			
			if (_mesBox.length >= 2) { 
				var item:MessageItem = _items[_packIndex];
				item.messages.splice(_mesIndex, 1);
				_mesBox.removeItemAt(_mesIndex);
				_mesIndex = _mesBox.selectedIndex = 0;
			}
			updatePanel();
		}
		
		private function onChangeMes(e:Event):void 
		{
			_mesIndex = _mesBox.selectedIndex;
			var item:MessageItem = _items[_packIndex];
			_mesTitle.text = item.messages[_mesIndex].title;
			_message.text = item.messages[_mesIndex].message;
		}
		
		private function updatePanel():void 
		{
			var item:MessageItem = _items[_packIndex];
			_namePack.text = item.title;
			_idPack.text = item.id;
			_mesTitle.text = item.messages[0].title;
			_message.text = item.messages[0].message;
			_info.text = item.info;
			
			_mesBox.removeAll();
			for each (var mes:Object in item.messages) {
				_mesBox.addItem( { label: mes.title } );
			}
			_mesBox.selectedIndex = _mesIndex = 0;
		}
		
		private function onUpdateCache(e:MouseEvent):void
		{
			if (_packIndex == -1) { Hint.instance.showHint("Задайте константу сообщения"); return; }
			
			var item:MessageItem = _items[_packIndex];
			_model.id = item.id;
			_model.message = item.messages[_mesIndex].message;
			
			
			super.dispatchEvent(new UtilityEvent(UtilityEvent.UPDATE_CACHE));
		}
		
	}
}