package game.application.server
{
	import game.application.connection.ServerDataChannel;
	import game.application.interfaces.server.ILocalGameServer;
	import game.application.server.messages.MessageData;
	import game.application.server.messages.MessageDestroyShip;
	import game.application.server.messages.MessageHit;
	import game.application.server.messages.MessageType;
	import game.library.BaseProxy;
	import game.library.LocalDispactherProxy;

	public class LocalGameServer extends LocalDispactherProxy implements ILocalGameServer
	{
		private const _players:			Vector.<LocalServerPlayer> = new Vector.<LocalServerPlayer>;
		
		private var _currentPlayer:		LocalServerPlayer;
		private var _currentPlayerIndex:uint;
		
		private const _messages:		Vector.<MessageData> = new Vector.<MessageData>;
		
		public function LocalGameServer(proxyName:String = null)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			
		}
		
		
		public function initGame():void
		{
			
		}
		
		
		public function registerPlayer(id:String):void
		{
			var i:int;
			i = _players.length;
			while(i--)
			{
				if(_players[i].id == id) return;
			}
			

			var player:LocalServerPlayer = new LocalServerPlayer(id);
			_players.push( player );
		}
		
		
		public function startGame():void
		{
			
		}
		
		
		public function sendUserShipLocation( ships:Array, userId:String ):void
		{
			var player:LocalServerPlayer = getPalyer( userId );
			
			if(player)
			{
				player.createShips( ships );
			}
			
			var allPlayersAreReady:Boolean = true;
			
			var i:int;
			i = _players.length;
			while(i--)
			{
				if( !_players[i].isReadyToStart() )
				{
					allPlayersAreReady = false;
					
					addMessage( new MessageData(MessageType.WAITING_FOR_PLAYER_SHIPS_LOCATION, _players[i].id) );
				}
			}
			
			
			if( allPlayersAreReady && _players.length > 1)
			{
				setActivePlayer(0);
			}
			
			
			flushMessages();
		}
		
		
		public function sendHitPointPosition(x:uint, y:uint, userId:String ):void
		{
			if(_currentPlayer.id == userId)
			{
				var targetPlayer:LocalServerPlayer = getOtherPlayer();
				
				var shipData:LocalServerShip;
				
				shipData = targetPlayer.tryHit(x, y);
				
				if( shipData )
				{
					playerHitShip(x, y);
					
					if( shipData.isSank() ) playerDestroyShip(shipData);
					
					setActivePlayer(_currentPlayerIndex);
				}
				else
				{
					playerFailHit(x, y);
					setNextActivePlayer();
				}
				
				flushMessages();
			}
		}
		
		
		private function setActivePlayer(id:uint):void
		{
			_currentPlayerIndex = id;
			_currentPlayer = _players[id];
			addMessage( new MessageData(MessageType.SET_ACTIVE_PLAYER, _currentPlayer.id) );
		}
		
		private function setNextActivePlayer():void
		{
			_currentPlayerIndex ++;
			if(_currentPlayerIndex >= _players.length) _currentPlayerIndex = 0;
			
			setActivePlayer( _currentPlayerIndex );
		}
		
		
		private function playerHitShip(x:uint, y:uint):void
		{
			var msg:MessageHit = new MessageHit(MessageType.PLAYER_HIT_SHIP, _currentPlayer.id);
			msg.x = x;
			msg.y = y;
			
			addMessage( msg );
		}
		
		private function playerFailHit(x:uint, y:uint):void
		{
			var msg:MessageHit = new MessageHit(MessageType.PLAYER_MISSED, _currentPlayer.id);
			msg.x = x;
			msg.y = y;
			
			addMessage( msg );
		}
		
		
		private function playerDestroyShip( shipData:LocalServerShip ):void
		{
			var msg:MessageDestroyShip = new MessageDestroyShip(MessageType.PLAYER_SANK_SHIP, _currentPlayer.id);
			msg.deck = shipData.deck;
			msg.startX = shipData.getX(0);
			msg.startY = shipData.getY(0);
			
			msg.finishX = shipData.getX(shipData.deck - 1);
			msg.finishY = shipData.getY(shipData.deck - 1);
			
			addMessage( msg );
		}
		
		
		private function getPalyer(id:String):LocalServerPlayer
		{
			var i:int;
			i = _players.length;
			while(i--)
			{
				if(_players[i].id == id) return _players[i];
			}
			
			return null;
		}
		
		private function getOtherPlayer():LocalServerPlayer
		{
			if(_currentPlayerIndex == _players.length - 1) return _players[0];
			return _players[_currentPlayerIndex + 1];
		}
		
		
		private function addMessage(message:MessageData):void
		{
			_messages.push( message );
		}
		
		private function flushMessages():void
		{
			this.dispactherLocalEvent( LocalServerEvents.START_MESSAGE_QUEUE );
			
			var i:int;
			for(i = 0; i < _messages.length; i++)
			{
				this.dispactherLocalEvent( LocalServerEvents.MESSAGE, _messages[i] );
			}
			
			_messages.length = 0;
			
			this.dispactherLocalEvent( LocalServerEvents.FINISH_MESSAGE_QUEUE );
		}
	}
}