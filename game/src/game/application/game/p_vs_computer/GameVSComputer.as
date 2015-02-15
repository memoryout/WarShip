package game.application.game.p_vs_computer
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.GameType;
	import game.application.ApplicationCommands;
	import game.application.ApplicationEvents;
	import game.application.ProxyList;
	import game.application.commands.game.SetDifficulLevelCommand;
	import game.application.commands.game.UserInGameActionCommand;
	import game.application.computer.ComputerAI;
	import game.application.connection.ChannelData;
	import game.application.connection.ChannelDataType;
	import game.application.connection.ServerDataChannelEvent;
	import game.application.connection.ServerDataChannelLocalEvent;
	import game.application.connection.data.DestroyShipData;
	import game.application.connection.data.GameInfoData;
	import game.application.connection.data.HitInfoData;
	import game.application.connection.data.OpponentInfoData;
	import game.application.connection.data.UserInfoData;
	import game.application.data.DataProvider;
	import game.application.data.game.ShipData;
	import game.application.data.game.ShipDirrection;
	import game.application.data.game.ShipPositionPoint;
	import game.application.game.MainGameProxy;
	import game.application.game.battle.GameBattleProxy;
	import game.application.game.battle.GameBattleStatus;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.application.interfaces.data.IUserDataProxy;
	import game.application.interfaces.server.ILocalGameServer;
	import game.library.LocalEvent;
	import game.utils.ShipPositionSupport;
	
	public class GameVSComputer extends MainGameProxy
	{
		private const REPEAT_TIMEOUT:	uint = 3000;
		public static const LOCAL_PLAYER_ID:		String = "local_player";
		
		private const shipsDeckList:	Vector.<uint> = new <uint>[4, 3, 3, 2, 2, 2, 1, 1, 1, 1];
		
		private var _dataChannel:		IServerDataChannel;
		private var _battleProxy:		GameBattleProxy;
		
		private var _userId:			String;
		
		private var _requestRepeatTimer:Timer;
		
		private var _serverConnectionSupport:GameVSComputerServerInterface;
		
		
		public function GameVSComputer(proxyName:String=null)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			super.generateShipList( shipsDeckList );
			
			_serverConnectionSupport = new GameVSComputerServerInterface();
			this.facade.registerProxy( _serverConnectionSupport );
			_serverConnectionSupport.init();
			
			_dataChannel = this.facade.retrieveProxy( ProxyList.CLIENT_DATA_CHANNEL ) as IServerDataChannel;
			
			
			
			this.sendNotification(ApplicationEvents.GAME_CONTEXT_CREATE_COMPLETE, GameType.P_VS_C);
			
			this.facade.registerCommand( ApplicationCommands.USER_CHOOSE_DIFFICULT_LEVEL, SetDifficulLevelCommand);
			
			// !!!!! ALARM --- ALARM ---- ALARM --- ALARM -- Do not cross the line ----- !!!!!!
			this.sendNotification(ApplicationEvents.REQUIRED_CHOOSE_DIFFICULT_LEVEL);		// это сообщение принимает game.activity.view.application.context.pvc.PvCContextMediator и создаёт попап.
			
			
			
			//this.sendNotification(ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS);
			
			this.facade.registerCommand(ApplicationCommands.USER_HIT_POINT, UserInGameActionCommand);
			
			
			
			//var userDataProxy:IUserDataProxy = this.facade.retrieveProxy(ProxyList.USER_DATA_PROXY) as IUserDataProxy;
			
			_userId = DataProvider.getInstance().getUserDataProvider().getUserInfo().id.toString();
			
			_serverConnectionSupport.registerUser( _userId );
		}
		
		
		public function setDifficultLevel(level:uint):void
		{		
			this.facade.removeCommand( ApplicationCommands.USER_CHOOSE_DIFFICULT_LEVEL );
			
			this.sendNotification(ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS);	
			
			_serverConnectionSupport.setDifficultLevel( level - 1 ); 		// level - 1 , потому что вьюха присылает левелы от 1 до 3.			
			
			
					
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
			
			createGameBattleProxy();
			
			_battleProxy.setStatus(GameBattleStatus.WAITING_FOR_START);
			_battleProxy.finishDataUpdate();
			
			_dataChannel.addLocalListener(ServerDataChannelLocalEvent.ACTIONS_QUEUE_CREATE, actionsQueueStart);
			_dataChannel.addLocalListener(ServerDataChannelLocalEvent.CHANNEL_DATA, processActionsQueue);
			_dataChannel.addLocalListener(ServerDataChannelLocalEvent.ACTIONS_QUEUE_COMPLETE, actionsQueueFinish);
			
			_serverConnectionSupport.sendUserShipLocation( ships, _userId );
			
			
			
			
			
		}
		
		override public function hitPoint(x:uint, y:uint):void
		{
			if( _battleProxy.isWaterCeil(x, y) )
			{
				_battleProxy.setStatus(GameBattleStatus.WAITINIG_GAME_ANSWER);
				_battleProxy.finishDataUpdate();
				
				_serverConnectionSupport.sendHitPointPosition( x, y, _userId );
				
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
			
			
		}
		
		private function actionsQueueFinish(dataMessage:LocalEvent):void
		{
			_battleProxy.finishDataUpdate();
		}
		
		
		private function createGameBattleProxy():void
		{
			_battleProxy = new GameBattleProxy()
			this.facade.registerProxy( _battleProxy );
			
			_battleProxy.init(10, 10);
			_battleProxy.initUserShips( shipsList );
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
			
			_battleProxy.opponentSankUserShip(shipData, action.currentX, action.currentY);
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
			
			_battleProxy.userSankOpponentsShip(shipData, action.currentX, action.currentY);
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
			
			//_serverProxy.getGameUpdate();
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