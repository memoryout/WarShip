package game.activity.view.application.menu
{
	import flash.display.DisplayObjectContainer;
	
	import game.activity.BaseMediator;
	import game.activity.view.application.menu.pages.game_type.SelectGameTypeMediator;
	import game.activity.view.application.menu.pages.ships_positions.ShipsPositionsMediator;
	import game.application.ApplicationEvents;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class MenuMediator extends BaseMediator
	{
		public static const NAME:			String = "mediator.menu";
		
		private var _menuView:				MenuView;
		
		private var _currentPage:			MenuPageMediator;
		
		public function MenuMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			_menuView = new MenuView();
			(viewComponent as DisplayObjectContainer).addChild( _menuView );
			
			
			showSelectGameTypePage();
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [
					ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS,
					ApplicationEvents.BUTTLE_PROXY_INIT_COMPLETE
					];
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS:
				{
					showShipsPositionsPage();
					break;
				}
					
				case ApplicationEvents.BUTTLE_PROXY_INIT_COMPLETE:
				{
					if(_currentPage) _currentPage.hide();
					_currentPage = null;
					break;
				}
			}
		}
		
		
		private function showSelectGameTypePage():void
		{
			if(_currentPage) _currentPage.hide();
			
			_currentPage = new SelectGameTypeMediator( _menuView.getMenuPageLayer() );
			this.facade.registerMediator( _currentPage );
		}
		
		
		private function showShipsPositionsPage():void
		{
			if(_currentPage) _currentPage.hide();
			
			_currentPage = new ShipsPositionsMediator( _menuView.getMenuPageLayer() );
			this.facade.registerMediator( _currentPage );
		}
	}
}