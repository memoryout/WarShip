package game.application.data.game
{
	public class GamePlayerData
	{
		public var exp:		Number = 0;
		public var points:	uint = 0;
		public var name:	String;
		
		public function GamePlayerData()
		{
			
		}
		
		public function clear():void
		{
			exp = 0;
			points = 0;
			name = null;
		}
	}
}