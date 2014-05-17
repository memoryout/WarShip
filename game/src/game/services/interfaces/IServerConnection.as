package game.services.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IServerConnection extends IEventDispatcher
	{
		function initConnection(type:String, url:String, port:String = ""):void;
		
		function signIn(userId:String, name:String):void;
	}
}