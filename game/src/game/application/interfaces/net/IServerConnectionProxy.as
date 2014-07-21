package game.application.interfaces.net
{
	public interface IServerConnectionProxy
	{
		function connectToServer():void
		function signIn():void
		function getNetStatus():uint;
		function sendHitPointPosition(x:uint, y:uint):void;
	}
}