package game.activity.view.application.windows.sign_in
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.activity.BaseMediator;
	import game.application.ApplicationCommands;
	
	public class SignInWindowMediatior extends BaseMediator
	{
		public static const NAME:			String = "mediator.windows.sign_in"
		
		private var _view:				SignInWindow;
			
		public function SignInWindowMediatior(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			_view = new SignInWindow();
			(viewComponent as DisplayObjectContainer).addChild( _view );
			
			_view.addEventListener(Event.COMPLETE, handlerSelectName);
		}
		
		
		private function handlerSelectName(e:Event):void
		{
			this.sendNotification(ApplicationCommands.STARTUP_SET_LOGIN, _view.getValue() );
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