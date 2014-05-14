package game.core
{
	import flash.events.EventDispatcher;
	
	import game.GameType;
	import game.core.bluetooth.BluetoothGameProxy;
	import game.core.computer.ComputerGameProxy;
	import game.core.data.GameInfo;
	import game.core.server.ServerGameProxy;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class GameCoreManager extends EventDispatcher
	{
		private static var _instance		:GameCoreManager = new GameCoreManager();
		
		private var _currentGame:			IGameProxy;
		
		public function GameCoreManager()
		{
			super();
		}
		
		
		public static function getInstance():GameCoreManager
		{
			return _instance;
		}
		
		
		public function init():void
		{
			
		}
		
		
		public function createGame(gameType:uint):IGameProxy
		{
			if(_currentGame)
			{
				return null;
			}
			
			switch(gameType)
			{
				case GameType.P_VS_C:
				{
					_currentGame = new ComputerGameProxy();
					break;
				}
					
				case GameType.P_VS_P_NET:
				{
					_currentGame = new ServerGameProxy();
					break;
				}
					
				case GameType.P_VS_P_BLUETOOTH:
				{
					_currentGame = new BluetoothGameProxy();
					break;
				}
			}
			
			return _currentGame;
		}
		
		
		public function getCurrentGame():IGameProxy
		{
			return _currentGame;
		}
		
		
		public function closeCurrentGame():void
		{
			_currentGame = null;
		}
	}
}