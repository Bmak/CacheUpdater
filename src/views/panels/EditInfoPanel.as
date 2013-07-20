package views.panels 
{
	import fl.controls.Label;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import help.StaticHelp;
	import models.interfaces.IEditInfo;
	/**
	 * Панель редактирования информации элемента
	 * @author ProBigi
	 */
	public class EditInfoPanel extends Sprite
	{
		private static var _instance:EditInfoPanel;
		
		private const WIDTH:int = 200;
		private const HEIGHT:int = 70;
		
		private var _container:Sprite;
		private var _border:Sprite;
		private var _textName:TextInput;
		private var _textInfo:TextInput;
		private var _closeBtn:CloseButtonView;
		
		private var _item:IEditInfo;
		
		public function EditInfoPanel() { }
		
		public static function get instance():EditInfoPanel
		{
			if (!_instance)
			{
				_instance = new EditInfoPanel();
			}
			return _instance;
		}
		
		public function init(container:Sprite):void
		{
			_container = container;
			
			_border = new Sprite;
			_border.graphics.lineStyle(1.5, 0xC0C0C0);
			_border.graphics.beginFill(0xFFFFFF);
			_border.graphics.drawRoundRect(0, 0, WIDTH, HEIGHT, 10, 10);
			_border.graphics.endFill();
			this.addChild(_border);
			
			var nameLabel:Label = StaticHelp.addLabel("Set Info:", 10, 10);
			_border.addChild(nameLabel);
			_textName = StaticHelp.addTextInput("write name", 10, 30, 180, 20);
			_border.addChild(_textName);
			
			//var infoLabel:Label = StaticHelp.addLabel("Описание:", 10, 60);
			//_border.addChild(infoLabel);
			//_textInfo = StaticHelp.addTextInput("write info", 10, 80, 180, 40);
			//_textInfo.textField.wordWrap = true;
			//_border.addChild(_textInfo);
			
			_closeBtn = new CloseButtonView;
			_closeBtn.buttonMode = true;
			_closeBtn.scaleX = _closeBtn.scaleY = .3;
			_closeBtn.x = _border.width - _closeBtn.width - 5;
			_closeBtn.y = 3;
			_border.addChild(_closeBtn);
			
			addListeners();
		}
		
		private function addListeners():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK, onSetName);
			_textName.addEventListener(KeyboardEvent.KEY_DOWN, onEnterText);
			//_textInfo.addEventListener(KeyboardEvent.KEY_DOWN, onEnterText);
		}
		
		public function show(item:IEditInfo, itemName:String):void
		{
			_item = item;
			_textName.text = itemName;
			
			this.x = _container.mouseX - 20;
			this.y = _container.mouseY + 20;
			_container.addChild(this);
		}
		
		private function onEnterText(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				onSetName();
			}
		}
		
		private function onSetName(e:MouseEvent = null):void
		{
			_item.setInfo(_textName.text/*, _textInfo.text*/);
			_container.removeChild(this);
		}
	}
}