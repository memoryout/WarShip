package game.application.game.battle
{
	import flash.events.Event;
	
	import game.application.ApplicationEvents;
	import game.library.BaseProxy;
	import game.application.ProxyList;
	import game.application.connection.data.GameInfoData;
	import game.application.connection.data.OpponentInfoData;
	import game.application.connection.data.UserInfoData;
	import game.application.data.game.BattleField;
	import game.application.data.game.GamePlayerData;
	import game.application.data.game.ShipData;
	import game.application.data.game.ShipPositionPoint;
	import game.application.interfaces.game.battle.IGameBattleProxy;
	
	public class GameBattleProxy extends BaseProxy implements IGameBattleProxy
	{
		private var _userShips:			Vector.<ShipData>;
		private var _opponentShips:		Vector.<ShipData>;
		
		private var _userField:			BattleField;
		private var _opponentField:		BattleField;
		
		private var _currentStatus:		uint = uint.MAX_VALUE;
		
		
		private var _user:				GamePlayerData;
		private var _opponent:			GamePlayerData;
		
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
			
			_opponentShips = new Vector.<ShipData>;
		}
		
		public function initUserShips(v:Vector.<ShipData>):void
		{
			_userShips = v;
		}
		
		
		public function updateOpponentData(data:OpponentInfoData):void
		{
			if(!_opponent) _opponent = new GamePlayerData();
			
			if( _opponent.exp != data.exp )
			{
				_opponent.exp = data.exp;
				
				var action:GameBattleAction = new GameBattleAction(GameBattleAction.OPPONENT_EXP_UPDATED);
				action.setData( _opponent.exp);
				_actionList.push( action );
			}
		}
		
		public function updateUserData(data:UserInfoData):void
		{
			if(!_user) _user = new GamePlayerData();
			
			if( _user.exp != data.exp )
			{
				_user.exp = data.exp;
				
				var action:GameBattleAction = new GameBattleAction(GameBattleAction.USER_EXP_UPDATED);
				action.setData( _user.exp);
				_actionList.push( action );
			}
			
		}
		
		
		public function updateGameInfo(data:GameInfoData):void
		{
			var action:GameBattleAction;
			
			if(_user && _user.points != data.userPoints)
			{
				_user.points = data.userPoints;
				
				action = new GameBattleAction(GameBattleAction.USER_POINTS_UPDATED);
				action.setData( _user.points);
				_actionList.push( action );
			}
			
			
			if(_opponent && _opponent.points != data.opponentPoints)
			{
				_opponent.points = data.userPoints;
				
				action = new GameBattleAction(GameBattleAction.OPPONENT_POINTS_UPDATED);
				action.setData( _opponent.points);
				_actionList.push( action );
			}
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
			
			var v:Vector.<ShipPositionPoint> = _opponentField.pushShip( ship );
			
			var action:GameBattleAction = new GameBattleAction(GameBattleAction.USER_SANK_OPPONENTS_SHIP);
			action.setData( {ship:ship, fieldPoint:v} );
			_actionList.push( action );
		}
		
		
		public function opponentSankUserShip(ship:ShipData):void
		{
			var v:Vector.<ShipPositionPoint> = _userField.pushShip( ship );
			
			var action:GameBattleAction = new GameBattleAction(GameBattleAction.OPPONENT_SANK_USER_SHIP);
			action.setData( {ship:ship, fieldPoint:v} );
			_actionList.push( action );
		}
		
		public function isWaterCeil(x:int, y:int):Boolean
		{
			return _opponentField.isWaterCeil(x, y)
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
		
		public function getUserPlayerInfo():GamePlayerData
		{
			return _user;
		}
		
		public function getOpponentPlayerInfo():GamePlayerData
		{
			return _opponent;
		}
		
		
		public function destroy():void
		{
			if(_userField) _userField.destroy();
			if(_opponentField) _opponentField.destroy();
			
			_userShips = null;
			_opponentShips = null;
			_userField = null;
			_opponentField = null;
			_user = null;
			_opponent = null;
		}
		
	}
}