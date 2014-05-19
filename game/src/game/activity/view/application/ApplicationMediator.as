package game.activity.view.application
{
	import flash.display.DisplayObjectContainer;
	
	import game.GameType;
	import game.activity.BaseMediator;
	import game.activity.view.application.menu.MenuMediator;
	import game.activity.view.application.windows.WindowsMediator;
	import game.application.ApplicationEvents;
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class ApplicationMediator extends BaseMediator
	{
		public static const NAME:				String = "mediator.application";
		
		private var _appView:				ApplicationView;
		
		private var _appProxy:				IMainApplicationProxy;
		
		public function ApplicationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			_appView = new ApplicationView();
			(viewComponent as DisplayObjectContainer).addChild( _appView );
			
			_appProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			
			createWindowsMediator();
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationEvents.START_UP_COMPLETE	
					];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case ApplicationEvents.START_UP_COMPLETE:
				{
					createMenuMediator();
					break;
				}
			}
		}
		
		
		private function createMenuMediator():void
		{
			this.facade.registerMediator( new MenuMediator( _appView.getMenuLayer() ) );
		}
		
		private function createWindowsMediator():void
		{
			this.facade.registerMediator( new WindowsMediator( _appView.getWindowsLayer() ) );
		}
	}
}