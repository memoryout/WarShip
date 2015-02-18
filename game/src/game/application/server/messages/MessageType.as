package game.application.server.messages
{
	public class MessageType
	{
		public static const WAITING_FOR_PLAYER_SHIPS_LOCATION:			uint = 1;
		public static const SET_ACTIVE_PLAYER:							uint = 2;
		public static const PLAYER_MAKE_SHOOT:							uint = 3;
		public static const PLAYER_HIT_SHIP:							uint = 4;
		public static const PLAYER_SANK_SHIP:							uint = 5;
		public static const PLAYER_MISSED:								uint = 6;
		
		public static const FINISH_GAME:								uint = 7;
		public static const START_GAME:									uint = 8;
	}
}