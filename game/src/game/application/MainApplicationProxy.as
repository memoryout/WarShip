package game.application
{
	import flash.events.Event;
	
	import game.GameType;
	import game.application.commands.game.CreateNewGameCommand;
	import game.application.commands.game.CreateUserProfileCommand;
	import game.application.commands.game.FinishCurrentGameCommand;
	import game.application.commands.game.UserShipsLocatedComlete;
	import game.application.connection.ServerDataChannelEvent;
	import game.application.game.p_vs_computer.GameVSComputer;
	import game.application.game.p_vs_p_net.GameVSPlayerNetProxy;
	import game.application.interfaces.IMainApplicationProxy;
	import game.application.interfaces.game.IGameProxy;
	import game.application.interfaces.net.IServerConnectionProxy;
	import game.application.net.ServerConnectionProxyEvents;
	import game.application.net.ServerConnectionStatus;
	import game.library.BaseProxy;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class MainApplicationProxy extends BaseProxy implements IMainApplicationProxy
	{
		
		private var _currentGameProxy:			IGameProxy;
		
		public function MainApplicationProxy(proxyName:String)
		{
			super(proxyName);
			

		}
		
		
		public function runApplication():void
		{
			//this.facade.registerCommand(ServerDataChannelEvent.ACTIONS_QUEUE_COMPLETE, ServerAuthorizationResult);
			this.facade.registerCommand(ApplicationCommands.CREATE_PROFILER, CreateUserProfileCommand);
			this.facade.registerCommand(ApplicationCommands.CREATE_NEW_GAME, CreateNewGameCommand);
			this.facade.registerCommand(ApplicationCommands.USER_SHIPS_LOCATED_COMPLETE, UserShipsLocatedComlete);
			this.facade.registerCommand(ApplicationCommands.FINISH_CURRENT_GAME, FinishCurrentGameCommand);
		}
		
		
		public function createGame(type:uint):void
		{
			
			switch(type)
			{
				case GameType.P_VS_P_NET:
				{
					
					createGameVsPlayerByNet();
					break;
				}
					
				case GameType.P_VS_C:
				{
					createGameVsComputer();
					break;
				}
			}
			
			
			if(_currentGameProxy) this.facade.registerProxy( _currentGameProxy );
		}
		
		public function createUserProfilerWindow():void
		{
			if(_currentGameProxy)
			{
				_currentGameProxy.destroy();
				_currentGameProxy = null;
			}
			
			this.sendNotification( ApplicationEvents.SHOW_USER_PROFILER );
		}
		
		
		public function finishCurrentGame():void
		{
			if(_currentGameProxy)
			{
				_currentGameProxy.destroy();
				_currentGameProxy = null;
			}
			
			this.sendNotification( ApplicationEvents.GAME_CORE_READY_TO_START_GAME );
		}
		
		
		public function getCurrentGame():IGameProxy
		{
			return _currentGameProxy;
		}
		
		
		
		
		//------------------------------
		private function handlerGameAlreadyExist(e:Event):void
		{
			
		}
		
		
		
		private function createGameVsPlayerByNet():void
		{
			var serverProxy:IServerConnectionProxy = this.facade.retrieveProxy(ProxyList.SERVER_PROXY) as IServerConnectionProxy;
			
			if(serverProxy && serverProxy.getNetStatus() == ServerConnectionStatus.ENABLED)
			{
				_currentGameProxy = new GameVSPlayerNetProxy(ProxyList.GAME_VS_PLAYER_NET);
			}
			else
			{
				trace("server connection disabled");
			}
		}
		
		
		private function createGameVsComputer():void
		{
			_currentGameProxy = new GameVSComputer( ProxyList.GAME_VS_COMPUTER );
		}
	}
}