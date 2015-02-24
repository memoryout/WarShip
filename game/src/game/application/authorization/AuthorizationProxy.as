package game.application.authorization
{
	import com.milkmangames.nativeextensions.GoogleGames;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	
	import game.AppGlobalVariables;
	import game.application.ProxyList;
	import game.application.authorization.service.DebugAuthorizationSystem;
	import game.application.authorization.service.GoogleAuthorizationSystem;
	import game.application.authorization.service.IAuthorizationService;
	import game.application.connection.data.UserInfo;
	import game.application.data.DataProvider;
	import game.application.data.user.UserData;
	import game.application.interfaces.net.IServerConnectionProxy;
	import game.library.BaseProxy;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AuthorizationProxy extends BaseProxy
	{
		private const _authorizationInfo:		AuthorizationInfo = new AuthorizationInfo();
		
		private var _service:			IAuthorizationService;
		
		private var _server:			IServerConnectionProxy;
		
		public function AuthorizationProxy()
		{
			super(ProxyList.AUTHORIZATION_PROXY);
		}
		
		override public function onRegister():void
		{
			
			initializeAuthorization();
		}
		
		private function initializeAuthorization():void
		{
			_server = this.facade.retrieveProxy(ProxyList.SERVER_PROXY) as IServerConnectionProxy;
			_server.connectToServer();
			
			defineTargetPlatform();
		}
		
		private function defineTargetPlatform():void
		{
			if(GoogleGames.isSupported())
			{
				trace("GOOGLE");
				_service = new GoogleAuthorizationSystem();
				
			}else if(AppGlobalVariables.TARGET_PLATFORM == AppGlobalVariables.SIMULATOR)
			{
				trace("SIMULATOR");
				_service = new DebugAuthorizationSystem();
			}
			
			/*switch(AppGlobalVariables.TARGET_PLATFORM)
			{
				case AppGlobalVariables.SIMULATOR:
				{
					_service = new DebugAuthorizationSystem();
					
					trace("SIMULATOR");
					break;
				}
					
				case AppGlobalVariables.GOOGLE:
				{
					trace("GOOGLE");
					
					GoogleGames.create();
					GoogleGames.games.signIn();
					break;
				}
			}*/
			
			if(_service) 
			{
				this.facade.registerProxy(_service);
				_service.getAuthorizationState().addEventListener(Event.COMPLETE, handlerInfoComplete);
				_service.getAuthorizationState().addEventListener(AuthorizationEvent.FAILED, handlerAuthorizationFailed);
			}
		}
		
		private function handlerInfoComplete(e:Event):void
		{
			_service.getAuthorizationState().removeEventListener(Event.COMPLETE, handlerInfoComplete);
			_service.getAuthorizationState().addEventListener(AuthorizationEvent.FAILED, handlerAuthorizationFailed);
			
			if( _service.getAuthorizationState().getServerData() )
			{
				_server.setSessionKey( _service.getAuthorizationState().getServerData().session );
				
				updateUserInfo( _service.getAuthorizationState().getServerData().userInfo );
			}
			
			this.dispacther.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		private function handlerAuthorizationFailed(e:Event):void
		{
			_service.getAuthorizationState().addEventListener(Event.COMPLETE, handlerInfoComplete);
			_service.getAuthorizationState().addEventListener(AuthorizationEvent.FAILED, handlerAuthorizationFailed);
			
			retrieveUser();
		}
		
		
		private function retrieveUser():void
		{
			var userData:UserData = DataProvider.getInstance().getUserDataProvider().getUserInfo();
			
			if(userData)
			{
				this.dispacther.dispatchEvent( new Event(Event.COMPLETE) );
			}
			else
			{
				userData = DataProvider.getInstance().getUserDataProvider().createNewUser();
				userData.targetPlatform = AppGlobalVariables.GOOGLE;
				
				var request:EventDispatcher = DataProvider.getInstance().getUserDataProvider().commitNewUser();
				request.addEventListener(Event.COMPLETE, handlerNewUserCreated);
			}
		}
		
		private function handlerNewUserCreated(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, handlerNewUserCreated);
			
			var request:EventDispatcher = DataProvider.getInstance().getUserDataProvider().retrieveUserInfo();
			request.addEventListener(Event.COMPLETE, handlerUserInfo);
		}
		
		private function handlerUserInfo(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, handlerUserInfo);
			
			retrieveUser();
		}
		
		
		private function updateUserInfo(user:UserInfo):void
		{
			var userData:UserData = DataProvider.getInstance().getUserDataProvider().getUserInfo();
			userData.exp = user.expInfo.experience;
			userData.name = user.name;
		}
	}
}