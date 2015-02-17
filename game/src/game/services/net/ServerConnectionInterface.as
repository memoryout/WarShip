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
		private var _session:			String;
		
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
		
		
		public function setSessionKey(session:String):void
		{
			_session = session;
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
		
		public function createUser(name:String, login:String, pass:String):void
		{
//			obj.id = serId												!!!!!!!!!!was
			
			var req:Request = new Request();
			
			var obj:Object = new Object();
			obj.cmd = ServerCommandList.CREATE_USER;
			obj.id = 1;
			obj.login = login;
			obj.pass = pass;	
			obj.name = name;					
			obj.lang = 0;
			obj.platform = 0;
			
			req.pushData( obj );
			_connection.sendRequest( req );
		}
		
		
		public function signIn(login:String, pass:String):void
		{
			var req:Request = new Request();
			
			var obj:Object = new Object();
			obj.cmd = ServerCommandList.LOGIN;
			obj.login = login;
			obj.pass = pass;
			obj.lang = 0;
			obj.platform = 0;
			
			req.pushData( obj );
			_connection.sendRequest( req );
		}
		
		public function signInGoogle(authToken:String):void
		{
			var req:Request = new Request();
			
			var obj:Object = new Object();
			obj.cmd = ServerCommandList.LOGIN;
			obj.auth_token = authToken;
			
			req.pushData( obj );
			_connection.sendRequest( req );
		}
		
		
		public function sendShipLocation(arr:Array):void
		{
			var req:Request = new Request();
			
			var obj:Object = new Object();
			obj.cmd = ServerCommandList.START_GAME;
			obj.ships = JSON.stringify(arr);
			obj.session = _session;
			
			req.pushData( obj );
			_connection.sendRequest( req );
		}
		
		
		public function getGameUpdate():void
		{
			var req:Request = new Request();
			
			var obj:Object = new Object();
			obj.cmd = ServerCommandList.GET_GAME_UPDATE;
			obj.session = _session;
			
			req.pushData( obj );
			_connection.sendRequest( req );
		}
		
		
		public function sendHitPointPosition(x:uint, y:uint):void
		{
			var req:Request = new Request();
			
			var obj:Object = new Object();
			obj.cmd = ServerCommandList.SEND_HIT_POINT_POSITION;
			obj.session = _session;
			obj.target = JSON.stringify([x,y]);
			
			req.pushData( obj );
			_connection.sendRequest( req );
		}
		
		
		
		
		private function handlerInitComplete(e:Event):void
		{
			e.currentTarget.removeEventListener(BaseConnection.INIT_CONNECTION_COMPLETE, handlerInitComplete);
			e.currentTarget.removeEventListener(BaseConnection.INIT_CONNECTION_ERROR, handlerInitError);
			
			this.dispatchEvent( new ServerConnectionEvent(ServerConnectionEvent.CONNECTION_INIT) );
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
			trace("handlerRequestComplete");
			var obj:Object = _connection.result.getResult();
			
			this.dispatchEvent( new ServerConnectionEvent(ServerConnectionEvent.REQUEST_COMPLETE, obj) );
		}
		
		private function handlerRequestError(e:Event):void
		{
			this.dispatchEvent( new ServerConnectionEvent(ServerConnectionEvent.REQUEST_ERROR) );
		}
	}
}