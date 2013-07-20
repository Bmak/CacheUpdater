package
{
	import controllers.AppController;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.ui.Keyboard;
	import help.hint.Hint;
	import help.xml.ProgressXML;
	import views.panels.EditInfoPanel;
	
	/**
	 * Утилита "Updater Серверного кэша"
	 * @author ProBigi
	 */
	public class Main extends Sprite
	{
		public static const WIDTH:int = 800;
		public static const HEIGHT:int = 600;
		
		public static var TEST:Boolean = true;
		
		private var _appController:AppController;
		
		public function Main():void
		{
			Security.allowDomain("*");
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, Main.WIDTH, Main.HEIGHT);
			this.graphics.endFill();
			
			_appController = new AppController();
			
			super.addChild(_appController.view);
			
			initComponents();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onCheckTest);
		}
		
		private function onCheckTest(e:KeyboardEvent):void
		{
			if (e.ctrlKey && e.keyCode == Keyboard.B)
			{
				setTest(!TEST);
			}
		}
		
		private function setTest(value:Boolean):void
		{
			TEST = value;
			if (value)
			{
				Hint.instance.showHint("Тестовый режим активирован");
			}
			else
			{
				Hint.instance.showHint("Тестовый режим отключен");
			}
		}
		
		private function initComponents():void
		{
			Hint.instance.init(this);
			ProgressXML.instance.init(this);
			EditInfoPanel.instance.init(this);
		}
		
		private function onStageClick(e:MouseEvent):void
		{
			Hint.instance.closeHint();
		}
	
	}
}