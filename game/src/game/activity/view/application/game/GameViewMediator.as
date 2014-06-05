package game.activity.view.application.game
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.activity.BaseMediator;
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	import game.core.IGameProxy;
	
	public class GameViewMediator extends BaseMediator
	{
		public static const NAME:			String = "mediator.game.main_mediator";
		
		private var _gameView:				GameView;
		
		private var _gameProxy:				IGameProxy;
		
		public function GameViewMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			_gameView = new GameView();
			(viewComponent as DisplayObjectContainer).addChild( _gameView );
			
			_gameView.addEventListener(GameView.SELECT_OPPONENT_CEIL, handlerSelectCeil);
		}
		
		private function handlerSelectCeil(e:Event):void
		{
			trace(_gameView.ceilX, _gameView.ceilY);
		}
	}
}