package game.application.interfaces.server
{
	public interface IServerConnectionProxy
	{
		function connectToServer():void
		function signIn():void
		function getNetStatus():uint;
	}
}