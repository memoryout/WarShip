package game.application
{
	import flash.events.Event;
	
	import game.application.interfaces.IMainApplicationProxy;
	import game.core.GameCoreEvents;
	import game.core.GameCoreManager;
	import game.core.IGameProxy;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class MainApplicationProxy extends ApplicationProxy implements IMainApplicationProxy
	{
		private var _gameManager:				GameCoreManager;
		
		public function MainApplicationProxy(proxyName:String)
		{
			super(proxyName);
			
			GameCoreManager;
			
			_gameManager = GameCoreManager.getInstance();
		}
		
		
		public function runApplication():void
		{
			
		}
		
		
		public function createGame(type:uint):void
		{
			_gameManager.createGame( type );
		}
		
		
		public function getCurrentGame():IGameProxy
		{
			return _gameManager.getCurrentGame();
		}
		
		
		
		
		//------------------------------
		private function handlerGameAlreadyExist(e:Event):void
		{
			
		}
	}
}