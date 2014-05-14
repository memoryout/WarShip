package game.application.data
{
	import flash.events.EventDispatcher;
	
	import game.services.interfaces.ISQLManager;
	import game.services.sql.SQLRequest;

	public class UserDataProxyRequest
	{
		private var _onResultCallback:		Function;
		private var _onErrorCallback:		Function;
		
		private var _targetOnResult:		Function;
		private var _targetOnError:			Function;
		
		private var _result:				Array;
		private var _error:					String;
		
		public function UserDataProxyRequest()
		{
			
		}
		
		
		
		public function setTragetCallbacks(onResultCallback:Function, onErrorCallback:Function):void
		{
			_targetOnResult = onResultCallback;
			_targetOnError = onErrorCallback;
		}
		
				
		public function setData(sqlProxy:ISQLManager, request:String, onResult:Function, onError:Function):void
		{
			_onResultCallback = onResult;
			_onErrorCallback = onError;
			
			var sqlRequest:SQLRequest = new SQLRequest();
			sqlRequest.setRequest(request, this.onResult, this.onError);
			
			sqlProxy.executeRequest( sqlRequest );
		}
		
		
		public function get result():Array
		{
			return _result;
		}
		
		
		public function get error():String
		{
			return _error;
		}
		
		
		public function get targetOnResult():Function
		{
			return _targetOnResult;
		}
		
		
		public function get targetOnError():Function
		{
			return _targetOnError;
		}
		
		
		public function destroy():void
		{
			_onResultCallback = null;
			_onErrorCallback = null;
			_targetOnResult = null;
			_targetOnError = null;
			_result = null;
			_error = null;
		}
		
		
		private function onResult(data:Array):void
		{
			_result = data;
			if(_onResultCallback != null) _onResultCallback(this);
		}
		
		
		private function onError(error:String):void
		{
			_error = error;
			if(_onErrorCallback != null) _onErrorCallback(this);
		}
	}
}