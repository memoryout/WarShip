package game.activity.view.application.windows
{
	import flash.display.DisplayObjectContainer;
	
	import game.activity.BaseMediator;
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
						ApplicationEvents.REQUIRED_USER_AUTHORIZATION
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
			}
		}
		
		
		private function showAuthorizationWindow():void
		{
			this.facade.registerMediator( new SignInWindowMediatior(_view.getAlertsLayers()) );
		}
	}
}