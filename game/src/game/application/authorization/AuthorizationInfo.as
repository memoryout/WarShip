package game.application.authorization
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import game.application.connection.data.AuthorizationData;
	
	[Event(name="authFailed", type="game.application.authorization.AuthorizationEvent")]
	public class AuthorizationInfo extends EventDispatcher
	{
		private var _authData:			AuthorizationData;
		
		public function AuthorizationInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function setServerAuthorizationData(auth:AuthorizationData):void
		{
			_authData = auth;
		}
		
		public function getServerData():AuthorizationData
		{
			return _authData;
		}
	}
}