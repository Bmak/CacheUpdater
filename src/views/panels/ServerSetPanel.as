package views.panels 
{
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import help.hint.Hint;
	import help.hint.HintsLibrary;
	import help.StaticHelp;
	import models.AppModel;
	import models.interfaces.IEditInfo;
	import views.items.PortItem;
	import views.items.ServerItem;
	/**
	 * Панель настройки опций указания сервера
	 * @author ProBigi
	 */
	public class ServerSetPanel extends Sprite implements IEditInfo
	{
		private const IP:int = 0;
		private const PORT:int = 1;
		
		private var _container:Sprite;
		private var _model:AppModel;
		
		private var _ipBox:ComboBox;
		private var _portBox:ComboBox;
		private var _info:TextInput;
		private var _saveInfoBtn:Button;
		
		private var _addIPBtn:NewBtnView;
		private var _editIPBtn:EditBtnView;
		private var _deleteIPBtn:DeleteBtnView;
		
		private var _addPortBtn:NewBtnView;
		private var _editPortBtn:EditBtnView;
		private var _deletePortBtn:DeleteBtnView;
		
		private var _ipList:Vector.<ServerItem>;
		private var _portList:Vector.<PortItem>;
		
		private var _ipSelected:int;
		private var _portSelected:int;
		private var _type:int;
		
		public function ServerSetPanel(container:Sprite, model:AppModel) 
		{
			_container = container;
			_model = model;
			this.x = 20;
			this.y = 20;
			_container.addChild(this);
			
			var title:TextField = StaticHelp.addTxt("Настройка сервера", 40, 0);
			this.addChild(title);
			
			initView();
			initIPBtns();
			initPortBtns();
			
			addListners();
		}
		private function addListners():void {
			_saveInfoBtn.addEventListener(MouseEvent.CLICK, onSaveInfo);
			HintsLibrary.instance.addFile(_saveInfoBtn, "Сохранить комментарии о сервере");
			
			_addIPBtn.addEventListener(MouseEvent.CLICK, onAddIP);
			HintsLibrary.instance.addFile(_addIPBtn, "Добавить новый сервер");
			_editIPBtn.addEventListener(MouseEvent.CLICK, onEditIP);
			HintsLibrary.instance.addFile(_editIPBtn, "Редактировать сервер");
			_deleteIPBtn.addEventListener(MouseEvent.DOUBLE_CLICK, onDeleteIP);
			HintsLibrary.instance.addFile(_deleteIPBtn, "Удалить сервер");
			
			_addPortBtn.addEventListener(MouseEvent.CLICK, onAddPort);
			HintsLibrary.instance.addFile(_addPortBtn, "Добавить порт");
			_editPortBtn.addEventListener(MouseEvent.CLICK, onEditPort);
			HintsLibrary.instance.addFile(_editPortBtn, "Редактировать порт");
			_deletePortBtn.addEventListener(MouseEvent.DOUBLE_CLICK, onDeletePort);
			HintsLibrary.instance.addFile(_deletePortBtn, "Удалить порт");
			
			_ipBox.addEventListener(Event.CHANGE, onChangeIP);
		}
		
		public function setInfo(name:String):void {
			if (_type == IP) {
				var ip:ServerItem = _ipList[_ipSelected];
				ip.ip = name;
				_info.text = ip.info;
				_ipBox.selectedIndex = _ipSelected;
				_ipBox.selectedItem.label = name;
			}
			else if (_type == PORT) {
				var port:PortItem = _portList[_portSelected];
				port.port = name;
				_portBox.selectedIndex = _portSelected;
				_portBox.selectedItem.label = name;
			}
		}
		
		public function updateCache():void 
		{
			if (!_ipBox.length || !_portBox.length) {
				Hint.instance.showHint("Укажите сервер и порт");
				return;
			}
			_model.ip = _ipBox.selectedLabel;
			_model.port = _portBox.selectedLabel;
		}
		
		public function save():void 
		{
			_model.ipList.length = 0;
			var len:int = _ipList.length;
			for (var i:int = 0; i < len; ++i) {
				_model.ipList.push(_ipList[i]);
			}
			
			_model.portList.length = 0;
			var lenPort:int = _portList.length;
			for (var j:int = 0; j < lenPort; ++j) {
				_model.portList.push(_portList[j]);
			}
		}
		
		public function allClear():void 
		{
			_ipList.length = 0;
			_ipBox.removeAll();
			
			_portList.length = 0;
			_portBox.removeAll();
		}
		
		public function update():void 
		{
			//TODO update
			var len:int = _model.ipList.length;
			for (var i:int = 0; i < len; ++i) {
				var ip:ServerItem = _model.ipList[i]
				_ipList.push(ip);
				_ipBox.addItem( { label: ip.ip } );
				_info.text = ip.info;
				_ipBox.selectedIndex = _ipSelected = i;
				_ipBox.selectedItem.label = ip.ip;
			}
			
			var lenPort:int = _model.portList.length;
			for (var j:int = 0; j < lenPort; ++j) {
				var port:PortItem = _model.portList[j]
				_portList.push(port);
				_portBox.addItem( { label: port.port } );
				_portBox.selectedIndex = _portSelected = j;
				_portBox.selectedItem.label = port.port;
			}
		}
		
		private function initView():void 
		{
			var ipLabel:Label = StaticHelp.addLabel("IP Сервера:", 10, 50);
			this.addChild(ipLabel);
			_ipBox = new ComboBox();
			_ipBox.setSize(150, 22);
			_ipBox.x = 80;
			_ipBox.y = 50;
			this.addChild(_ipBox);
			
			var portLabel:Label = StaticHelp.addLabel("Port Сервера:", 0, 80);
			this.addChild(portLabel);
			_portBox = new ComboBox();
			_portBox.setSize(150, 22);
			_portBox.x = 80;
			_portBox.y = 80;
			this.addChild(_portBox);
			
			var infoLabel:Label = StaticHelp.addLabel("Информация о сервере:", 0, 110);
			this.addChild(infoLabel);
			_info = StaticHelp.addTextInput("...", 0, 130, 230, 60);
			_info.textField.wordWrap = true;
			_info.textField.multiline = true;
			this.addChild(_info);
			
			_saveInfoBtn = StaticHelp.addButton("save info", 0, 200);
			this.addChild(_saveInfoBtn);
			
			_ipList = new Vector.<ServerItem>;
			_portList = new Vector.<PortItem>;
		}
		
		private function initIPBtns():void 
		{
			_addIPBtn = new NewBtnView();
			_addIPBtn.buttonMode = true;
			_addIPBtn.x = 250;
			_addIPBtn.y = 50;
			this.addChild(_addIPBtn);
			
			_editIPBtn = new EditBtnView();
			_editIPBtn.buttonMode = true;
			_editIPBtn.x = 280;
			_editIPBtn.y = 50;
			this.addChild(_editIPBtn);
			
			_deleteIPBtn = new DeleteBtnView();
			_deleteIPBtn.buttonMode = true;
			_deleteIPBtn.doubleClickEnabled = true;
			_deleteIPBtn.x = 310;
			_deleteIPBtn.y = 50;
			this.addChild(_deleteIPBtn);
		}
	
		private function initPortBtns():void
		{
			_addPortBtn = new NewBtnView();
			_addPortBtn.buttonMode = true;
			_addPortBtn.x = 250;
			_addPortBtn.y = 80;
			this.addChild(_addPortBtn);
			
			_editPortBtn = new EditBtnView();
			_editPortBtn.buttonMode = true;
			_editPortBtn.x = 280;
			_editPortBtn.y = 80;
			this.addChild(_editPortBtn);
			
			_deletePortBtn = new DeleteBtnView();
			_deletePortBtn.buttonMode = true;
			_deletePortBtn.doubleClickEnabled = true;
			_deletePortBtn.x = 310;
			_deletePortBtn.y = 80;
			this.addChild(_deletePortBtn);
		}
		
		private function onSaveInfo(e:MouseEvent):void 
		{
			
			var ip:ServerItem = _ipList[_ipSelected];
			ip.info = _info.text;
		}
		
		private function onAddIP(e:MouseEvent):void 
		{
			var ip:ServerItem = new ServerItem();
			EditInfoPanel.instance.show(this, ip.ip);
			_ipSelected = _ipList.length;
			_ipList.push(ip);
			
			_ipBox.addItem( { label: ip.ip } );
			
			_type = IP;
		}
		
		private function onEditIP(e:MouseEvent):void 
		{
			_type = IP;
			if (_ipBox.length) {
				_ipSelected = _ipBox.selectedIndex;
				EditInfoPanel.instance.show(this,_ipBox.selectedLabel);
			}
		}
		
		private function onDeleteIP(e:MouseEvent):void 
		{
			if (_ipBox.length) { 
				_ipList.splice(_ipSelected, 1);
				_ipBox.removeItemAt(_ipSelected);
				_ipSelected = _ipBox.selectedIndex = 0;
				if (!_ipBox.length) { _ipBox.removeAll(); }
			}
		}
		
		private function onChangeIP(e:Event):void 
		{
			_ipSelected = _ipBox.selectedIndex;
			var ip:ServerItem = _ipList[_ipSelected];
			_info.text = ip.info;
		}
		
		private function onAddPort(e:MouseEvent):void 
		{
			var port:PortItem = new PortItem();
			EditInfoPanel.instance.show(this, port.port);
			_portSelected = _portList.length;
			_portList.push(port);
			
			_portBox.addItem( { label: port.port } );
			
			_type = PORT;
		}
		
		private function onEditPort(e:MouseEvent):void 
		{
			_type = PORT;
			if (_portBox.length) {
				_portSelected = _portBox.selectedIndex;
				EditInfoPanel.instance.show(this, _portBox.selectedLabel);
			}
		}
		
		private function onDeletePort(e:MouseEvent):void 
		{
			if (_portBox.length) { 
				_portList.splice(_portSelected, 1);
				_portBox.removeItemAt(_portSelected);
				_portSelected = _portBox.selectedIndex = 0;
				if (!_portBox.length) { _portBox.removeAll(); }
			}
		}
		
	}

}