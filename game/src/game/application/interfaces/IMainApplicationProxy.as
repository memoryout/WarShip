package game.application.interfaces
{
	import game.application.interfaces.game.IGameProxy;

	public interface IMainApplicationProxy
	{
		function runApplication():void;
		function createGame(type:uint):void;
		function getCurrentGame():IGameProxy;
		function finishCurrentGame():void;
		function createUserProfilerWindow():void;
	}
}