package game.application.connection.actions
{
	import game.application.connection.ActionQueueData;
	import game.application.connection.ActionType;
	
	public class GameInfoData extends ActionQueueData
	{
		public var status:				int;
		
		public var gameTime:			Number;
		public var timeOut:				Number;
		
		public var userPoints:			uint;
		public var opponentPoints:		uint;
		
		public function GameInfoData()
		{
			super(ActionType.GAME_STATUS_INFO);
		}
	}
}