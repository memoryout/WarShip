package game.application.authorization.service
{
	import com.milkmangames.nativeextensions.GoogleGames;
	import com.milkmangames.nativeextensions.events.GoogleGamesEvent;
	
	import game.application.ProxyList;
	import game.application.authorization.AuthorizationInfo;
	import game.application.connection.ChannelData;
	import game.application.connection.ChannelDataType;
	import game.application.connection.ServerDataChannelLocalEvent;
	import game.application.connection.data.AuthorizationData;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.application.interfaces.net.IServerConnectionProxy;
	import game.library.BaseProxy;
	import game.library.LocalEvent;
	
	public class GoogleAuthorizationSystem extends BaseProxy implements IAuthorizationService
	{
		private var _serverProxy:		IServerConnectionProxy;
		
		private var _authorizationStatus:AuthorizationInfo;
		private var _dataChannel:		IServerDataChannel;
		
		
		public function GoogleAuthorizationSystem(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
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
			GoogleGames.create();
			GoogleGames.games.signIn();
			
			GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, 	onSignedIn);
			GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_FAILED, 	onGamesError);
			GoogleGames.games.addEventListener(GoogleGamesEvent.SIGNED_OUT, 		onSignedOut);
		}
		
		/** Signed In */
		private function onSignedIn(e:GoogleGamesEvent):void
		{
			trace("Player signed in! : "+GoogleGames.games.getCurrentPlayerId()+"["+GoogleGames.games.getCurrentPlayerName()+"]");
			
			_dataChannel = this.facade.retrieveProxy(ProxyList.CLIENT_DATA_CHANNEL) as IServerDataChannel;
			
			_dataChannel.addLocalListener( ServerDataChannelLocalEvent.CHANNEL_DATA, handlerQueueData);
			
			GoogleGames.games.loadAuthToken();
			
			GoogleGames.games.addEventListener(GoogleGamesEvent.LOAD_AUTH_TOKEN_SUCCEEDED, 	onAuthLoaded);
			GoogleGames.games.addEventListener(GoogleGamesEvent.LOAD_AUTH_TOKEN_FAILED, 	onAuthFailed);
		}
		
		private function onAuthFailed(e:GoogleGamesEvent):void
		{
			trace("a");
		}
		
		private function onAuthLoaded(e:GoogleGamesEvent):void
		{
			trace("onAuthLoaded", e.token);
			_serverProxy.signInGoogle(e.token);
		}
		
		/** On Games Error */
		private function onGamesError(e:GoogleGamesEvent):void
		{
			trace("ERROR: "+e.type+": "+e.failureReason);
		}
		
		/** Signed Out */
		private function onSignedOut(e:GoogleGamesEvent):void
		{
			trace("Player signed out!");
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
						
					}
					else
					{
						
					}
				}
			}
		}
	}
}