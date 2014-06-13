package game.activity.view.application.menu.pages.ships_positions
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.activity.BaseMediator;
	import game.activity.view.application.menu.MenuPageMediator;
	import game.application.ApplicationCommands;
	import game.application.ProxyList;
	import game.application.data.game.ShipData;
	import game.application.interfaces.IMainApplicationProxy;
	import game.application.interfaces.game.IGameProxy;
	import game.application.interfaces.game.p_vs_p_net.IGameVSPlayerNet;
	import game.utils.GamePoint;
	import game.utils.ShipPositionSupport;
	
	public class ShipsPositionsMediator extends MenuPageMediator
	{
		public static const NAME:			String = "mediator.menu.pages.ships_positions";
		
		private var _view:					ShipsPositionsView;
		
		private var _proxy:					IGameProxy;
		private var _shipsList:				Vector.<ShipData>;
		
		public function ShipsPositionsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			_view = new ShipsPositionsView();
			(viewComponent as DisplayObjectContainer).addChild( _view );
			
			_view.addEventListener(ShipsPositionsView.AUTO_ARRANGEMENT, handlerAutoArrangement);
			_view.addEventListener(ShipsPositionsView.ROTATE, 	handlerRotate);
			_view.addEventListener(ShipsPositionsView.BACK, handlerBack);
			_view.addEventListener(ShipsPositionsView.NEXT, handlerNext);
			_view.addEventListener(ShipsPositionsView.SHIP_DRAG, handlerChangeShipPosition);
			
			var mainApp:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			_proxy = mainApp.getCurrentGame();
			
			_shipsList = _proxy.getShipsList();
			_view.setShipsData( _shipsList );
			
			////
			ShipPositionSupport.getInstance().shipsAutoArrangement(_shipsList, 10, 10);
			_view.setShipPositionOnTable();
		}
		
		
		override public function hide():void
		{
			this.facade.removeMediator( NAME );
			
			_view.removeEventListener(ShipsPositionsView.AUTO_ARRANGEMENT, handlerAutoArrangement);
			_view.removeEventListener(ShipsPositionsView.ROTATE, 	handlerRotate);
			_view.removeEventListener(ShipsPositionsView.BACK, handlerBack);
			_view.removeEventListener(ShipsPositionsView.NEXT, handlerNext);
			
			_view.close();
			_view = null;
		}
		
		
		private function handlerAutoArrangement(e:Event):void
		{
			ShipPositionSupport.getInstance().shipsAutoArrangement(_shipsList, 10, 10);
			_view.updateShipPositions();
			_view.setShipPositionOnTable();
			
		}
		
		private function handlerRotate(e:Event):void
		{			
			_view.rotateShip();			
		}
		
		private function handlerBack(e:Event):void
		{
			
		}
		
		private function handlerNext(e:Event):void
		{
			_view.removeEventListener(ShipsPositionsView.AUTO_ARRANGEMENT, handlerAutoArrangement);
			_view.removeEventListener(ShipsPositionsView.ROTATE, 	handlerRotate);
			_view.removeEventListener(ShipsPositionsView.BACK, 		handlerBack);
			_view.removeEventListener(ShipsPositionsView.NEXT, 		handlerNext);
			
			this.sendNotification( ApplicationCommands.USER_SHIPS_LOCATED_COMPLETE);
		}
		
		
		
		private function handlerChangeShipPosition(e:Event):void
		{
			var shipData:ShipData = _view.activeShip;				// текущий ShipData
			
			var v:Vector.<GamePoint> = ShipPositionSupport.getInstance().testCollision(shipData, _shipsList);		// вектор объектов точек где произошло пересечение.
			//			trace(v);
			
			if(v.length > 0)
				_view.isColision = true;
			else 
				_view.isColision = false;
		}
	}
}