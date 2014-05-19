package game.services.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IServerConnection extends IEventDispatcher
	{
		function initConnection(type:String, url:String, port:String = ""):void;
		
		function setSessionKey(session:String):void
		function createUser(userId:String, name:String):void;
		function signIn(login:String, pass:String):void;
	}
}