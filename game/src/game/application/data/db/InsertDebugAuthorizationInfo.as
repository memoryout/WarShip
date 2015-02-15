package game.application.data.db
{
	import flash.events.IEventDispatcher;
	
	import game.application.data.DataRequest;
	import game.services.interfaces.ISQLManager;
	import game.services.sqllite.SQLInsertRequest;
	import game.services.sqllite.SQLRequest;
	
	public class InsertDebugAuthorizationInfo extends DataRequest
	{
		private var _sqlConnection:			ISQLManager;
		
		private var _userId:				uint;
		private var _login:					String;
		private var _pass:					String;
		
		public function InsertDebugAuthorizationInfo(sqlConnection:ISQLManager)
		{
			super();
			
			_sqlConnection = sqlConnection;
		}
		
		public function setData(userId:uint, login:String, pass:String):void
		{
			_userId = userId;
			_login = login;
			_pass = pass;
		}
		
		override public function start():void
		{
			var request:SQLInsertRequest = new SQLInsertRequest();
			request.setOnResult( handleOnResultRequest);
			
			request.into = '"main"."simulator"';
			request.putParameter("user_id", _userId);
			request.putParameter("email", _login);
			request.putParameter("pass", _pass);
			
			_sqlConnection.executeRequest(request);
		}
		
		private function handleOnResultRequest(request:SQLRequest):void
		{
			this.dispatchComplete();
		}
	}
}