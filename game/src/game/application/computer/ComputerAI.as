package game.application.computer
{
	import game.application.BaseProxy;
	import game.application.connection.ActionsQueueEvent;
	import game.application.interfaces.actions.IActionsQueue;

	public class ComputerAI extends BaseProxy
	{
		public static const PLAYER_ID:		String = "computer_id";
		
		private var _actionQueue:			IActionsQueue;
		
		public function ComputerAI()
		{
			super();
		}
		
		public function init():void
		{
			_actionQueue = this.facade.retrieveProxy( PLAYER_ID + "_action_queue" ) as IActionsQueue;
		}
	}
}