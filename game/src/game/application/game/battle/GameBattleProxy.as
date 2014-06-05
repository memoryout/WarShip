package game.application.game.battle
{
	import game.application.ApplicationEvents;
	import game.application.BaseProxy;
	import game.application.ProxyList;
	import game.application.data.game.BattleField;
	import game.application.data.game.ShipData;
	
	public class GameBattleProxy extends BaseProxy
	{
		private var _userShips:			Vector.<ShipData>;
		private var _opponentShips:		Vector.<ShipData>;
		
		private var _userField:			BattleField;
		private var _opponentField:		BattleField;
		
		public function GameBattleProxy()
		{
			super(ProxyList.GAME_BATTLE_PROXY);
		}
		
		
		override public function onRegister():void
		{
			
		}
		
		
		public function init(fieldWidth:uint, fieldHeight:uint):void
		{
			
			_userField = new BattleField();
			_userField.init(fieldWidth, fieldHeight);
			
			_opponentField = new BattleField();
			_opponentField.init(fieldWidth, fieldHeight);
			
			
			this.sendNotification( ApplicationEvents.BUTTLE_PROXY_INIT_COMPLETE );
		}
		
		public function initUserShips(v:Vector.<ShipData>):void
		{
			_userShips = v;
		}
	}
}