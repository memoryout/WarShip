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
		
		private function onComplete():void
		{
			
		}
		
		
		private function onError():void
		{
			trace("bar request");
		}
	}
}