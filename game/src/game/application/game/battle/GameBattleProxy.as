package game.application.game.battle
{
	import game.application.ApplicationEvents;
	import game.application.BaseProxy;
	import game.application.ProxyList;
	import game.application.data.game.BattleField;
	import game.application.data.game.ShipData;
	import game.application.interfaces.game.battle.IGameBattleProxy;
	
	public class GameBattleProxy extends BaseProxy implements IGameBattleProxy
	{
		private var _userShips:			Vector.<ShipData>;
		private var _opponentShips:		Vector.<ShipData>;
		
		private var _userField:			BattleField;
		private var _opponentField:		BattleField;
		
		private var _currentStatus:		uint;
		
		
		private const _actionList:		Vector.<GameBattleAction> = new Vector.<GameBattleAction>;
		
		public function GameBattleProxy()
		{
			super(ProxyList.GAME_BATTLE_PROXY);
		}
		
		
		override public function onRegister():void
		{
			this.sendNotification( ApplicationEvents.BUTTLE_PROXY_INIT_COMPLETE );
		}
		
		
		public function init(fieldWidth:uint, fieldHeight:uint):void
		{
			
			_userField = new BattleField();
			_userField.init(fieldWidth, fieldHeight);
			
			_opponentField = new BattleField();
			_opponentField.init(fieldWidth, fieldHeight);
		}
		
		public function initUserShips(v:Vector.<ShipData>):void
		{
			_userShips = v;
		}
		
		
		public function startDataUpdate():void
		{
			
		}
		
		
		public function finishDataUpdate():void
		{
			
		}
		
		
		public function setStatus(value:uint):void
		{
			if(_currentStatus != value)
			{
				var action:GameBattleAction = new GameBattleAction(GameBattleAction.STATUS_CHANGED);
				_actionList.push( action );
				
			}
			_currentStatus = value;
		}
		
		
		
		public function getStatus():uint
		{
			return _currentStatus;
		}
		
		
		public function getAction():GameBattleAction
		{
			return null;
		}
		
		
	}
}