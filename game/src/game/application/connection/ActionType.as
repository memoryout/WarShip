package game.application.connection
{
	public class ActionType
	{
		private static var _globalId:					uint = 0;
		
		public static const AUTHORIZATION:				uint = _globalId ++;
		public static const GAME_STATUS_INFO:			uint = _globalId ++;
		public static const OPPONENT_INFO:				uint = _globalId ++;
		public static const USER_INFO:					uint = _globalId ++;
		public static const USER_GAME_INFO:				uint = _globalId ++;
		public static const USER_HIT_INFO:				uint = _globalId ++;
		public static const OPPONENT_HIT_INFO:			uint = _globalId ++;
		public static const USER_DESTROY_OPPONENT_SHIP:	uint = _globalId ++;
		public static const OPPONENT_DESTROY_USER_SHIP:	uint = _globalId ++;
		
		public static const GAME_FINISHED:				uint = _globalId ++;
		
		public static const ERROR:						uint = _globalId ++;
	}
}