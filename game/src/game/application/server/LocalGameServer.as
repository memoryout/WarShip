package game.application.server
{
	import game.application.BaseProxy;
	import game.application.connection.ActionsQueue;
	import game.application.interfaces.server.ILocalGameServer;

	public class LocalGameServer extends BaseProxy implements ILocalGameServer
	{
		private const _players:			Vector.<LocalServerPlayer> = new Vector.<LocalServerPlayer>;
		
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
		
		
		public function sendUserShipLocation( ships:Array ):void
		{
			
		}
		
		public function sendHitPointPosition(x:uint, y:uint):void
		{
			
		}
	}
}