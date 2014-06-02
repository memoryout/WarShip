package game.application
{
	import flash.events.Event;
	
	import game.GameType;
	import game.application.commands.game.CreateNewGameCommand;
	import game.application.commands.game.UserShipsLocatedComlete;
	import game.application.commands.startup.ServerAuthorizationResult;
	import game.application.game.p_vs_p_net.GameVSPlayerNetProxy;
	import game.application.interfaces.IMainApplicationProxy;
	import game.application.interfaces.game.IGameProxy;
	import game.application.server.ServerConnectionProxyEvents;
	import game.core.GameCoreEvents;
	import game.core.GameCoreManager;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class MainApplicationProxy extends BaseProxy implements IMainApplicationProxy
	{
		private var _gameManager:				GameCoreManager;
		
		private var _currentGameProxy:			IGameProxy;
		
		public function MainApplicationProxy(proxyName:String)
		{
			super(proxyName);
			
			GameCoreManager;
			
			_gameManager = GameCoreManager.getInstance();
		}
		
		
		public function runApplication():void
		{
			this.facade.registerCommand(ServerConnectionProxyEvents.REQUEST_COMPLETE, ServerAuthorizationResult);
			this.facade.registerCommand(ApplicationCommands.CREATE_NEW_GAME, CreateNewGameCommand);
			this.facade.registerCommand(ApplicationCommands.USER_SHIPS_LOCATED_COMPLETE, UserShipsLocatedComlete);
		}
		
		
		public function createGame(type:uint):void
		{
			
			switch(type)
			{
				case GameType.P_VS_P_NET:
				{
					_currentGameProxy = new GameVSPlayerNetProxy(ProxyList.GAME_VS_PLAYER_NET)
					break;
				}
			}
			
			
			if(_currentGameProxy) this.facade.registerProxy( _currentGameProxy );
		}
		
		
		public function getCurrentGame():IGameProxy
		{
			return _currentGameProxy;
		}
		
		
		
		
		//------------------------------
		private function handlerGameAlreadyExist(e:Event):void
		{
			
		}
	}
}