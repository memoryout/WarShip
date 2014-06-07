package game.application.server.data
{
	import game.application.server.ServerResponceDataType;

	public class GameInfoResponce extends ResponceData
	{
		public var status:			int;
		
		public var opponentData:	OpponentData;
		public var hitInfo:			HitInfo;
		
		
		public function GameInfoResponce()
		{
			super();
		}
		
		override public function get responceDataType():String
		{
			return ServerResponceDataType.GAME_INFO;
		}
	}
}