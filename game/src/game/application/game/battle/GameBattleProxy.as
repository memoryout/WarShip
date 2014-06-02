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
		
		private var _battleField:		BattleField;
		
		public function GameBattleProxy()
		{
			super(ProxyList.GAME_BATTLE_PROXY);
		}
		
		
		override public function onRegister():void
		{
			
		}
		
		
		public function init(fieldWidth:uint, fieldHeight:uint):void
		{
			
			_battleField = new BattleField();
			_battleField.init(fieldWidth, fieldHeight);
			
			
			this.sendNotification( ApplicationEvents.BUTTLE_PROXY_INIT_COMPLETE );
		}
		
		public function initUserShips(v:Vector.<ShipData>):void
		{
			
		}
	}
}