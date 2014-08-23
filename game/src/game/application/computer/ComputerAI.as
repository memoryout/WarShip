package game.application.computer
{
	import flash.utils.setTimeout;
	
	import game.application.ProxyList;
	import game.application.connection.ChannelData;
	import game.application.connection.ChannelDataType;
	import game.application.connection.ServerDataChannelEvent;
	import game.application.connection.ServerDataChannelLocalEvent;
	import game.application.connection.data.GameInfoData;
	import game.application.game.battle.GameBattleStatus;
	import game.application.game.p_vs_computer.GameVSComputerServerInterface;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.library.BaseProxy;
	import game.library.LocalEvent;

	public class ComputerAI extends BaseProxy
	{
		public static const PLAYER_ID:		String = "computer_id";
		
		private var _dataChannel:			IServerDataChannel;
		private var _serverConnection:		GameVSComputerServerInterface;
		
		private var shipsPositions:			Array = [[[2,4],[2,7]], [[7,6],[9,6]], [[3,0],[5,0]], [[0,9],[1,9]], [[5,4],[6,4]], [[8,4],[9,4]], [[7,0],[7,0]], [[4,8],[4,8]], [[3,2],[3,2]], [[7,2],[7,2]]];
		
		private var _hitX:					int;
		private var _hitY:					int;
		
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
			
			generateShipsPosition();
			
			_hitX = -1;
			_hitY = 0;
		}
		
		
		private function generateShipsPosition():void
		{
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
					//parseUserHitInfo(action as HitInfoData);
					break;
				}
					
				case ChannelDataType.USER_DESTROY_OPPONENT_SHIP:
				{
					//parseUserDestroyOpponentShipAction(action as DestroyShipData);
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
					break;
				}
				case GameBattleStatus.WAITING_FOR_START:
				{
					//_battleProxy.setStatus(GameBattleStatus.WAITING_FOR_START);
					break;
				}
					
				case GameBattleStatus.STEP_OF_INCOMING_USER:
				{
					setTimeout(makeNextHit,1000);
					//_battleProxy.setStatus(GameBattleStatus.STEP_OF_INCOMING_USER);
					break;
				}
					
				case GameBattleStatus.INCOMING_USER_WON:
				{
					//stopUpdateTimer();
					//_battleProxy.setStatus(GameBattleStatus.INCOMING_USER_WON);
					//this.sendNotification( ApplicationCommands.FINISH_CURRENT_GAME);
					break;
				}
					
				case GameBattleStatus.OPPONENT_WON:
				{
					//stopUpdateTimer();
					//_battleProxy.setStatus(GameBattleStatus.OPPONENT_WON);
					//this.sendNotification( ApplicationCommands.FINISH_CURRENT_GAME);
					break;
				}
			}
		}
		
		
		private function makeNextHit():void
		{
			_hitX ++;
			if(_hitX >= 10) 
			{
				_hitX = 0;
				_hitY ++;
			}
			
			_serverConnection.sendHitPointPosition( _hitX, _hitY, PLAYER_ID );
		}
	}
}