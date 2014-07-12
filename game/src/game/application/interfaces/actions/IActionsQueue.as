package game.application.interfaces.actions
{
	import game.application.connection.ActionQueueData;

	public interface IActionsQueue
	{
		function startQueue():void;
		function parseRowData(data:Object):void;
		function finishQueue():void;
		function getNextAction():ActionQueueData;
	}
}