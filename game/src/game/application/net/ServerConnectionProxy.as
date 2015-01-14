package game.application.net
{
	import game.AppGlobalVariables;
	import game.application.ProxyList;
	import game.application.connection.ServerDataChannel;
	import game.application.data.user.UserData;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.application.interfaces.data.IUserDataProxy;
	import game.application.interfaces.net.IServerConnectionProxy;
	import game.library.BaseProxy;
	import game.services.ServicesList;
	import game.services.interfaces.IServerConnection;
	import game.services.net.ServerConnectionEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class ServerConnectionProxy extends BaseProxy implements IServerConnectionProxy
	{
		private var _serverConnection:				IServerConnection;
		private var _dataChannel:					IServerDataChannel;
		
		private var _connectionStatus:				uint;
		
		public function ServerConnectionProxy(proxyName:String=null)
		{
			super(proxyName);
			
			_connectionStatus = ServerConnectionStatus.DISABLED;
		}
		
		
		override public function onRegister():void
		{
			_serverConnection = ServicesList.getSearvice( ServicesList.SERVER_CONNECTION ) as IServerConnection;
			
			_dataChannel = this.facade.retrieveProxy(ProxyList.ACTIONS_QUEUE_PROXY) as IServerDataChannel;
			
			if(!_dataChannel)
			{
				_dataChannel = new ServerDataChannel(ProxyList.CLIENT_DATA_CHANNEL)
				this.facade.registerProxy( _dataChannel as IProxy );
			}
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
					
					/*if( userData.getValue("login") && userData.getValue("pass") )
					{
						_serverConnection.signIn( userData.getValue("login"), userData.getValue("pass") );
					}
					else */if( userData.getValue("deviceID") && userData.getValue("name") )
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
		
		
		public function getGameUpdate():void
		{
			if(_serverConnection)
			{
				_serverConnection.getGameUpdate();
			}
		}
		
		
		public function sendHitPointPosition(x:uint, y:uint):void
		{
			if(_serverConnection)
			{
				_serverConnection.sendHitPointPosition(x, y);
			}
		}
		
		
		
		
		private function handlerSignInComplete(e:ServerConnectionEvent):void
		{
			var data:Object = e.data;
			
			parseResponce(data);
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
			this.log( JSON.stringify(data) );
			
			_dataChannel.processRawData( data );
			
			//_actionsQueue.startQueue();
			//_actionsQueue.parseRowData(data);
			//_actionsQueue.finishQueue();
			
			_connectionStatus = ServerConnectionStatus.ENABLED;
		}
	}
}