package game.application.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import game.AppGlobalVariables;
	import game.application.data.user.UserDataProvider;
	import game.services.ServicesList;
	import game.services.interfaces.ISQLManager;

	public class DataProvider extends EventDispatcher
	{
		private static var _this:		DataProvider;
		
		
		private var _userDataProvider:	UserDataProvider;
		
		
		private var _sqlManager:		ISQLManager;
		
		
		public function DataProvider()
		{
			
		}
		
		public static function getInstance():DataProvider
		{
			if(_this == null) _this = new DataProvider();
			return _this;
		}
		
		
		public function init():void
		{
			_userDataProvider = new UserDataProvider();
			
			
			_sqlManager = ServicesList.getSearvice(ServicesList.SQL_MANAGER) as ISQLManager;
			_sqlManager.connect(AppGlobalVariables.SQL_FILE_URL, onSQLConnected, onSQLErrorConnected);
		}
		
		private function onSQLConnected():void
		{
			_userDataProvider.setSQLConnection( _sqlManager );
			
			this.dispatchEvent( new Event(Event.INIT) );
		}
		
		private function onSQLErrorConnected():void
		{
			//this.dispatchEvent(Err
		}
		
		
		public function getUserDataProvider():UserDataProvider
		{
			return _userDataProvider;
		}
	}
}