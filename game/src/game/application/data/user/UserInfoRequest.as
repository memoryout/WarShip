package game.application.data.user
{
	import flash.data.SQLResult;
	import flash.events.IEventDispatcher;
	import flash.events.SQLErrorEvent;
	
	import game.application.data.DataRequest;
	import game.services.interfaces.ISQLManager;
	import game.services.sqllite.SQLRequest;
	import game.services.sqllite.SQLSelectRequest;
	
	public class UserInfoRequest extends DataRequest
	{
		private var _sqlConnection:			ISQLManager;
		
		private var _users:					Vector.<UserData>;
		
		public function UserInfoRequest(sqlConnection:ISQLManager)
		{
			super();
			
			_sqlConnection = sqlConnection;
		}
		
		
		override public function start():void
		{
			var sqrRequest:SQLSelectRequest = new SQLSelectRequest();
			sqrRequest.from = '"main"."user"';
			sqrRequest.select = '*';
			
			sqrRequest.setOnResult( handleRequestResult );
			sqrRequest.setOnError( handleErrorRequest );
			
			_sqlConnection.executeRequest(sqrRequest);
		}
		
		public function getUserLists():Vector.<UserData>
		{
			return _users;
		}
		
		private function handleRequestResult(request:SQLRequest):void
		{
			_users = new Vector.<UserData>();
			
			
			var result:SQLResult = request.getResult();
			
			if(result && result.data)
			{
				var arr:Array = result.data;
				
				var user:UserData;
				var i:int;
				
				for(i = 0; i < arr.length; i++)
				{
					user = new UserData(arr[i]);
					_users.push( user );
				}
			}
			
			this.dispatchComplete();
			
		}
		
		private function handleErrorRequest(request:SQLRequest):void
		{
			
		}
	}
}