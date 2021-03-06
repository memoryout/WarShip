package game.services.net.http
{
	import flash.events.EventDispatcher;
	
	import game.services.net.BaseConnection;
	import game.services.net.Request;
	
	public class HTTPConnection extends BaseConnection
	{
		private const _requestQueue:		Vector.<Request> = new Vector.<Request>;
		
		private var _idle:					Boolean;
		private var _currentRequest:		Request;
		
		private var _httpRequest:			HTTPRequest;
		
		public function HTTPConnection()
		{
			_idle = true;
		}
		
		
		override public function initConnection(server:String, port:String):void
		{
			super.initConnection( server, port );
			if(port) server += ":" + port;
			
			this.onInitConnectionComplete();
		}
		
		
		override public function sendRequest(request:Request):void
		{
			_requestQueue.push(request);
			
			trySendRequest();
		}
		
		
		private function trySendRequest():void
		{
			if(_idle && _requestQueue.length)
			{
				_idle = false;
				
				_currentRequest = _requestQueue.shift();
				
				_httpRequest = new HTTPRequest();
				_httpRequest.load( serverURL, _currentRequest.getSendData(), onComplete, onError);
			}
		}
		
		private function onComplete(data:String):void
		{
			/// when server is working on debug
			var pattern:RegExp = /<br[\s|\/]*>/gi;
			var output:String  = data.replace(pattern, "");
			
			var pattern2:RegExp = /&nbsp;/g;
			var output2:String  = output.replace(pattern2, "");
			/// when server is working on debug
			
			trace(output2);
						
			var obj:Object = JSON.parse(output2);
			_currentRequest.setResult(obj);
			this.onCompleteRequest( _currentRequest );
			
			_idle = true;
			_currentRequest = null;
			trySendRequest();
		}
		
		
		private function onError():void
		{
			trace("bad request");
		}
	}
}