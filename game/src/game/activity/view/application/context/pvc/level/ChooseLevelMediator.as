package game.activity.view.application.context.pvc.level
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.application.ApplicationCommands;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ChooseLevelMediator extends Mediator
	{
		public static const NAME:			String = "pvc.window.choose_level";
		
		private var _view:			ChooseLevelView;
		
		public function ChooseLevelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			
			createViewInstance();
			
		}
		
		
		private function createViewInstance():void
		{
			_view = new  ChooseLevelView();
			(viewComponent as DisplayObjectContainer).addChild( _view );
			
			_view.init();
			_view.addEventListener(ChooseLevelView.CHOOSE, handlerChoose);
		}
		
		private function handlerChoose(e:Event):void
		{
			_view.removeEventListener(ChooseLevelView.CHOOSE, handlerChoose);
			
			this.sendNotification(ApplicationCommands.USER_CHOOSE_DIFFICULT_LEVEL, _view.selectedLevel );
			
			(viewComponent as DisplayObjectContainer).removeChild( _view );
			this.facade.removeMediator(NAME);
		}
	}
}