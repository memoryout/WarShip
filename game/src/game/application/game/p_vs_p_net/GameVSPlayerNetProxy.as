package game.application.game.p_vs_p_net
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.GameType;
	import game.application.ApplicationCommands;
	import game.application.ApplicationEvents;
	import game.application.ProxyList;
	import game.application.commands.game.UserInGameActionCommand;
	import game.application.connection.ChannelData;
	import game.application.connection.ChannelDataType;
	import game.application.connection.ServerDataChannelEvent;
	import game.application.connection.ServerDataChannelLocalEvent;
	import game.application.connection.data.DestroyShipData;
	import game.application.connection.data.GameInfoData;
	import game.application.connection.data.HitInfoData;
	import game.application.connection.data.OpponentInfoData;
	import game.application.connection.data.UserInfoData;
	import game.application.data.NotificationType;
	import game.application.data.game.ShipData;
	import game.application.data.game.ShipDirrection;
	import game.application.data.game.ShipPositionPoint;
	import game.application.game.MainGameProxy;
	import game.application.game.battle.GameBattleProxy;
	import game.application.game.battle.GameBattleStatus;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.application.interfaces.game.p_vs_p_net.IGameVSPlayerNet;
	import game.application.net.ServerConnectionProxy;
	import game.application.net.ServerConnectionProxyEvents;
	import game.application.net.ServerResponceDataType;
	import game.library.BaseProxy;
	import game.library.LocalEvent;
	import game.utils.ShipPositionSupport;
	
	public class GameVSPlayerNetProxy extends MainGameProxy implements IGameVSPlayerNet
	{
		private const REPEAT_TIMEOUT:	uint = 3000;
		
		private const shipsDeckList:	Vector.<uint> = new <uint>[4, 3, 3, 2, 2, 2, 1, 1, 1, 1];
		
		private var _battleProxy:		GameBattleProxy;
		private var _serverProxy:		ServerConnectionProxy;
		private var _dataChannel:		IServerDataChannel;
		
		private var _requestRepeatTimer:Timer;
		
		public function GameVSPlayerNetProxy(proxyName:String)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			super.generateShipList( shipsDeckList );
			
			_dataChannel = this.facade.retrieveProxy(ProxyList.CLIENT_DATA_CHANNEL) as IServerDataChannel;
			
			this.sendNotification(ApplicationEvents.GAME_CONTEXT_CREATE_COMPLETE, GameType.P_VS_P_NET);
			
			this.sendNotification(ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS);
			
			_dataChannel.addLocalListener(ServerDataChannelLocalEvent.ACTIONS_QUEUE_CREATE, actionsQueueStart);
			_dataChannel.addLocalListener(ServerDataChannelLocalEvent.CHANNEL_DATA, processActionsQueue);
			_dataChannel.addLocalListener(ServerDataChannelLocalEvent.ACTIONS_QUEUE_COMPLETE, actionsQueueFinish);
			
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
			if( _battleProxy.isWaterCeil(x, y) )
			{
				_battleProxy.setStatus(GameBattleStatus.WAITINIG_GAME_ANSWER);
				_battleProxy.finishDataUpdate();
				
				_serverProxy.sendHitPointPosition( x, y );
				
				startUpdateInfoTimer();
			}
			else
			{
				this.log("hit error point x=" + x.toString() + " y=" + y.toString() ); 
			}
		}
		
		private function actionsQueueStart(dataMessage:LocalEvent):void
		{
			_battleProxy.startDataUpdate();
		}
		
		
		public function processActionsQueue(dataMessage:LocalEvent):void
		{
			
			//_battleProxy.startDataUpdate();
			
			var action:ChannelData;
			
			action = dataMessage.data as ChannelData//_actionsQueue.getNextAction();
			
			switch(action.type)
			{
				case ChannelDataType.GAME_STATUS_INFO:
				{
					updateGameStatusInfo(action as GameInfoData);
					break;
				}
					
				case ChannelDataType.OPPONENT_INFO:
				{
					updateOpponentData(action as OpponentInfoData);
					break;
				}
					
				case ChannelDataType.USER_INFO:
				{
					updateUserData(action as UserInfoData);
					break;
				}
					
				case ChannelDataType.OPPONENT_HIT_INFO:
				{
					parseOpponentHitInfo(action as HitInfoData);
					break;
				}
						
				case ChannelDataType.OPPONENT_DESTROY_USER_SHIP:
				{
					parseOpponentDestroyUserShipAction(action as DestroyShipData);
					break;
				}
					
				case ChannelDataType.USER_HIT_INFO:
				{
					parseUserHitInfo(action as HitInfoData);
					break;
				}
				
				case ChannelDataType.USER_DESTROY_OPPONENT_SHIP:
				{
					parseUserDestroyOpponentShipAction(action as DestroyShipData);
					break;
				}	
			}
			
			//_battleProxy.finishDataUpdate();
		}
		
		private function actionsQueueFinish(dataMessage:LocalEvent):void
		{
			_battleProxy.finishDataUpdate();
		}
		
		
		private function updateGameStatusInfo(action:GameInfoData):void
		{
			_battleProxy.updateGameInfo( action );
			
			switch(action.status)
			{
				case GameBattleStatus.STEP_OF_OPPONENT:
				{
					startUpdateInfoTimer();
					_battleProxy.setStatus(GameBattleStatus.STEP_OF_OPPONENT);
					break;
				}
				case GameBattleStatus.WAITING_FOR_START:
				{
					startUpdateInfoTimer();
					_battleProxy.setStatus(GameBattleStatus.WAITING_FOR_START);
					break;
				}
					
				case GameBattleStatus.STEP_OF_INCOMING_USER:
				{
					_battleProxy.setStatus(GameBattleStatus.STEP_OF_INCOMING_USER);
					break;
				}
					
				case GameBattleStatus.INCOMING_USER_WON:
				{
					stopUpdateTimer();
					_battleProxy.setStatus(GameBattleStatus.INCOMING_USER_WON);
					this.sendNotification( ApplicationCommands.FINISH_CURRENT_GAME);
					break;
				}
					
				case GameBattleStatus.OPPONENT_WON:
				{
					stopUpdateTimer();
					_battleProxy.setStatus(GameBattleStatus.OPPONENT_WON);
					this.sendNotification( ApplicationCommands.FINISH_CURRENT_GAME);
					break;
				}
			}
		}
		
		
		private function updateOpponentData(action:OpponentInfoData):void
		{
			_battleProxy.updateOpponentData( action );
		}
		
		
		private function updateUserData(action:UserInfoData):void
		{
			_battleProxy.updateUserData( action );
		}
		
		
		
		
		private function parseOpponentHitInfo(action:HitInfoData):void
		{
			_battleProxy.opponentMakeHit(action.pointX, action.pointY, action.status);
		}
		
		private function parseOpponentDestroyUserShipAction(action:DestroyShipData):void
		{
			var shipData:ShipData = ShipPositionSupport.getInstance().getShipByStartPosition(action.startX, action.startY, shipsList);
			
			_battleProxy.opponentSankUserShip(shipData);
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
		
		private function stopUpdateTimer():void
		{
			if(_requestRepeatTimer) 
			{
				_requestRepeatTimer.stop();
				_requestRepeatTimer.removeEventListener(TimerEvent.TIMER, handlerUpdateInfoTimer);	
			}
			
			_requestRepeatTimer = null;
		}
		
		
		private function handlerUpdateInfoTimer(e:TimerEvent):void
		{
			_requestRepeatTimer.stop();
			
			_serverProxy.getGameUpdate();
		}
		
		
		
		override public function destroy():void
		{
			stopUpdateTimer();
			
			if(_dataChannel)
			{
				_dataChannel.removeLocalListener(ServerDataChannelLocalEvent.CHANNEL_DATA, processActionsQueue);
			}
			
			this.facade.removeCommand(ApplicationCommands.USER_HIT_POINT);
			this.facade.removeProxy( this.proxyName );
			 
		}
	}
}