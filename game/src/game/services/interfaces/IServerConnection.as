package game.services.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IServerConnection extends IEventDispatcher
	{
		function initConnection(type:String, url:String, port:String = ""):void;
		
		function setSessionKey(session:String):void
		function createUser(name:String, login:String, pass:String):void;
		function signIn(login:String, pass:String):void;
		function signInGoogle(authToken:String):void;		
		function sendShipLocation(ships:Array):void;
		function getGameUpdate():void;
		function sendHitPointPosition(x:uint, y:uint):void;
	}
}