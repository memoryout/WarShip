package game.application.connection.data
{
	import game.application.connection.ChannelData;
	import game.application.connection.ChannelDataType;
	
	public class GameInfoData extends ChannelData
	{
		public var status:				int;
		
		public var gameTime:			Number;
		public var timeOut:				Number;
		
		public var userPoints:			uint;
		public var opponentPoints:		uint;
		
		public function GameInfoData()
		{
			super(ChannelDataType.GAME_STATUS_INFO);
		}
	}
}