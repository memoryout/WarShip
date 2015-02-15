package game.application.authorization.service
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import game.AppGlobalVariables;
	import game.application.ProxyList;
	import game.application.authorization.AuthorizationInfo;
	import game.application.connection.ChannelData;
	import game.application.connection.ChannelDataType;
	import game.application.connection.ServerDataChannelLocalEvent;
	import game.application.connection.data.AuthorizationData;
	import game.application.data.DataProvider;
	import game.application.data.DataRequest;
	import game.application.data.db.GetDebugAuthorizationInfo;
	import game.application.data.user.UserData;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.application.interfaces.net.IServerConnectionProxy;
	import game.library.BaseProxy;
	import game.library.LocalEvent;

	public class DebugAuthorizationSystem extends BaseProxy implements IAuthorizationService
	{
		private var _userData:			UserData;
		private var _authorizationInfo:	Object;
		
		private var _serverProxy:		IServerConnectionProxy;
		private var _dataChannel:		IServerDataChannel;
		
		private var _authServerData:	AuthorizationData;
		
		private var _authorizationStatus:AuthorizationInfo;
		
		public function DebugAuthorizationSystem()
		{
			
		}
		
		override public function onRegister():void
		{
			_serverProxy = this.facade.retrieveProxy(ProxyList.SERVER_PROXY) as IServerConnectionProxy;
			
			_authorizationStatus = new AuthorizationInfo();
						
			initialize();
		}
		
		public function getAuthorizationState():AuthorizationInfo
		{
			return _authorizationStatus;
		}
		
		public function initialize():void
		{			
			_userData = DataProvider.getInstance().getUserDataProvider().getUserInfo();
			
			if(_userData)
			{
				retrieveLoginPassInfo();
			}
			else
			{
				_userData = DataProvider.getInstance().getUserDataProvider().createNewUser();
				_userData.targetPlatform = AppGlobalVariables.SIMULATOR;
				
				var request:EventDispatcher = DataProvider.getInstance().getUserDataProvider().commitNewUser();
				request.addEventListener(Event.COMPLETE, handlerNewUserCommitCompleted);
			}
		}
		
		
		private function handlerNewUserCommitCompleted(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, handlerNewUserCommitCompleted);
			
			var request:EventDispatcher = DataProvider.getInstance().getUserDataProvider().retrieveUserInfo();
			request.addEventListener(Event.COMPLETE, handlerUserInfo);
		}
		
		private function handlerUserInfo(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, handlerUserInfo);
			
			initialize();
		}
		
		
		private function retrieveLoginPassInfo():void
		{
			var request:EventDispatcher = DataProvider.getInstance().getDebugAuthorizationInfo( _userData.id );
			request.addEventListener(Event.COMPLETE, handlerLoginPassRetrieved);
		}
		
		private function handlerLoginPassRetrieved(e:Event):void
		{
			var request:GetDebugAuthorizationInfo = e.currentTarget as GetDebugAuthorizationInfo;
			request.removeEventListener(Event.COMPLETE, handlerLoginPassRetrieved);
			
			if(request.getData() != null) 
			{
				_authorizationInfo = request.getData();
				
				tryConnectToGameServer();
			}
			else
			{
				var req:EventDispatcher = DataProvider.getInstance().commitDebugAuthorizationInfo(_userData.id, AppGlobalVariables.SIMULATOR_EMAIL, AppGlobalVariables.SIMULATOR_PASS);
				req.addEventListener(Event.COMPLETE, handlerCommitInfoComplete);
			}
		}
		
		private function handlerCommitInfoComplete(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, handlerCommitInfoComplete);
			
			retrieveLoginPassInfo();
		}
		
		private function tryConnectToGameServer():void
		{
			_dataChannel = this.facade.retrieveProxy(ProxyList.CLIENT_DATA_CHANNEL) as IServerDataChannel;
			
			//_dataChannel.addLocalListener( ServerDataChannelLocalEvent.ACTIONS_QUEUE_CREATE, handlerQueueCreated);
			_dataChannel.addLocalListener( ServerDataChannelLocalEvent.CHANNEL_DATA, handlerQueueData);
			//_dataChannel.addLocalListener( ServerDataChannelLocalEvent.ACTIONS_QUEUE_COMPLETE, handlerQueueFinished);
			
			_serverProxy.debugLogin( _authorizationInfo.email, _authorizationInfo.pass);
		}
		
		
		private function handlerQueueCreated():void
		{
			
		}
		
		private function handlerQueueData(event:LocalEvent):void
		{
			if(event.event == ServerDataChannelLocalEvent.CHANNEL_DATA)
			{
				var data:ChannelData = event.data;
				
				if(data.type == ChannelDataType.AUTHORIZATION) 
				{
					var auth:AuthorizationData = data as AuthorizationData;
					
					if(auth.error)
					{
						tryCreateNewUserOnServer();
					}
					else
					{
						_authServerData = auth;
						_authorizationStatus.setServerAuthorizationData(auth);
						_authorizationStatus.dispatchEvent( new Event(Event.COMPLETE) );
					}
				}
			}
		}
		
		private function handlerQueueFinished():void
		{
			
		}
		
		private function tryCreateNewUserOnServer():void
		{
			_serverProxy.debugCreateNewUser(AppGlobalVariables.SIMULATOR_NAME, _authorizationInfo.email, _authorizationInfo.pass );
		}
	}
}