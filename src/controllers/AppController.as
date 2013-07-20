package controllers 
{
	import models.AppModel;
	import views.AppView;
	/**
	 * Основное управление приложением
	 * @author ProBigi
	 */
	public class AppController 
	{
		private var _view:AppView;
		private var _model:AppModel;
		
		public function AppController() 
		{
			_model = new AppModel;
			_view = new AppView(_model);
		}
		public function get view():AppView { return _view; }
	}

}