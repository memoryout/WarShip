package game.activity.view.application.windows.authorization_users
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.activity.BaseMediator;
	import game.application.ApplicationCommands;
	import game.application.ApplicationEvents;
	import game.application.ProxyList;
	import game.application.startup.StartupProxy;
	
	public class SelectCurrentUserWindowMediator extends BaseMediator
	{
		public static const NAME:			String = "mediator.windows.select_current_user";
			
		private var _view:					SelectCurrentUserWindow;
		
		public function SelectCurrentUserWindowMediator(viewComponent:Object)
		{
			super(NAME + Math.random().toString(), viewComponent);
		}
		
		
		override public function onRegister():void
		{
			_view = new SelectCurrentUserWindow();
			(viewComponent as DisplayObjectContainer).addChild(_view);
			
			_view.addEventListener(SelectCurrentUserWindow.SELECT_USER, handlerSelectUser);
			_view.addEventListener(SelectCurrentUserWindow.CREATE_NEW_USER, handlerCreateNewUser);
			
			var startup:StartupProxy = this.facade.retrieveProxy(ProxyList.STARTUP_PROXY) as StartupProxy;
			if(startup)
			{
				_view.setUserList( startup.getUserList() );
			}
		}
		
		public function reCreate():void
		{
			_view.removeUserList();
			
			var startup:StartupProxy = this.facade.retrieveProxy(ProxyList.STARTUP_PROXY) as StartupProxy;
			if(startup)
			{
				_view.setUserList( startup.getUserList() );
			}
		}
		
		
		private function handlerSelectUser(e:Event):void
		{
			this.sendNotification(ApplicationCommands.STARTUP_SELECT_USER, _view.selectedID );
			hide();
		}
		
		private function handlerCreateNewUser(e:Event):void
		{
			this.sendNotification(ApplicationCommands.STARTUP_SET_LOGIN, _view.userName );
			hide();
		}
		
		private function hide():void
		{
			this.facade.removeMediator(NAME);
			
			(viewComponent as DisplayObjectContainer).removeChild( _view );
			_view = null;
		}
	}
}