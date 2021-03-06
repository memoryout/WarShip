package game.application.game
{
	import game.library.BaseProxy;
	import game.application.data.game.ShipData;
	import game.application.interfaces.game.IGameProxy;
	
	public class MainGameProxy extends BaseProxy implements IGameProxy 
	{
		protected var shipsList:			Vector.<ShipData>;
		
		public function MainGameProxy(proxyName:String=null)
		{
			super(proxyName);
		}
		
		
		protected function generateShipList(decksList:Vector.<uint>):void
		{
			shipsList = new Vector.<ShipData>(decksList.length, true);
			
			var i:int, ship:ShipData;
			for(i = 0; i < decksList.length; i++)
			{
				ship = new ShipData();
				
				ship.x = -10;
				ship.y = -10;
				
				ship.deck = decksList[i];
				shipsList[i] =  ship ;
			}
		}
		
		
		public function getShipsList():Vector.<ShipData>
		{
			return shipsList;
		}
		
		
		public function userLocatedShips():void
		{
			
		}
		
		
		public function hitPoint(x:uint, y:uint):void
		{
			
		}
		
		public function destroy():void
		{
			
		}
	}
}