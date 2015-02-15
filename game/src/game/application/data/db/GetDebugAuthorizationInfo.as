package game.application.data.db
{
	import flash.data.SQLResult;
	import flash.events.IEventDispatcher;
	
	import game.application.data.DataRequest;
	import game.services.interfaces.ISQLManager;
	import game.services.sqllite.SQLRequest;
	import game.services.sqllite.SQLSelectRequest;
	
	public class GetDebugAuthorizationInfo extends DataRequest
	{
		private var _sqlConnection:			ISQLManager;
		
		private var _userId:				uint;
		
		private var _data:					Object;
		
		public function GetDebugAuthorizationInfo(sqlConnection:ISQLManager)
		{
			super();
			
			_sqlConnection = sqlConnection;
		}
		
		public function setUserId(id:uint):void
		{
			_userId = id;
		}
		
		public function getData():Object
		{
			return _data;
		}
		
		override public function start():void
		{
			var sqrRequest:SQLSelectRequest = new SQLSelectRequest();
			sqrRequest.from = '"main"."simulator"';
			sqrRequest.select = '*';
			sqrRequest.addWhere("user_id", _userId.toString());
			
			sqrRequest.setOnResult( handleRequestResult );
			sqrRequest.setOnError( handleErrorRequest );
			
			_sqlConnection.executeRequest(sqrRequest);
		}
		
		
		private function handleRequestResult(request:SQLRequest):void
		{
			var result:SQLResult = request.getResult();
			
			if(result && result.data)
			{
				var arr:Array = result.data;
				
				if(arr.length > 0) _data = arr[0];
			}
			
			this.dispatchComplete();
			
		}
		
		private function handleErrorRequest(request:SQLRequest):void
		{
			
		}
	}
}