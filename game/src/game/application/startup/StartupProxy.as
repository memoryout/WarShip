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
	import game.application.ProxyList;
	import game.application.commands.authorization.SetUserAuthorizationCommand;
	import game.application.commands.startup.NewUserCreatedCommand;
	import game.application.commands.startup.ServerConectionResult;
	import game.application.commands.startup.UserDataProxyConnectedProxy;
	import game.application.commands.startup.UserDataProxyReceiveUsersList;
	import game.application.connection.ChannelDataType;
	import game.application.connection.ServerDataChannelEvent;
	import game.application.connection.ServerDataChannelLocalEvent;
	import game.application.connection.data.AuthorizationData;
	import game.application.data.user.UserData;
	import game.application.data.user.UserDataProxy;
	import game.application.data.user.UserDataProxyEvent;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.application.interfaces.data.IUserDataProxy;
	import game.application.interfaces.net.IServerConnectionProxy;
	import game.application.net.ServerConnectionProxyEvents;
	import game.library.BaseProxy;
	import game.library.LocalEvent;
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
		
		private var _dataChannel:				IServerDataChannel;
		
		private var _timeoutID:					uint;
		
		private var _userList:					Vector.<UserData>;
		
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
			
			checkAuthorization();
		}
		

		private function checkAuthorization():void
		{
			_userDataProxy = this.facade.retrieveProxy(ProxyList.USER_DATA_PROXY) as IUserDataProxy;
			
			this.facade.registerCommand(ApplicationEvents.USER_DATA_PROXY_CONNECTED, UserDataProxyConnectedProxy);
			_userDataProxy.connect();
		}
		
		
		public function userDataConnected():void
		{
			this.facade.removeCommand(ApplicationEvents.USER_DATA_PROXY_CONNECTED);
			this.facade.registerCommand(ApplicationEvents.USER_DATA_RECEIVE_USERS_LIST, UserDataProxyReceiveUsersList);
			_userDataProxy.retrieveUsersList();
			
		}
		
		public function usersListReceive():void
		{
			this.facade.removeCommand( ApplicationEvents.USER_DATA_RECEIVE_USERS_LIST );
			
			_userList = _userDataProxy.getUsersList();
			
			if(_userList.length == 0)
			{
				reqiuredUserAuthorizationData();
			}
			else
			{
				requiredSelectCurrentActiveUser();
			}
			
		}
		
		
		
		
		public function getUserList():Vector.<UserData>
		{
			return _userList;
		}
		
		private function verifyUserList():void
		{
			if(_userList.length)
			{
				if(_userList.length == 1)
				{
					if(_userList[0].name != null) requiredSelectCurrentActiveUser();
					else 
					{
						_userDataProxy.selectCurrentUser(_userList[0].id);
						reqiuredUserAuthorizationData();
					}
				}
				else
				{
					requiredSelectCurrentActiveUser();
				}
			}
			else
			{
				reqiuredUserAuthorizationData();
			}
		}
		
		
		private function requiredSelectCurrentActiveUser():void
		{
			this.facade.registerCommand( ApplicationCommands.STARTUP_SET_LOGIN, SetUserAuthorizationCommand);
			this.facade.registerCommand( ApplicationCommands.STARTUP_SELECT_USER, SetUserAuthorizationCommand);
			
			this.sendNotification( ApplicationEvents.REQUIRED_SELECT_ACTIVE_USER, _userList);
		}
		
		private function reqiuredUserAuthorizationData():void
		{
			this.facade.registerCommand( ApplicationCommands.STARTUP_SET_LOGIN, SetUserAuthorizationCommand);
			
			this.sendNotification( ApplicationEvents.REQUIRED_USER_AUTHORIZATION);
		}
		
		
		public function setUserAuthorizationData(name:String):void
		{
			this.facade.removeCommand( ApplicationCommands.STARTUP_SET_LOGIN );
			
			
			this.facade.registerCommand( ApplicationEvents.USER_DATA_USER_CREATED, NewUserCreatedCommand);
			_userDataProxy.createNewUser( name );
		}
		
		
		public function setCurrentUser(id:uint):void
		{
			_userDataProxy.selectCurrentUser( id );
			authorizationSeccussesComplete();
		}
		
		
		public function newUserCreated():void
		{
			authorizationSeccussesComplete();
		}
		
		
		public function destroy():void
		{
			
		}
		
		
		private function authorizationSeccussesComplete():void
		{
			_userData = _userDataProxy.getUserData();
			
			if(!_deviceInfo.deviceId || _deviceInfo.deviceId == "emulator")
			{
				if( _userData.deviceID )
				{
					_deviceInfo.deviceId = _userData.deviceID;
				}
				else
				{
					_deviceInfo.deviceId = Math.random().toString();
					_userData.deviceID = _deviceInfo.deviceId;
					_userDataProxy.commitChanges();
				}
			}
			else
			{
				if( !_userData.deviceID )
				{
					_userData.deviceID =  _deviceInfo.deviceId;
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
			_dataChannel = this.facade.retrieveProxy(ProxyList.CLIENT_DATA_CHANNEL) as IServerDataChannel;
			
			if( _dataChannel )
			{
				_dataChannel.addLocalListener( ServerDataChannelLocalEvent.CHANNEL_DATA, handlerDataChannel);
			}
			
			//this.facade.registerCommand( ServerDataChannelEvent.ACTIONS_QUEUE_COMPLETE, ServerAuthorizationResult);
			
			_timeoutID = setTimeout( handlerSignInError, AppGlobalVariables.SERVER_CONNECTION_TIMEOUT );
			
			_server.signIn();
			
		}
		
		
		private function handlerDataChannel(dataMessage:LocalEvent):void
		{
			var type:uint = dataMessage.data.type;
			
			if(type == ChannelDataType.AUTHORIZATION)
			{
				updateUserAuthorizationData( dataMessage.data as AuthorizationData);
			}
		}
		
		
		private function updateUserAuthorizationData(data:AuthorizationData):void
		{
			if(data.error)
			{
				clearTimeout( _timeoutID );
				
				if(data.errorCode == 3)
				{
					_userDataProxy.addLocalListener(UserDataProxyEvent.USER_DELETE_COMPLETE, handlerUserDeleteComplete);
					_userDataProxy.deleteUser( _userData.id );
					_userDataProxy.commitChanges();
				}
			}
			else
			{
				if(_userDataProxy)
				{
					if(data.login && _userData.getValue("login") != data.login) _userData.setValue("login", data.login);
					if(data.pass && _userData.getValue("pass") != data.pass) _userData.setValue("pass", data.pass);
					
					_userDataProxy.commitChanges();
				}
				
				
				var serverConnection:IServerConnection = ServicesList.getSearvice( ServicesList.SERVER_CONNECTION ) as IServerConnection;
				if(serverConnection)
				{
					serverConnection.setSessionKey( data.session );
				}
				
				handlerSignInComplete();
			}
		}
		
		private function handlerUserDeleteComplete(event:LocalEvent):void
		{
			_userDataProxy.removeLocalListener(UserDataProxyEvent.USER_DELETE_COMPLETE, handlerUserDeleteComplete);
			userDataConnected();
		}
		
		
		private function handlerSignInComplete():void
		{
			this.facade.removeCommand( ServerDataChannelEvent.ACTIONS_QUEUE_COMPLETE);
			
			clearTimeout( _timeoutID );
			
			completeStartup();
		}
		
		public function handlerSignInError():void
		{
			//this.facade.removeCommand( ServerDataChannelEvent.ACTIONS_QUEUE_COMPLETE);
			
			if( _dataChannel )
			{
				_dataChannel.removeLocalListener( ServerDataChannelLocalEvent.CHANNEL_DATA, handlerDataChannel);
			}
			
			
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