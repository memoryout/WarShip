package game.application.data.user
{
	import flash.events.IEventDispatcher;
	
	import game.application.data.DataRequest;
	import game.services.interfaces.ISQLManager;
	import game.services.sqllite.SQLInsertRequest;
	import game.services.sqllite.SQLRequest;
	
	public class CreateUserRequest extends DataRequest
	{
		private var _sqlConnection:			ISQLManager;
		
		public function CreateUserRequest(sqlConnection:ISQLManager)
		{
			super();
			
			_sqlConnection = sqlConnection;
		}
		
		override public function start():void
		{
			var request:SQLInsertRequest = new SQLInsertRequest();
			request.setOnResult( handleOnResultRequest);
			
			request.into = '"main"."user"';
			request.putParameter("name","");
			
			_sqlConnection.executeRequest(request);
		}
		
		private function handleOnResultRequest(request:SQLRequest):void
		{
			
		}
	}
}