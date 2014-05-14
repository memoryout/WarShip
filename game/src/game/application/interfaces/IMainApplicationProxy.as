package game.application.interfaces
{
	import game.core.IGameProxy;

	public interface IMainApplicationProxy
	{
		function runApplication():void;
		function createGame(type:uint):void;
		function getCurrentGame():IGameProxy;
	}
}