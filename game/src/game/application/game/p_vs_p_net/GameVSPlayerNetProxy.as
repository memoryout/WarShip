package game.application.game.p_vs_p_net
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.application.ApplicationCommands;
	import game.application.ApplicationEvents;
	import game.application.BaseProxy;
	import game.application.ProxyList;
	import game.application.commands.game.UserInGameActionCommand;
	import game.application.commands.server.ServerRequestComplete;
	import game.application.data.NotificationType;
	import game.application.data.game.ShipData;
	import game.application.data.game.ShipPositionPoint;
	import game.application.game.MainGameProxy;
	import game.application.game.battle.GameBattleProxy;
	import game.application.game.battle.GameBattleStatus;
	import game.application.interfaces.game.p_vs_p_net.IGameVSPlayerNet;
	import game.application.server.ServerConnectionProxy;
	import game.application.server.ServerConnectionProxyEvents;
	import game.application.server.ServerResponce;
	import game.application.server.ServerResponceDataType;
	import game.application.server.data.GameInfoResponce;
	import game.application.server.data.HitInfo;
	import game.application.server.data.NotififactionData;
	import game.application.server.data.ResponceData;
	
	public class GameVSPlayerNetProxy extends MainGameProxy implements IGameVSPlayerNet
	{
		private const REPEAT_TIMEOUT:	uint = 10000;
		
		private const shipsDeckList:	Vector.<uint> = new <uint>[4, 3, 3, 2, 2, 2, 1, 1, 1, 1];
		
		private var _battleProxy:		GameBattleProxy;
		private var _serverProxy:		ServerConnectionProxy;
		
		private var _requestRepeatTimer:Timer;
		
		public function GameVSPlayerNetProxy(proxyName:String)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			super.generateShipList( shipsDeckList );
			
			this.sendNotification(ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS);
			
			this.facade.registerCommand(ServerConnectionProxyEvents.REQUEST_COMPLETE, ServerRequestComplete);
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
				arr.push( [ coords[0].y, coords[0].x] );
				arr.push( [ coords[coords.length - 1].y, coords[coords.length - 1].x] );
				
				ships.push( arr );
				
				// координаты записаны y-x порядке так как у сервера матрица сделана через ж...  х - смотрит вниз y - вправо. Жизнь боль.
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
			
			_serverProxy.sendHitPointPosition( y, x );
			
			startUpdateInfoTimer();
		}
		
		
		override public function receiveServerResponce(responce:ServerResponce):void
		{
			var dataList:Vector.<ResponceData> = responce.getDataList();
			var i:int;
			for(i = 0; i< dataList.length; i++)
			{
				switch(dataList[i].responceDataType)
				{
					case ServerResponceDataType.GAME_INFO:
					{
						updateGameInfo(dataList[i] as GameInfoResponce);
						break;
					}
				}
			}
		}
		
		
		private function updateGameInfo(data:GameInfoResponce):void
		{
			_battleProxy.startDataUpdate();
			
			
			if(data.hitInfo) processHitAction(data.hitInfo, true);
			if(data.notifications) processNotifications(data.notifications);
			
			
			
			switch(data.status)
			{
				case GameBattleStatus.WAITING_FOR_START:
				{
					startUpdateInfoTimer();
					
					_battleProxy.setStatus(GameBattleStatus.WAITING_FOR_START);
					break;
				}
					
				case GameBattleStatus.STEP_OF_OPPONENT:
				{
					if(_battleProxy.getStatus() == GameBattleStatus.WAITING_FOR_START && data.opponentData)
					{
						_battleProxy.initOpponentData( data.opponentData );
					}
									
					_battleProxy.setStatus(GameBattleStatus.STEP_OF_OPPONENT);
					
					startUpdateInfoTimer();
					
					break;
				}
				
				case GameBattleStatus.STEP_OF_INCOMING_USER:
				{
					_battleProxy.setStatus(GameBattleStatus.STEP_OF_INCOMING_USER);
					
					break;
				}
			}
			
			_battleProxy.finishDataUpdate();
		}
		
		
		private function processHitAction(data:HitInfo, user:Boolean):void
		{
			if(!user) _battleProxy.opponentMakeHit(data.pointX, data.pointY, data.status);
			else _battleProxy.userMakeHit(data.pointX, data.pointY, data.status);
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
		
		
		private function processNotifications(v:Vector.<NotififactionData>):void
		{
			var i:int;
			for(i = 0; i < v.length; i++)
			{
				switch(v[i].type)
				{
					case NotificationType.HIT:
					{
						_battleProxy.opponentMakeHit(v[i].data.target[1], v[i].data.target[0], v[i].data.status);
						break;
					}
				}
			}
		}
	}
}