package game.application.connection.actions
{
	import game.application.connection.ActionQueueData;
	import game.application.connection.ActionType;
	
	public class OpponentInfoData extends ActionQueueData
	{
		public var exp:				Number;
		public var games_lose:		Number;
		public var games_won:		Number;
		public var rank:			int;
		public var ships_destroyed:	uint;
		
		public function OpponentInfoData()
		{
			super(ActionType.OPPONENT_INFO);
		}
	}
}