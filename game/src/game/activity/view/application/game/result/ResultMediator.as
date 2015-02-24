package game.activity.view.application.game.result
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.activity.BaseMediator;
	import game.application.ApplicationEvents;

	public class ResultMediator extends BaseMediator
	{		
		public static const NAME		:String = "game.activity.view.application.game.result.ResultMediator";
		private var resultView			:ResultView;
		
		public function ResultMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			resultView = new ResultView();
			viewComponent.addChild( resultView );
			
			addListener();
		}	
		
		private function addListener():void
		{
			resultView.addEventListener(ResultView.MENU, 		handlerMenu);
			resultView.addEventListener(ResultView.REVANGE, 	hendlerRevange);
			resultView.addEventListener(ResultView.PLAY_AGAIN,  hendlerPlayAgain);
		}
		
		private function removeListener():void
		{
			resultView.removeEventListener(ResultView.MENU, 		handlerMenu);
			resultView.removeEventListener(ResultView.REVANGE, 		hendlerRevange);
			resultView.removeEventListener(ResultView.PLAY_AGAIN,	hendlerPlayAgain);
		}
		
		private function handlerMenu(e:Event):void
		{
			removeListener();
			this.sendNotification(ApplicationEvents.START_UP_COMPLETE);
			this.facade.removeMediator(NAME);
		}
		
		private function hendlerRevange(e:Event):void
		{
			removeListener();
		}
		
		private function hendlerPlayAgain(e:Event):void
		{
			removeListener();
		}
		
		override public function onRemove():void
		{
			(viewComponent as DisplayObjectContainer).addChild( resultView );
			resultView.destroy();
			resultView = null;
		}
	}
}