package game.activity.view.preloader
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import game.activity.BaseMediator;
	import game.application.ApplicationEvents;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PreloaderMediator extends BaseMediator
	{
		public static const NAME:			String = "mediator.preloader";
		
		private var _view:				PreloaderView;
		
		public function PreloaderMediator(view:Object = null)
		{
			super(NAME, view);
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationEvents.START_UP_COMPLETE];
		}
		
		
		override public function onRegister():void
		{
			_view = new PreloaderView();
			(viewComponent as DisplayObjectContainer).addChild( _view );
		}
		
		
		override public function onRemove():void
		{
			_view = null;
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case ApplicationEvents.START_UP_COMPLETE:
				{
					hidePreloader();
					break;
				}
			}
		}
		
		
		
		private function hidePreloader():void
		{
			(viewComponent as DisplayObjectContainer).removeChild( _view );
			
			this.facade.removeMediator(NAME);
		}
	}
}