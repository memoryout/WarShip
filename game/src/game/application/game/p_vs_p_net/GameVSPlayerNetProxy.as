package game.application.game.p_vs_p_net
{
	import game.application.ApplicationEvents;
	import game.application.BaseProxy;
	import game.application.ProxyList;
	import game.application.data.game.ShipData;
	import game.application.data.game.ShipPositionPoint;
	import game.application.game.MainGameProxy;
	import game.application.game.battle.GameBattleProxy;
	import game.application.interfaces.game.p_vs_p_net.IGameVSPlayerNet;
	import game.application.server.ServerConnectionProxy;
	
	public class GameVSPlayerNetProxy extends MainGameProxy implements IGameVSPlayerNet
	{
		private const shipsDeckList:	Vector.<uint> = new <uint>[4, 3, 3, 2, 2, 2, 1, 1, 1, 1];
		
		private var _battleProxy:		GameBattleProxy;
		
		public function GameVSPlayerNetProxy(proxyName:String)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			super.generateShipList( shipsDeckList );
			
			this.sendNotification(ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS);
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
				arr.push( [ coords[0].y, coords[0].x] );
				arr.push( [ coords[coords.length - 1].y, coords[coords.length - 1].x] );
				
				ships.push( arr );
				
				// координаты записаны y-x порядке так как у сервера матрица сделана через ж...  х - смотрит вниз y - вправо. Жизнь боль.
			}
			
			
			var serverProxy:ServerConnectionProxy = this.facade.retrieveProxy(ProxyList.SERVER_PROXY) as ServerConnectionProxy;
			serverProxy.sendUserShipLocation( ships );
			
			createGameBattleProxy();
			
			
		}
		
		
		private function createGameBattleProxy():void
		{
			_battleProxy = new GameBattleProxy()
			this.facade.registerProxy( _battleProxy );
			
			_battleProxy.init(10, 10);
			_battleProxy.initUserShips( shipsList );
		}
	}
}