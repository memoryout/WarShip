package game.application.interfaces.actions
{
	import flash.events.IEventDispatcher;
	
	import game.application.connection.ActionQueueData;

	public interface IActionsQueue
	{
		function startQueue():void;
		function parseRowData(data:Object):void;
		function finishQueue():void;
		function getNextAction():ActionQueueData;
		function get dispatcher():IEventDispatcher;
	}
}