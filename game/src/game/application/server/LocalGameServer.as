package game.application.server
{
	import game.application.connection.ServerDataChannel;
	import game.application.interfaces.server.ILocalGameServer;
	import game.library.BaseProxy;

	public class LocalGameServer extends BaseProxy implements ILocalGameServer
	{
		private const _players:			Vector.<LocalServerPlayer> = new Vector.<LocalServerPlayer>;
		
		private var _currentPlayer:		LocalServerPlayer;
		
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
			
			
			var i:int;
			i = _players.length;
			while(i--)
			{
				if(_players[i].id == id) return;
			}
			
		}
		
		
		public function sendHitPointPosition(x:uint, y:uint, userId:String ):void
		{
			
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
	}
}