package game.application.computer
{
	import flash.utils.setTimeout;
	
	import game.application.ProxyList;
	import game.application.connection.ChannelData;
	import game.application.connection.ChannelDataType;
	import game.application.connection.ServerDataChannelEvent;
	import game.application.connection.ServerDataChannelLocalEvent;
	import game.application.connection.data.DestroyShipData;
	import game.application.connection.data.GameInfoData;
	import game.application.connection.data.HitInfoData;
	import game.application.game.battle.GameBattleStatus;
	import game.application.game.p_vs_computer.GameVSComputerServerInterface;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.application.interfaces.game.battle.IGameBattleProxy;
	import game.library.BaseProxy;
	import game.library.LocalEvent;

	public class ComputerAI extends BaseProxy
	{
		public static const LOW:			int = 0;
		public static const MIDDLE:			int = 1;
		public static const HIGH:			int = 2;
		
		public static const PLAYER_ID:		String = "computer_id";
		
		private var _dataChannel:			IServerDataChannel;
		private var _serverConnection:		GameVSComputerServerInterface;
		private var _gameBattleProxy:		IGameBattleProxy;
		
		private var shipsPositions:			Array = [[[2,4],[2,7]], [[7,6],[9,6]], [[3,0],[5,0]], [[0,9],[1,9]], [[5,4],[6,4]], [[8,4],[9,4]], [[7,0],[7,0]], [[4,8],[4,8]], [[3,2],[3,2]], [[7,2],[7,2]]];
		
		private var _hitX:					int;
		private var _hitY:					int;
		
		private var _userData:				Data;	
		private var _playLogic:				PlayLogic;
		
		private var gameLevel:				int;
		
		public function ComputerAI()
		{
			super();
		}
		
		public function init():void
		{
			_dataChannel = this.facade.retrieveProxy( ProxyList.LOCAL_DATA_CHANNEL ) as IServerDataChannel;
			_dataChannel.addLocalListener( ServerDataChannelLocalEvent.CHANNEL_DATA, processActionsQueue );
			
			_serverConnection = this.facade.retrieveProxy( GameVSComputerServerInterface.NAME) as GameVSComputerServerInterface;
			
			_serverConnection.registerUser( PLAYER_ID );
			
			_userData = new Data();			
			
			if(!_playLogic)
			{
				_playLogic = new PlayLogic();
				_playLogic.saveGameData(_userData);
			}
			
			generateShipsPosition();
			
			_hitX = -1;
			_hitY = 0;
		}
		
		
		public function setDifficultLevel(level:uint):void
		{
			
		}
		
		
		private function generateShipsPosition():void
		{			
			_userData.userShips 	  = PShipsArray.Get().getShipsPosition(true);
			_userData.userBattleField = PShipsArray.Get().getBattleField();
			
			shipsPositions = new Array();
			
			for (var i:int = 0; i < _userData.userShips[0].length; i++) 
			{
				var shipCoordinates:Vector.<Array> = _userData.userShips[0][i].coordinates;
				shipsPositions.push([shipCoordinates[0], shipCoordinates[shipCoordinates.length-1]]);
			}
			
			
			_serverConnection.sendUserShipLocation( shipsPositions, PLAYER_ID);
		}
		
		
		public function processActionsQueue(dataMessage:LocalEvent):void
		{
			var action:ChannelData;
			
			action = dataMessage.data as ChannelData;//_actionsQueue.getNextAction();
			
			switch(action.type)
			{
				case ChannelDataType.GAME_STATUS_INFO:
				{
					updateGameStatusInfo(action as GameInfoData);
					break;
				}
					
				case ChannelDataType.OPPONENT_INFO:
				{
					//updateOpponentData(action as OpponentInfoData);
					break;
				}
					
				case ChannelDataType.USER_INFO:
				{
					//updateUserData(action as UserInfoData);
					break;
				}
					
				case ChannelDataType.OPPONENT_HIT_INFO:
				{
					//parseOpponentHitInfo(action as HitInfoData);
					
					
					break;
				}
					
				case ChannelDataType.OPPONENT_DESTROY_USER_SHIP:
				{
					//parseOpponentDestroyUserShipAction(action as DestroyShipData);
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
		
		private function updateGameStatusInfo(action:GameInfoData):void
		{
			switch(action.status)
			{
				case GameBattleStatus.STEP_OF_OPPONENT:
				{
					//_battleProxy.setStatus(GameBattleStatus.STEP_OF_OPPONENT);
					
//					_timer.start();
					
					break;
				}
				case GameBattleStatus.WAITING_FOR_START:
				{
					//_battleProxy.setStatus(GameBattleStatus.WAITING_FOR_START);
					
//					_timer.start();
					
					break;
				}
					
				case GameBattleStatus.STEP_OF_INCOMING_USER:
				{
					setTimeout(userMakeHit, 1000);
					//_battleProxy.setStatus(GameBattleStatus.STEP_OF_INCOMING_USER);
					
//					_timer.stop();
					
//					trace("currentGameStatusSendRequest: ", currentGameStatus, "name:" , _userData.name);	
										
					break;
				}
					
				case GameBattleStatus.INCOMING_USER_WON:
				{
					//stopUpdateTimer();
					//_battleProxy.setStatus(GameBattleStatus.INCOMING_USER_WON);
					//this.sendNotification( ApplicationCommands.FINISH_CURRENT_GAME);
					
//					_mainClass.log_window.text += "INCOMING_USER_WON";		
					
//					DataContainer.Get().finishedGamesNumbers++;
					
//					_mainClass.finished_games.text = DataContainer.Get().finishedGamesNumbers.toString();					
//					
//					UsersContainer.Get().clearAllUsers();				
					
					break;
				}
					
				case GameBattleStatus.OPPONENT_WON:
				{
					//stopUpdateTimer();
					//_battleProxy.setStatus(GameBattleStatus.OPPONENT_WON);
					//this.sendNotification( ApplicationCommands.FINISH_CURRENT_GAME);
					
//					_mainClass.log_window.text += "OPPONENT_WON";			
					
//					DataContainer.Get().finishedGamesNumbers++;
					
//					_mainClass.finished_games.text = DataContainer.Get().finishedGamesNumbers.toString();						
					
//					UsersContainer.Get().clearAllUsers();
					
					break;
				}
			}
		}
		
		private function parseUserHitInfo(action:HitInfoData):void
		{
			var hitData:Object;
			var actionData:HitInfoData = action as HitInfoData;
			
			if(actionData.status == 1)
			{
				hitData = {ship_status:"0", line:"0", column:"0", player:"user", killed_coordinates:""};
				
				hitData.ship_status = actionData.status;
				
				hitData.line  = actionData.pointX;
				hitData.column = actionData.pointY;
								
				if(hitData.ship_status != 0)				
				{
					_userData.hitedPlayerShipPosition.push([actionData.pointX, actionData.pointY]);						
				}
				
				if(hitData.ship_status 		== 1)	
					_userData.isHited = true;					
			}
		}
		
		private function parseUserDestroyOpponentShipAction(action:DestroyShipData):void
		{			
			if(action.status == 2)
			{
				_userData.shipIsKill = true;
				_userData.isHited 	 = false;
				
				_userData.userBattleField = _playLogic.setWaterAroundFullKilledShip(
					_userData.userBattleField, getFullPosiotionKilledShip([action.startX, action.startY], [action.finishX, action.finishY], action.decks), false, true);
			}
		}
		
		private function userMakeHit():void
		{
			var cellForHit:Array = new Array();
			
			if(_userData.shipIsKill || _userData.isHited)
			{
				if(!_userData.shipIsKill)
				{										
					_userData.isHited 			= false;
					_userData.oponentShipIsHit 	= true;			
					
				}else{
					_userData.oponentShipIsHit 	= _userData.shipIsKill = false;		
					_userData.findAnotherShip 	= true;	
					
					_userData.hitedPlayerShipPosition 		= new Array();
					_userData.pushedIndexesForFindLastCell	= new Array();
					
					_userData.killedShipsCouterCom++;
				}		
				
				if(_userData.killedShipsCouterCom != 10)						
				{	
					cellForHit = _playLogic.selectCellForHit();
					
					_serverConnection.sendHitPointPosition( cellForHit[0], cellForHit[1], PLAYER_ID );
				}						
			}else{				
				
				cellForHit = _playLogic.selectCellForHit();
				//						
				_serverConnection.sendHitPointPosition( cellForHit[0], cellForHit[1], PLAYER_ID );
			}					
		}
		
		private function getFullPosiotionKilledShip(start_point:Array, end_point:Array, decks_number:int):Array
		{
			var orient:int, res:Array =  new Array();
			
			if(		end_point[0] > start_point[0])	orient = 1;	 // ship is on line			
			else if(end_point[1] > start_point[1])	orient = 0;	 // ship is on column
			
			if(orient == 1)
			{
				for (var j:int = 0; j < decks_number; j++) 
				{						
					res.push([start_point[0] + j, start_point[1]]);  // set full position for current ship							
				}	
				
			}else{
				
				for (var k:int = 0; k < decks_number; k++) 
				{
					res.push([start_point[0], start_point[1] + k]);  // set full position for current ship	
				}	
			}
			
			return res;
		}
		
		/*
		private function makeNextHit():void
		{
			_hitX ++;
			if(_hitX >= 10) 
			{
				_hitX = 0;
				_hitY ++;
			}
			
			_serverConnection.sendHitPointPosition( _hitX, _hitY, PLAYER_ID );
		}*/		
	}
}