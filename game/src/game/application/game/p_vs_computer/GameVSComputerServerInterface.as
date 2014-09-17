package game.application.game.p_vs_computer
{
	import game.application.ProxyList;
	import game.application.computer.ComputerAI;
	import game.application.connection.ChannelDataType;
	import game.application.connection.ServerDataChannel;
	import game.application.connection.data.DestroyShipData;
	import game.application.connection.data.GameInfoData;
	import game.application.connection.data.HitInfoData;
	import game.application.game.battle.GameBattleStatus;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.application.interfaces.data.IUserDataProxy;
	import game.application.interfaces.server.ILocalGameServer;
	import game.application.server.LocalGameServer;
	import game.application.server.LocalServerEvents;
	import game.application.server.messages.MessageData;
	import game.application.server.messages.MessageDestroyShip;
	import game.application.server.messages.MessageHit;
	import game.application.server.messages.MessageType;
	import game.library.LocalDispactherProxy;
	import game.library.LocalEvent;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class GameVSComputerServerInterface extends LocalDispactherProxy
	{
		public static const NAME:			String = "GameVSComputerServerInterface";
		
		private var _localServer:			ILocalGameServer;
		private var _computerAI:			ComputerAI;
		
		private var _userChannel:			IServerDataChannel;
		private var _computerChannel:		IServerDataChannel;
		
		public function GameVSComputerServerInterface()
		{
			super(NAME);
		}
		
		public function init():void
		{
			
		}
		
		override public function onRegister():void
		{
			_localServer = new LocalGameServer(ProxyList.LOCAL_GAME_SERVER) as ILocalGameServer;
			
			_localServer.addLocalListener(LocalServerEvents.MESSAGE, handlerServerMessage);
			_localServer.addLocalListener(LocalServerEvents.FINISH_MESSAGE_QUEUE, handlerServerMessage);
			
			_computerAI = new ComputerAI();
			
			_userChannel = this.facade.retrieveProxy( ProxyList.CLIENT_DATA_CHANNEL ) as IServerDataChannel;
			if( !_userChannel )
			{
				_userChannel = new ServerDataChannel( ProxyList.CLIENT_DATA_CHANNEL );
				this.facade.registerProxy( _userChannel as IProxy );
			}
			
			_computerChannel = this.facade.retrieveProxy( ProxyList.LOCAL_DATA_CHANNEL ) as IServerDataChannel;
			if( !_computerChannel )
			{
				_computerChannel = new ServerDataChannel( ProxyList.LOCAL_DATA_CHANNEL );
				this.facade.registerProxy( _computerChannel as IProxy );
			}
			
			_computerAI.init();
		}
		
		public function setDifficultLevel(level:int):void
		{		
			//_computerAI = new ComputerAI();
			//_computerAI.init();
			
			_computerAI.setDifficultLevel(level);
		}
				
		
		public function registerUser(userId:String):void
		{
			_localServer.registerPlayer( userId );
		}
		
		
		public function sendUserShipLocation(ships:Array, userId:String):void
		{
			_localServer.sendUserShipLocation( ships, userId );
		}
		
		public function sendHitPointPosition(x:uint, y:uint, userId:String):void
		{
			_localServer.sendHitPointPosition(x, y, userId);
		}
		
		
		
		private function handlerServerMessage(event:LocalEvent):void
		{
			if(event.event == LocalServerEvents.MESSAGE)
			{
				var message:MessageData = event.data as MessageData;
				
				switch(message.type)
				{
					case MessageType.WAITING_FOR_PLAYER_SHIPS_LOCATION:
					{
						waitingForPlayer();
						break;
					}
					
					case MessageType.SET_ACTIVE_PLAYER:
					{
						setActivePlayer( message.player );
						break;
					}
						
					case MessageType.PLAYER_HIT_SHIP:
					{
						playerHitShip(message as MessageHit);
						break;
					}
						
					case MessageType.PLAYER_MISSED:
					{
						playerMissedShip(message as MessageHit);
						break;
					}
						
					case MessageType.PLAYER_SANK_SHIP:
					{
						playerSankShip(message as MessageDestroyShip);
						break;
					}
				}
			}
			else if( event.event == LocalServerEvents.FINISH_MESSAGE_QUEUE )
			{
				_userChannel.sendData();
				_computerChannel.sendData();
			}
		}
		
		
		private function waitingForPlayer():void
		{
			var action:GameInfoData;
			
			action = new GameInfoData();
			
			action.gameTime = 0;
			action.status = GameBattleStatus.WAITING_FOR_START;
			action.timeOut = 0;
			action.userPoints = 0;
			
			_userChannel.pushData( action );
			_computerChannel.pushData( action );
		}
		
		
		private function setActivePlayer(player:String):void
		{
			var action:GameInfoData;
			
			if( player == ComputerAI.PLAYER_ID )
			{	
				action = new GameInfoData();
				
				action.gameTime = 0;
				action.status = GameBattleStatus.STEP_OF_OPPONENT;
				action.timeOut = 0;
				action.userPoints = 0;
				
				_userChannel.pushData( action );
				
				action = new GameInfoData();
				
				action.gameTime = 0;
				action.status = GameBattleStatus.STEP_OF_INCOMING_USER;
				action.timeOut = 0;
				action.userPoints = 0;
				
				
				_computerChannel.pushData( action );
			}
			else
			{
				action = new GameInfoData();
				
				action.gameTime = 0;
				action.status = GameBattleStatus.STEP_OF_OPPONENT;
				action.timeOut = 0;
				action.userPoints = 0;
				
				_computerChannel.pushData( action );
				
				action = new GameInfoData();
				
				action.gameTime = 0;
				action.status = GameBattleStatus.STEP_OF_INCOMING_USER;
				action.timeOut = 0;
				action.userPoints = 0;
				
				
				_userChannel.pushData( action );
			}
		}
		
		
		private function playerHitShip(msg:MessageHit):void
		{
			var action:HitInfoData;
			var opponentHitInfo:HitInfoData;
			
			action = new HitInfoData(ChannelDataType.USER_HIT_INFO);
			opponentHitInfo = new HitInfoData(ChannelDataType.OPPONENT_HIT_INFO);
			
			opponentHitInfo.pointX = action.pointX = msg.x;
			opponentHitInfo.pointY = action.pointY = msg.y;
			opponentHitInfo.status = action.status = 1;
			
			if( msg.player == ComputerAI.PLAYER_ID )
			{
				_userChannel.pushData( opponentHitInfo );
				_computerChannel.pushData( action );
			}
			else
			{
				_userChannel.pushData( action );
				_computerChannel.pushData( opponentHitInfo );
			}
		}
		
		private function playerMissedShip(msg:MessageHit):void
		{
			var action:HitInfoData;
			var opponentHitInfo:HitInfoData;
			
			action = new HitInfoData(ChannelDataType.USER_HIT_INFO);
			opponentHitInfo = new HitInfoData(ChannelDataType.OPPONENT_HIT_INFO);
			
			opponentHitInfo.pointX = action.pointX = msg.x;
			opponentHitInfo.pointY = action.pointY = msg.y;
			opponentHitInfo.status = 0;
			
			if( msg.player == ComputerAI.PLAYER_ID )
			{
				_userChannel.pushData( opponentHitInfo );
				_computerChannel.pushData( action );
			}
			else
			{
				_userChannel.pushData( action );
				_computerChannel.pushData( opponentHitInfo );
			}
		}
		
		
		private function playerSankShip(msg:MessageDestroyShip):void
		{	
			var action:DestroyShipData;
			var opponentHitInfo:DestroyShipData;
			
			action = new DestroyShipData(ChannelDataType.USER_DESTROY_OPPONENT_SHIP);
			opponentHitInfo = new DestroyShipData(ChannelDataType.OPPONENT_DESTROY_USER_SHIP);
			
			opponentHitInfo.decks  = action.decks = msg.deck
			opponentHitInfo.status = action.status = 2;
						
			opponentHitInfo.startX = action.startX = msg.startX
			opponentHitInfo.startY = action.startY = msg.startY;
			
			opponentHitInfo.finishX = action.finishX = msg.finishX;
			opponentHitInfo.finishY = action.finishY = msg.finishY;
			
			if( msg.player == ComputerAI.PLAYER_ID )
			{
				_userChannel.pushData( opponentHitInfo );
				_computerChannel.pushData( action );
			}
			else
			{
				_userChannel.pushData( action );
				_computerChannel.pushData( opponentHitInfo );
			}
			
			
			//_queue.push( action );
		}
	}
}