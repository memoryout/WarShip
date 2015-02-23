package game.application.data.game
{
	public class GameDataProvider
	{
		public const user:			GamePlayerData = new GamePlayerData();
		public const opponent:		GamePlayerData = new GamePlayerData();
		
		public const userField:		BattleField = new BattleField();
		public const opponentField:	BattleField = new BattleField();
		
		public const userShips:		Vector.<ShipData> = new Vector.<ShipData>();
		public const opponentShips:	Vector.<ShipData> = new Vector.<ShipData>();
		
		public function GameDataProvider()
		{
			
		}
		
		
		public function createNewGameSession():void
		{
			user.clear();
			opponent.clear();
			
			userField.clear();
			opponentField.clear();
			
			userShips.length = 0;
			opponentShips.length = 0;
		}
		
	}
}