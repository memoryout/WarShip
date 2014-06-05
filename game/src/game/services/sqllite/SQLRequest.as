package game.services.sqllite
{
	public class SQLRequest
	{
		private var _onComplete:		Function;
		private var _onError:			Function;
		
		private var _request:			String;
		private var _requestParams:		Object;
		
		public function SQLRequest()
		{
			
		}
		
		
		public function setRequest(request:String, onComplete:Function, onError:Function):void
		{
			_onComplete = onComplete;
			_onError = onError;
			
			_request = request;
		}
		
		
		public function setRequestParame(data:Object):void
		{
			_requestParams = data;
		}
		
		public function get request():String
		{
			return _request;
		}
		
		public function get requestParams():Object
		{
			return _requestParams;
		}
		
		
		public function onResult(data:Array):void
		{
			if(_onComplete != null) _onComplete(data);
		}
		
		
		public function onErrorResult(error:String):void
		{
			if(_onError != null) _onError(error);
		}
	}
}