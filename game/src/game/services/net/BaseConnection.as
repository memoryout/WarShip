package game.services.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class BaseConnection extends EventDispatcher
	{
		public static const INIT_CONNECTION_COMPLETE:			String = "initConnectionComplete";
		public static const INIT_CONNECTION_ERROR:				String = "initConnectionError";
		
		public static const ON_COMPLETE_REQUEST:				String = "onCompleteRequest";
		public static const ON_ERROR_REQUEST:					String = "onErrorRequest";
		
		private const _onCompleteRequest:			Event = new Event(ON_COMPLETE_REQUEST);
		
		
		private var _request:				Request;
		
		protected var serverURL:			String;
		protected var port:					String;
		
		public function BaseConnection()
		{
			super();
		}
		
		
		public function initConnection(server:String, port:String):void
		{
			serverURL = server;
			port = port;
		}
		
		
		public function sendRequest(request:Request):void
		{
			
		}
		
		
		public function get result():Request
		{
			return _request;
		}
		
		
		
		
		protected function onInitConnectionComplete():void
		{
			this.dispatchEvent( new Event(INIT_CONNECTION_COMPLETE) );
		}
		
		
		protected function onInitConnectionError():void
		{
			this.dispatchEvent( new Event(INIT_CONNECTION_ERROR) );
		}
		
		
		protected function onCompleteRequest(request:Request):void
		{
			_request = request;
			this.dispatchEvent( _onCompleteRequest );
		}
		
		
		protected function onErrorRequest(request:Request):void
		{
			this.dispatchEvent( new Event(ON_ERROR_REQUEST) );
		}
	}
}