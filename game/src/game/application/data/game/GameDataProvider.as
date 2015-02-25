package game.application.data.game
{
	public class GameDataProvider
	{
		public var _user:			GamePlayerData = new GamePlayerData();
		public var _opponent:		GamePlayerData = new GamePlayerData();
		
		public var _userField:		BattleField = new BattleField();
		public var _opponentField:	BattleField = new BattleField();
		
		public var _userShips:		Vector.<ShipData> = new Vector.<ShipData>();
		public var _opponentShips:	Vector.<ShipData> = new Vector.<ShipData>();
		
		public function GameDataProvider()
		{
			
		}
		
		
		public function createNewGameSession():void
		{
			_user.clear();
			_opponent.clear();
			
			_userField.clear();
			_opponentField.clear();
			
			_userShips.length = 0;
			_opponentShips.length = 0;
		}
		
		public function set opponentShips(val:Vector.<ShipData>):void
		{
			_opponentShips = val;
		}
		
		public function get opponentShips():Vector.<ShipData>
		{
			return _opponentShips;
		}			
		
		public function set userShips(val:Vector.<ShipData>):void
		{
			_userShips = val;
		}
		
		public function get userShips():Vector.<ShipData>
		{
			return _userShips;
		}		
		
		public function set opponentField(val:BattleField):void
		{
			_opponentField = val;
		}
		
		public function get opponentField():BattleField
		{
			return _opponentField;
		}	
		
		public function set userField(val:BattleField):void
		{
			_userField = val;
		}
		
		public function get userField():BattleField
		{
			return _userField;
		}
		
		public function set opponent(val:GamePlayerData):void
		{
			_opponent = val;
		}
		
		public function get opponent():GamePlayerData
		{
			return _opponent;
		}
		
		public function set user(val:GamePlayerData):void
		{
			_user = val;
		}
		
		public function get user():GamePlayerData
		{
			return _user;
		}		
	}
}