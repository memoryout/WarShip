package game.application.startup
{
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import game.AppGlobalVariables;
	import game.application.ApplicationCommands;
	import game.application.ApplicationEvents;
	import game.application.BaseProxy;
	import game.application.ProxyList;
	import game.application.commands.authorization.SetUserAuthorizationCommand;
	import game.application.commands.startup.ServerAuthorizationResult;
	import game.application.commands.startup.ServerConectionResult;
	import game.application.commands.startup.UserDataProxyConnectedProxy;
	import game.application.data.user.UserData;
	import game.application.data.user.UserDataProxy;
	import game.application.interfaces.data.IUserDataProxy;
	import game.application.interfaces.server.IServerConnectionProxy;
	import game.application.server.ServerConnectionProxyEvents;
	import game.services.ServicesList;
	import game.services.device.DeviceInfo;
	import game.services.device.DeviceManagerEvents;
	import game.services.interfaces.IAssetManager;
	import game.services.interfaces.IDeviceManager;
	import game.services.interfaces.ISQLManager;
	import game.services.interfaces.IServerConnection;
	import game.services.net.ServerConnectionEvent;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class StartupProxy extends BaseProxy
	{
		public static const STARTUP_COMPLETE:		String = "startup.complete";
		public static const STARTUP:				String = "startup.start";
		
		private var _deviceInfo:				DeviceInfo;
		private var _userDataProxy:				IUserDataProxy;
		private var _userData:					UserData;
		private var _server:					IServerConnectionProxy;
		
		private var _serverConnection:			IServerConnection;
		
		private var _timeoutID:					uint;
		
		public function StartupProxy(proxyName:String)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			init();
		}
		
		
		private function init():void
		{
			this.sendNotification(ApplicationEvents.START_UP_INIT);
			
			var asset:IAssetManager = ServicesList.getSearvice( ServicesList.ASSET_MANAGER) as IAssetManager;
			
			if( asset.isAssetExist() )
			{
				handlerAssetInit();
			}
			else
			{
				var loaderInfo:LoaderInfo = asset.loadSource(AppGlobalVariables.SOURCE_URL);
				loaderInfo.addEventListener(Event.INIT, handlerAssetInit);
				loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlerAssetError);
			}
		}
		
		
		private function handlerAssetError(e:IOErrorEvent):void
		{
			this.sendNotification(ApplicationEvents.START_UP_SOURCE_LOAD_ERROR);
		}
		
		private function handlerAssetInit(e:Event = null):void
		{
			if(e) 
			{
				e.currentTarget.removeEventListener(Event.INIT, handlerAssetInit);
				e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, handlerAssetError);
			}
			
			this.sendNotification(ApplicationEvents.START_UP_SOURCE_LOAD_COMPLETE);
			
			
			getDeviceInfo();
		}
		
		
		private function getDeviceInfo():void
		{
			var device:IDeviceManager = ServicesList.getSearvice( ServicesList.DEVICE_MANAGER) as IDeviceManager;
			
			if(device.deviceInfo)
			{
				handlerDeviceInfo(null);
			}
			else
			{
				device.addEventListener(DeviceManagerEvents.DEVICE_ID_RECEIVE, handlerDeviceInfo);
				device.retrieveDeviceInfo()
			}
		}
		
		
		private function handlerDeviceInfo(e:Event = null):void
		{
			if(e.currentTarget) e.currentTarget.removeEventListener(DeviceManagerEvents.DEVICE_ID_RECEIVE, handlerDeviceInfo);
			
			var device:IDeviceManager = ServicesList.getSearvice( ServicesList.DEVICE_MANAGER) as IDeviceManager;
			_deviceInfo = device.deviceInfo;
			
			runDataBase();
			
			checkAuthorization();
		}
		
		
		private function runDataBase():void
		{
			var sql:ISQLManager = ServicesList.getSearvice( ServicesList.SQL_MANAGER ) as ISQLManager;
			sql.connect(AppGlobalVariables.SQL_FILE_URL);
		}
		
		
		private function checkAuthorization():void
		{
			_userDataProxy = this.facade.retrieveProxy(ProxyList.USER_DATA_PROXY) as IUserDataProxy;
			this.facade.registerCommand(ApplicationEvents.USER_DATA_PROXY_CONNECTED, UserDataProxyConnectedProxy);
			_userDataProxy.connect();
		}
		
		
		public function userDataConnected():void
		{
			_userData = _userDataProxy.getUserData();
			
			if( _userData )
			{
				if(_userData.getValue("name") == null) reqiuredUserAuthorizationData();
				else authorizationSeccussesComplete();
			}
		}		
		
		
		private function reqiuredUserAuthorizationData():void
		{
			this.facade.registerCommand( ApplicationCommands.STARTUP_SET_LOGIN, SetUserAuthorizationCommand);
			
			this.sendNotification( ApplicationEvents.REQUIRED_USER_AUTHORIZATION);
		}
		
		
		public function setUserAuthorizationData(login:String):void
		{
			this.facade.removeCommand( ApplicationCommands.STARTUP_SET_LOGIN );
			
			var userData:UserData = _userDataProxy.getUserData();
			userData.setValue("name", login);
				
			_userDataProxy.commitChanges();
			
			authorizationSeccussesComplete();
		}
		
		
		public function destroy():void
		{
			
		}
		
		
		private function authorizationSeccussesComplete():void
		{
			var userData:UserData = _userDataProxy.getUserData();
			
			if(!_deviceInfo.deviceId || _deviceInfo.deviceId == "emulator")
			{
				if( userData.getValue("deviceID") )
				{
					_deviceInfo.deviceId = userData.getValue("deviceID");
				}
				else
				{
					_deviceInfo.deviceId = Math.random().toString();
					userData.setValue("deviceID", _deviceInfo.deviceId );
					_userDataProxy.commitChanges();
				}
			}
			else
			{
				if( !userData.getValue("deviceID") )
				{
					userData.setValue("deviceID", _deviceInfo.deviceId );
					_userDataProxy.commitChanges();
				}
			}
			
			
			
			connectToServer();
			
			//this.sendNotification(STARTUP_COMPLETE);
		}
		
		
		private function connectToServer():void
		{
			this.facade.registerCommand(ServerConnectionProxyEvents.CONNECTION_COMPLETE, ServerConectionResult);
			this.facade.registerCommand(ServerConnectionProxyEvents.CONNECTION_ERROR, ServerConectionResult);
			
			_server = this.facade.retrieveProxy(ProxyList.SERVER_PROXY) as IServerConnectionProxy;
			_server.connectToServer();
			
			//_serverConnection = ServicesList.getSearvice( ServicesList.SERVER_CONNECTION ) as IServerConnection;
			//_serverConnection.addEventListener(ServerConnectionEvent.CONNECTION_INIT, handlerConnectionInitComplete);
			//_serverConnection.initConnection(AppGlobalVariables.CONNECTION_TYPE, AppGlobalVariables.SERVER_URL, AppGlobalVariables.SERVER_PORT);
		}
		
		
		
		public function serverConnectionComplete():void
		{
			this.facade.removeCommand(ServerConnectionProxyEvents.CONNECTION_COMPLETE);
			this.facade.removeCommand(ServerConnectionProxyEvents.CONNECTION_ERROR);
			
			signInOnServer();
		}
		
		
		private function signInOnServer():void
		{
			this.facade.registerCommand( ServerConnectionProxyEvents.REQUEST_COMPLETE, ServerAuthorizationResult);
			
			_server.signIn();
			_timeoutID = setTimeout( handlerSignInError, 2000 );
		}
		
		
		public function handlerSignInComplete():void
		{
			this.facade.removeCommand( ServerConnectionProxyEvents.REQUEST_COMPLETE);
			
			clearTimeout( _timeoutID );
			//_serverConnection.removeEventListener(ServerConnectionEvent.REQUEST_COMPLETE, handlerSignInComplete);
			//_serverConnection.removeEventListener(ServerConnectionEvent.REQUEST_ERROR, handlerSignInError);
			
			completeStartup();
		}
		
		public function handlerSignInError():void
		{
			this.facade.removeCommand( ServerConnectionProxyEvents.REQUEST_COMPLETE);
			
			clearTimeout( _timeoutID );
			
			//_serverConnection.removeEventListener(ServerConnectionEvent.REQUEST_COMPLETE, handlerSignInComplete);
			//_serverConnection.removeEventListener(ServerConnectionEvent.REQUEST_ERROR, handlerSignInError);
			
			trace("handlerSignInError");
			
			completeStartup();
		}
		
		
		private function completeStartup():void
		{
			this.sendNotification(STARTUP_COMPLETE);
		}
	}
}