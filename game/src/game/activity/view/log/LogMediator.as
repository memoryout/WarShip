package game.activity.view.log
{
	import flash.display.DisplayObjectContainer;
	
	import game.activity.BaseMediator;
	import game.application.BaseProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class LogMediator extends BaseMediator
	{
		public static const NAME:			String = "mediator.log"
		
		private var _view:					LogView;
			
		public function LogMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			_view = new LogView();
			(viewComponent as DisplayObjectContainer).addChild( _view );
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [
						BaseProxy.LOG_MESSAGE
					]
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			_view.addMessage(notification.getBody() as String);
		}
		
		
		
	}
}