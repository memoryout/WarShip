package game.services.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import game.services.IService;
	import game.services.ServicesList;
	import game.services.interfaces.IServerConnection;
	import game.services.net.http.HTTPConnection;
	
	public class ServerConnectionInterface extends EventDispatcher implements IService, IServerConnection
	{
		private var _serverURL:			String;
		private var _serverPort:		String;
		
		private var _connection:		BaseConnection;
		
		public function ServerConnectionInterface()
		{
			super();
		}
		
		public static function init():void
		{
			ServicesList.addSearvice( new ServerConnectionInterface() );
		}
		
		public function get serviceName():String
		{
			return ServicesList.SERVER_CONNECTION;
		}
		
		
		
		public function initConnection(type:String, url:String, port:String = ""):void
		{
			switch(type)
			{
				case ServerConnectionType.HTTP:
				{
					_connection = new HTTPConnection();
					break;
				}
			}
			
			
			if(_connection)
			{
				_connection.addEventListener(BaseConnection.INIT_CONNECTION_COMPLETE, handlerInitComplete);
				_connection.addEventListener(BaseConnection.INIT_CONNECTION_ERROR, handlerInitError);
				_connection.addEventListener(BaseConnection.ON_COMPLETE_REQUEST, handlerRequestComplete);
				_connection.addEventListener(BaseConnection.ON_ERROR_REQUEST, handlerRequestError);
				
				_connection.initConnection(url, port);
			}
		}
		
		
		public function signIn(userId:String, name:String):void
		{
			var req:Request = new Request();
			
			var obj:Object = new Object();
			obj.cmd = ServerCommandList.SIGN_IN;
			obj.name = name;
			obj.id = userId;
			
			req.pushData( obj );
			_connection.sendRequest( req );
		}
		
		
		
		
		
		
		
		private function handlerInitComplete(e:Event):void
		{
			e.currentTarget.removeEventListener(BaseConnection.INIT_CONNECTION_COMPLETE, handlerInitComplete);
			e.currentTarget.removeEventListener(BaseConnection.INIT_CONNECTION_ERROR, handlerInitError);
			e.currentTarget.removeEventListener(BaseConnection.ON_COMPLETE_REQUEST, handlerRequestComplete);
			e.currentTarget.removeEventListener(BaseConnection.ON_ERROR_REQUEST, handlerRequestError);
			
			this.dispatchEvent( new Event(ServerConnectionEvent.CONNECTION_INIT) );
		}
		
		private function handlerInitError(e:Event):void
		{
			e.currentTarget.removeEventListener(BaseConnection.INIT_CONNECTION_COMPLETE, handlerInitComplete);
			e.currentTarget.removeEventListener(BaseConnection.INIT_CONNECTION_ERROR, handlerInitError);
			e.currentTarget.removeEventListener(BaseConnection.ON_COMPLETE_REQUEST, handlerRequestComplete);
			e.currentTarget.removeEventListener(BaseConnection.ON_ERROR_REQUEST, handlerRequestError);
		}
		
		private function handlerRequestComplete(e:Event):void
		{
			
		}
		
		private function handlerRequestError(e:Event):void
		{
			
		}
	}
}