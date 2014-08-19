package game.application.interfaces.channel
{
	import flash.events.IEventDispatcher;
	
	import game.application.connection.ChannelData;
	import game.library.ILocalDispactherProxy;

	public interface IServerDataChannel extends ILocalDispactherProxy
	{
		function processRawData(data:Object):void;
		function pushData( data:ChannelData ):void;
		function sendData():void;		
	}
}