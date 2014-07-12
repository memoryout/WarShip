package game.application.connection.actions
{
	import game.application.connection.ActionQueueData;
	import game.application.connection.ActionType;
	import game.application.connection.ActionsQueueEvent;
	
	public class AuthorizationData extends ActionQueueData
	{
		public var login:			String;
		public var name:			String;
		public var pass:			String;
		public var session:			String;
		
		public function AuthorizationData()
		{
			super();
			this._type = ActionType.AUTHORIZATION;
		}
	}
}