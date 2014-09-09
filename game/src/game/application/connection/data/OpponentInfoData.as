package game.application.connection.data
{
	import game.application.connection.ChannelData;
	import game.application.connection.ChannelDataType;
	
	public class OpponentInfoData extends ChannelData
	{
		public var exp:				Number;
		public var games_lose:		Number;
		public var games_won:		Number;
		public var rank:			int;
		public var ships_destroyed:	uint;
		public var name:			String;
		
		public function OpponentInfoData()
		{
			super(ChannelDataType.OPPONENT_INFO);
		}
	}
}