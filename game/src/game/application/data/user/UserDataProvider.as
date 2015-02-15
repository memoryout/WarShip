package game.application.data.user
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import game.services.interfaces.ISQLManager;
	
	[Event(name="init", type="flash.events.Event")]
	public class UserDataProvider extends EventDispatcher
	{
		private var _sqlManager:			ISQLManager;
		
		private var _users:					Vector.<UserData>;
		
		private var _currentUser:			UserData;
		
		
		public function UserDataProvider()
		{
			super();
		}
		
		
		public function setSQLConnection(sqlManager:ISQLManager):void
		{
			_sqlManager = sqlManager;
			
			retrieveUserInfo();
		}
		
		
		public function retrieveUserInfo():UserInfoRequest
		{
			var userDataRequest:UserInfoRequest = new UserInfoRequest( _sqlManager );
			userDataRequest.addEventListener(Event.COMPLETE, handlerUserDataRetrieve);
			userDataRequest.start();
			return userDataRequest;
		}
		
		public function getUserInfo():UserData
		{
			return _currentUser;
		}
		
		public function getUserLists():Vector.<UserData>
		{
			if(!_users) _users =  new Vector.<UserData>();
			return _users;
		}
		
		
		public function createNewUser():UserData
		{
			_currentUser = new UserData();
			
			return _currentUser;
		}
		
		public function commitNewUser():CreateUserRequest
		{
			var newUserRequest:CreateUserRequest = new CreateUserRequest( _sqlManager );
			newUserRequest.setUserData( _currentUser );
			newUserRequest.start();
			
			return newUserRequest;
		}
		
		private function handlerUserCreated():void
		{
			
		}
		
		
		private function handlerUserDataRetrieve(e:Event):void
		{
			var userDataRequest:UserInfoRequest = e.currentTarget as UserInfoRequest;
			userDataRequest.removeEventListener(Event.COMPLETE, handlerUserDataRetrieve);
			
			_users = userDataRequest.getUserLists();
			
			if(_users != null && _users.length > 0) {
				_currentUser = _users[0];
			}
			
			this.dispatchEvent( new Event(Event.INIT) );
		}
	}
}