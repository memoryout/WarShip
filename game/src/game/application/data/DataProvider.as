package game.application.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import game.AppGlobalVariables;
	import game.application.data.db.GetDebugAuthorizationInfo;
	import game.application.data.db.InsertDebugAuthorizationInfo;
	import game.application.data.game.GameDataProvider;
	import game.application.data.user.UserDataProvider;
	import game.services.ServicesList;
	import game.services.interfaces.ISQLManager;

	public class DataProvider extends EventDispatcher
	{
		private static var _this:		DataProvider;
		
		
		private var _userDataProvider:	UserDataProvider;
		private var _gameDataProvider:	GameDataProvider;
		
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
			_sqlManager = ServicesList.getSearvice(ServicesList.SQL_MANAGER) as ISQLManager;
			_sqlManager.connect(AppGlobalVariables.SQL_FILE_URL, onSQLConnected, onSQLErrorConnected);
		}
		
		private function onSQLConnected():void
		{
			_gameDataProvider = new GameDataProvider();
			
			_userDataProvider = new UserDataProvider();
			_userDataProvider.addEventListener(Event.INIT, handleUserDataProviderInited);
			_userDataProvider.setSQLConnection( _sqlManager );
		}
		
		private function handleUserDataProviderInited(e:Event):void
		{
			_userDataProvider.removeEventListener(Event.INIT, handleUserDataProviderInited);
			
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
		
		public function getGameDataProvider():GameDataProvider
		{
			return _gameDataProvider;
		}
		
		
		public function getDebugAuthorizationInfo(userId:int):GetDebugAuthorizationInfo
		{
			var request:GetDebugAuthorizationInfo = new GetDebugAuthorizationInfo( _sqlManager );
			request.setUserId( userId );
			request.start();
			
			return request;
		}
		
		public function commitDebugAuthorizationInfo(userId:uint, login:String, pass:String):InsertDebugAuthorizationInfo
		{
			var request:InsertDebugAuthorizationInfo = new InsertDebugAuthorizationInfo( _sqlManager );
			
			request.setData( userId, login, pass );
			request.start();
			
			return request;
		}
	}
}