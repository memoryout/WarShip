package game.application.interfaces.net
{
	public interface IServerConnectionProxy
	{
		function connectToServer():void
		function signIn():void
		function signInGoogle(authToken:String):void;		
		function getNetStatus():uint;
		function sendHitPointPosition(x:uint, y:uint):void;
		
		function setSessionKey(session:String):void;
		
		function debugLogin(login:String, pass:String):void;
		function debugCreateNewUser(name:String, login:String, pass:String):void;
	}
}