package game.application.server
{
	import game.AppGlobalVariables;
	import game.application.BaseProxy;
	import game.application.ProxyList;
	import game.application.data.user.UserData;
	import game.application.interfaces.data.IUserDataProxy;
	import game.application.interfaces.server.IServerConnectionProxy;
	import game.application.server.data.AuthorizationData;
	import game.services.ServicesList;
	import game.services.interfaces.IServerConnection;
	import game.services.net.ServerConnectionEvent;
	
	public class ServerConnectionProxy extends BaseProxy implements IServerConnectionProxy
	{
		private var _serverConnection:				IServerConnection;
		
		private var _connectionStatus:				uint;
		
		public function ServerConnectionProxy(proxyName:String=null)
		{
			super(proxyName);
			
			_connectionStatus = ServerConnectionStatus.DISABLED;
		}
		
		
		override public function onRegister():void
		{
			_serverConnection = ServicesList.getSearvice( ServicesList.SERVER_CONNECTION ) as IServerConnection;
		}
		
		
		public function connectToServer():void
		{
			_serverConnection.addEventListener(ServerConnectionEvent.CONNECTION_INIT, handlerConnectionInitComplete);
			_serverConnection.initConnection(AppGlobalVariables.CONNECTION_TYPE, AppGlobalVariables.SERVER_URL, AppGlobalVariables.SERVER_PORT);
		}
		
		
		public function signIn():void
		{
			var userProxy:IUserDataProxy = this.facade.retrieveProxy(ProxyList.USER_DATA_PROXY) as IUserDataProxy;
			if(userProxy)
			{
				var userData:UserData = userProxy.getUserData();
				
				if(userData)
				{
					_serverConnection.addEventListener(ServerConnectionEvent.REQUEST_COMPLETE, handlerSignInComplete);
					_serverConnection.addEventListener(ServerConnectionEvent.REQUEST_ERROR, handlerSignInError);
					
					if( userData.getValue("login") && userData.getValue("pass") )
					{
						_serverConnection.signIn( userData.getValue("login"), userData.getValue("pass") );
					}
					else if( userData.getValue("deviceID") && userData.getValue("name") )
					{
						_serverConnection.createUser( userData.getValue("deviceID"), userData.getValue("name") );
					}
				}
			}
		}
		
		
		
		public function sendUserShipLocation(arr:Array):void
		{
			if(_serverConnection)
			{
				_serverConnection.sendShipLocation(arr);
			}
		}
		
		
		private function handlerSignInComplete(e:ServerConnectionEvent):void
		{
			var data:Object = e.data;
			
			parseResponce(data);
			
			trace(data);
		}
		
		
		private function handlerSignInError(e:ServerConnectionEvent):void
		{
			_connectionStatus = ServerConnectionStatus.DISABLED;
		}
		
		
		
		
		
		private function handlerConnectionInitComplete(e:ServerConnectionEvent):void
		{
			_serverConnection.removeEventListener(ServerConnectionEvent.CONNECTION_INIT, handlerConnectionInitComplete);
			
			this.sendNotification(ServerConnectionProxyEvents.CONNECTION_COMPLETE);
		}
		
		
		public function getNetStatus():uint
		{
			return _connectionStatus;
		}
		
		
		
		
		private function parseResponce(data:Object):void
		{
			_connectionStatus = ServerConnectionStatus.ENABLED;
			
			var responce:ServerResponce = new ServerResponce();
			responce.setRawData( data );
			
			parseUserCommonData(data);
			
			switch(data.cmd)
			{
				case "authorize":
				{
					parseAuthorizationData(data, responce);
					break;
				}
			}
			
			this.sendNotification(ServerConnectionProxyEvents.REQUEST_COMPLETE, responce);
		}
		
		
		private function parseUserCommonData(data:Object):void
		{
			
		}
		
		
		private function parseAuthorizationData(data:Object, respoce:ServerResponce):void
		{
			var loginInfo:Object = data.loginInfo;
			
			if(loginInfo)
			{
				var auth:AuthorizationData = new AuthorizationData();
				
				auth.login = loginInfo.login;
				auth.name = loginInfo.name;
				auth.pass = loginInfo.pass;
				auth.session = loginInfo.session;
				
				respoce.pushData( auth );
			}
		}
	}
}