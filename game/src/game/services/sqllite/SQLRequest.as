package game.services.sqllite
{
	import flash.data.SQLResult;
	import flash.events.SQLErrorEvent;
	
	import org.as3commons.logging.level.ERROR;

	public class SQLRequest
	{
		private var _onResult:			Function;
		private var _onError:			Function;
		
		private var _onComplete:		Function;
		
		private var _request:			String;
		private var _requestParams:		Object;
		
		private var _result:			SQLResult;
		private var _errorEvent:		SQLErrorEvent;
		
		public function SQLRequest()
		{
			
		}
		
		public function setOnResult(onResultCallback:Function):void
		{
			_onResult = onResultCallback;
		}
		
		public function getOnResultCallback():Function
		{
			return _onResult;
		}
		
		public function setOnError(onError:Function):void
		{
			_onError = onError;
		}
		
		public function getOnError():Function
		{
			return _onError;
		}
		
		
		public function setRequest(request:String, onResult:Function, onError:Function):void
		{
			_onComplete = onResult;
			_onError = onError;
			
			_request = request;
		}
		
		
		public function setRequestParame(data:Object):void
		{
			_requestParams = data;
		}
		
		public function putParameter(name:String, value:*):void
		{
			if(_requestParams == null) _requestParams = {};
			
			_requestParams[name] = value;
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
		
		
		public function getRawRequest():String
		{
			return null;
		}
		
		public function setRequestResult(result:SQLResult):void
		{
			_result = result;
			
			if(_onResult != null) _onResult(this);
		}
		
		public function setRequstError(event:SQLErrorEvent):void
		{
			_errorEvent = event;
			if(_onError != null) _onError(this);
		}
		
		
		public function getResult():SQLResult
		{
			return _result;
		}
		
		public function getErrorEvent():SQLErrorEvent
		{
			return _errorEvent;
		}
		
		
		public function destroy():void
		{
			_onResult = null;
			_onError = null;
			_request = null;
			_requestParams = null;
		}
	}
}