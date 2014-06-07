package game.application.game.battle
{
	public class GameBattleAction
	{
		private static var _ids:					uint = 0;
		
		public static const STATUS_CHANGED:			uint = _ids++;
		
		private var _type:			uint = uint.MAX_VALUE;
		
		public function GameBattleAction(type:uint)
		{
			_type = type;
		}
		
		public function get type():uint
		{
			return _type;
		}
	}
}