package game.activity.view.application.windows
{
	import flash.display.DisplayObjectContainer;
	
	import game.activity.BaseMediator;
	import game.activity.view.application.windows.authorization_users.SelectCurrentUserWindowMediator;
	import game.activity.view.application.windows.sign_in.SignInWindowMediatior;
	import game.application.ApplicationEvents;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class WindowsMediator extends BaseMediator
	{
		public static const NAME:			String = "mediator.windows"
		
		private var _view:			WindowsView;
			
		public function WindowsMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			_view = new WindowsView();
			(viewComponent as DisplayObjectContainer).addChild( _view );
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationEvents.REQUIRED_USER_AUTHORIZATION,
						ApplicationEvents.REQUIRED_SELECT_ACTIVE_USER
					];
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case ApplicationEvents.REQUIRED_USER_AUTHORIZATION:
				{
					showAuthorizationWindow();
					break;
				}
					
				case ApplicationEvents.REQUIRED_SELECT_ACTIVE_USER:
				{
					showSelectUserWindow();
					break;
				}
			}
		}
		
		
		private function showAuthorizationWindow():void
		{
			this.facade.registerMediator( new SignInWindowMediatior(_view.getAlertsLayers()) );
		}
		
		
		private function showSelectUserWindow():void
		{
			this.facade.registerMediator( new SelectCurrentUserWindowMediator(_view.getAlertsLayers()) );
		}
	}
}