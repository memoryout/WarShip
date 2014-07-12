package game.application.game.p_vs_p_net
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.application.ApplicationCommands;
	import game.application.ApplicationEvents;
	import game.application.BaseProxy;
	import game.application.ProxyList;
	import game.application.commands.game.ActionQueueComplete;
	import game.application.commands.game.UserInGameActionCommand;
	import game.application.connection.ActionQueueData;
	import game.application.connection.ActionType;
	import game.application.connection.ActionsQueueEvent;
	import game.application.connection.actions.DestroyShipData;
	import game.application.connection.actions.GameInfoData;
	import game.application.connection.actions.HitInfoData;
	import game.application.connection.actions.OpponentInfoData;
	import game.application.connection.actions.UserInfoData;
	import game.application.data.NotificationType;
	import game.application.data.game.ShipData;
	import game.application.data.game.ShipDirrection;
	import game.application.data.game.ShipPositionPoint;
	import game.application.game.MainGameProxy;
	import game.application.game.battle.GameBattleProxy;
	import game.application.game.battle.GameBattleStatus;
	import game.application.interfaces.actions.IActionsQueue;
	import game.application.interfaces.game.p_vs_p_net.IGameVSPlayerNet;
	import game.application.server.ServerConnectionProxy;
	import game.application.server.ServerConnectionProxyEvents;
	import game.application.server.ServerResponceDataType;
	
	public class GameVSPlayerNetProxy extends MainGameProxy implements IGameVSPlayerNet
	{
		private const REPEAT_TIMEOUT:	uint = 3000;
		
		private const shipsDeckList:	Vector.<uint> = new <uint>[4, 3, 3, 2, 2, 2, 1, 1, 1, 1];
		
		private var _battleProxy:		GameBattleProxy;
		private var _serverProxy:		ServerConnectionProxy;
		private var _actionsQueue:		IActionsQueue;
		
		private var _requestRepeatTimer:Timer;
		
		public function GameVSPlayerNetProxy(proxyName:String)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			super.generateShipList( shipsDeckList );
			
			_actionsQueue = this.facade.retrieveProxy(ProxyList.ACTIONS_QUEUE_PROXY) as IActionsQueue;
			
			this.sendNotification(ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS);
			
			this.facade.registerCommand(ActionsQueueEvent.ACTIONS_QUEUE_COMPLETE, ActionQueueComplete);
			this.facade.registerCommand(ApplicationCommands.USER_HIT_POINT, UserInGameActionCommand);
		}		
		
		
		override public function userLocatedShips():void
		{
			var i:int, coords:Vector.<ShipPositionPoint>;
			var ships:Array = [];
			var arr:Array;
			for(i = 0; i < shipsList.length; i++)
			{
				coords = shipsList[i].coopdinates;
				
				arr = [];
				arr.push( [ coords[0].x, coords[0].y] );
				arr.push( [ coords[coords.length - 1].x, coords[coords.length - 1].y] );
				
				ships.push( arr );
			}
			
			
			_serverProxy = this.facade.retrieveProxy(ProxyList.SERVER_PROXY) as ServerConnectionProxy;
			_serverProxy.sendUserShipLocation( ships );
			
			createGameBattleProxy();
			
			
			_battleProxy.setStatus(GameBattleStatus.WAITING_FOR_START);
			_battleProxy.finishDataUpdate();
		}
		
		
		override public function hitPoint(x:uint, y:uint):void
		{
			_battleProxy.setStatus(GameBattleStatus.WAITINIG_GAME_ANSWER);
			_battleProxy.finishDataUpdate();
			
			_serverProxy.sendHitPointPosition( x, y );
			
			startUpdateInfoTimer();
		}
		
		
		override public function processActionsQueue():void
		{
			
			_battleProxy.startDataUpdate();
			
			var action:ActionQueueData;
			
			action = _actionsQueue.getNextAction();
			
			while(action)
			{
				switch(action.type)
				{
					case ActionType.GAME_STATUS_INFO:
					{
						updateGameStatusInfo(action as GameInfoData);
						break;
					}
						
					case ActionType.OPPONENT_INFO:
					{
						updateOpponentData(action as OpponentInfoData);
						break;
					}
						
					case ActionType.USER_INFO:
					{
						updateUserData(action as UserInfoData);
						break;
					}
						
					case ActionType.OPPONENT_HIT_INFO:
					{
						parseOpponentHitInfo(action as HitInfoData);
						break;
					}
						
					case ActionType.OPPONENT_DESTROY_USER_SHIP:
					{
						parseOpponentDestroyUserShipAction(action as DestroyShipData);
						break;
					}
						
					case ActionType.USER_HIT_INFO:
					{
						parseUserHitInfo(action as HitInfoData);
						break;
					}
						
					case ActionType.USER_DESTROY_OPPONENT_SHIP:
					{
						parseUserDestroyOpponentShipAction(action as DestroyShipData);
						break;
					}	
				}
				
				action = _actionsQueue.getNextAction();
			}
			
			_battleProxy.finishDataUpdate();
		}
		
		
		private function updateGameStatusInfo(action:GameInfoData):void
		{
			switch(action.status)
			{
				case GameBattleStatus.STEP_OF_OPPONENT:
				case GameBattleStatus.WAITING_FOR_START:
				{
					startUpdateInfoTimer();
					_battleProxy.setStatus(GameBattleStatus.WAITING_FOR_START);
				}
					
				case GameBattleStatus.STEP_OF_INCOMING_USER:
				{
					_battleProxy.setStatus(GameBattleStatus.STEP_OF_INCOMING_USER);
					break;
				}
			}
		}
		
		
		private function updateOpponentData(action:OpponentInfoData):void
		{
			_battleProxy.initOpponentData( action );
		}
		
		
		private function updateUserData(action:UserInfoData):void
		{
			
		}
		
		
		private function parseOpponentHitInfo(action:HitInfoData):void
		{
			_battleProxy.opponentMakeHit(action.pointX, action.pointY, action.status);
		}
		
		private function parseOpponentDestroyUserShipAction(action:DestroyShipData):void
		{
			var shipData:ShipData = new ShipData();
			shipData.x = action.startX;
			shipData.y = action.startY;
			shipData.deck = action.decks;
			
			if(action.startX != action.finishX) shipData.dirrection = ShipDirrection.HORIZONTAL;
			else shipData.dirrection = ShipDirrection.VERTICAL;
			
			//_battleProxy.userSankOpponentsShip(shipData);
		}
		
		private function parseUserHitInfo(action:HitInfoData):void
		{
			_battleProxy.userMakeHit(action.pointX, action.pointY, action.status);
		}
		
		private function parseUserDestroyOpponentShipAction(action:DestroyShipData):void
		{
			var shipData:ShipData = new ShipData();
			shipData.x = action.startX;
			shipData.y = action.startY;
			shipData.deck = action.decks;
			
			if(action.startX != action.finishX) shipData.dirrection = ShipDirrection.HORIZONTAL;
			else shipData.dirrection = ShipDirrection.VERTICAL;
			
			_battleProxy.userSankOpponentsShip(shipData);
		}
		
		
		private function createGameBattleProxy():void
		{
			_battleProxy = new GameBattleProxy()
			this.facade.registerProxy( _battleProxy );
			
			_battleProxy.init(10, 10);
			_battleProxy.initUserShips( shipsList );
		}
		
		
		
		private function startUpdateInfoTimer():void
		{
			if(!_requestRepeatTimer)
			{
				_requestRepeatTimer = new Timer(REPEAT_TIMEOUT);
				_requestRepeatTimer.addEventListener(TimerEvent.TIMER, handlerUpdateInfoTimer);
			}
			else
			{
				_requestRepeatTimer.reset();
			}
			
			_requestRepeatTimer.start();
		}
		
		
		private function handlerUpdateInfoTimer(e:TimerEvent):void
		{
			_requestRepeatTimer.stop();
			
			_serverProxy.getGameUpdate();
		}
	}
}