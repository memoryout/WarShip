package game.activity.view.application.menu.pages.ships_positions
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.activity.BaseMediator;
	import game.activity.view.application.menu.MenuPageMediator;
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	import game.application.interfaces.game.IGameProxy;
	import game.application.interfaces.game.p_vs_p_net.IGameVSPlayerNet;
	
	public class ShipsPositionsMediator extends MenuPageMediator
	{
		public static const NAME:			String = "mediator.menu.pages.ships_positions";
		
		private var _view:					ShipsPositionsView;
		
		private var _proxy:					IGameProxy;
				
		public function ShipsPositionsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			_view = new ShipsPositionsView();
			(viewComponent as DisplayObjectContainer).addChild( _view );
			
			_view.addEventListener(ShipsPositionsView.AUTO_ARRANGEMENT, handlerAutoArrangement);
			_view.addEventListener(ShipsPositionsView.BACK, handlerBack);
			
			var mainApp:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			_proxy = mainApp.getCurrentGame();
		}
		
		
		private function handlerAutoArrangement(e:Event):void
		{
			
		}
		
		private function handlerBack(e:Event):void
		{
			
		}
	}
}