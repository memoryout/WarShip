package game.application.game.battle
{
	public class GameBattleAction
	{
		private static var _ids:					uint = 0;
		
		public static const STATUS_CHANGED:				uint = _ids++;
		public static const OPPONENT_MAKE_HIT:			uint = _ids++;
		public static const USER_MAKE_HIT:				uint = _ids++;
		public static const USER_SANK_OPPONENTS_SHIP:	uint = _ids++;
		public static const OPPONENT_SANK_USER_SHIP:	uint = _ids++;
		
		
		public static const USER_EXP_UPDATED:			uint = _ids++;
		public static const USER_POINTS_UPDATED:		uint = _ids++;
		
		public static const OPPONENT_EXP_UPDATED:		uint = _ids++;
		public static const OPPONENT_POINTS_UPDATED:	uint = _ids++;
		
		
		private var _type:			uint = uint.MAX_VALUE;
		private var _data:			Object;
		
		public function GameBattleAction(type:uint)
		{
			_type = type;
		}
		
		public function get type():uint
		{
			return _type;
		}
		
		
		public function setData(data:Object):void
		{
			_data = data;
		}
		
		public function getData():Object
		{
			return _data;
		}
	}
}