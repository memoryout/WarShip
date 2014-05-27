package game.application.game.p_vs_p_net
{
	import game.application.ApplicationEvents;
	import game.application.BaseProxy;
	import game.application.data.game.ShipData;
	import game.application.game.MainGameProxy;
	import game.application.interfaces.game.p_vs_p_net.IGameVSPlayerNet;
	
	public class GameVSPlayerNetProxy extends MainGameProxy implements IGameVSPlayerNet
	{
		private const shipsDeckList:	Vector.<uint> = new <uint>[1, 1, 1, 1, 2, 2, 2, 3, 3, 4];
		
		
		private var _shipsList:			Vector.<ShipData>;
		
		
		public function GameVSPlayerNetProxy(proxyName:String)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			super.generateShipList( shipsDeckList );
			
			this.sendNotification(ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS);
		}		
		
		
		
		private function generateShipsList():void
		{
			_shipsList = new Vector.<ShipData>(shipsDeckList.length, true);
			
			var i:int, ship:ShipData;
			for(i = 0; shipsDeckList.length; i++)
			{
				ship = new ShipData();
				
				ship.deck = shipsDeckList[i];
				_shipsList.push( ship );
			}
		}
	}
}