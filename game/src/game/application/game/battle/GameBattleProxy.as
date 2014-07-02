package game.application.game.battle
{
	import flash.events.Event;
	
	import game.application.ApplicationEvents;
	import game.application.BaseProxy;
	import game.application.ProxyList;
	import game.application.data.game.BattleField;
	import game.application.data.game.ShipData;
	import game.application.interfaces.game.battle.IGameBattleProxy;
	import game.application.server.data.OpponentData;
	
	public class GameBattleProxy extends BaseProxy implements IGameBattleProxy
	{
		private var _userShips:			Vector.<ShipData>;
		private var _opponentShips:		Vector.<ShipData>;
		
		private var _userField:			BattleField;
		private var _opponentField:		BattleField;
		
		private var _currentStatus:		uint = uint.MAX_VALUE;
		
		
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
		
		
		public function initOpponentData(data:OpponentData):void
		{
			
		}
		
		
		public function opponentMakeHit(x:uint, y:uint, result:uint):void
		{
			var action:GameBattleAction = new GameBattleAction(GameBattleAction.OPPONENT_MAKE_HIT);
			action.setData( {x:x, y:y, result:result} );
			_actionList.push( action );
			
			_userField.setHit(x, y, result);
		}
		
		
		public function userMakeHit(x:uint, y:uint, result:uint):void
		{
			_opponentField.setHit( x, y, result );
			
			var action:GameBattleAction = new GameBattleAction(GameBattleAction.USER_MAKE_HIT);
			action.setData( {x:x, y:y, result:result} );
			_actionList.push( action );
		}
		
		
		public function userSankOpponentsShip(ship:ShipData):void
		{
			_opponentShips.push( ship );
			
			_opponentField.pushShip( ship );
			
			var action:GameBattleAction = new GameBattleAction(GameBattleAction.USER_SANK_OPPONENTS_SHIP);
			action.setData( ship );
			_actionList.push( action );
		}
		
		
		public function startDataUpdate():void
		{
			
		}
		
		
		public function finishDataUpdate():void
		{
			this.dispacther.dispatchEvent( new Event(GameBattleEvent.GAME_UPDATED) );
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
			return _actionList.shift();
		}
		
		
	}
}