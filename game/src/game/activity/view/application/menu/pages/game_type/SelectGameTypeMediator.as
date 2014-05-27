package game.activity.view.application.menu.pages.game_type
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.GameType;
	import game.activity.BaseMediator;
	import game.activity.view.application.menu.MenuPageMediator;
	import game.application.ApplicationCommands;
	
	public class SelectGameTypeMediator extends MenuPageMediator
	{
		public static const NAME:			String = "mediator.menu.pages.select_game_type";
		
		private var _page:					SelectGameTypeView;
		
		public function SelectGameTypeMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			_page = new SelectGameTypeView();
			(viewComponent as DisplayObjectContainer).addChild( _page );
			
			_page.addEventListener(SelectGameTypeView.COMPUTER, handlerSelectComputer);
			_page.addEventListener(SelectGameTypeView.PLAYER, handlerSelectPlayer);
		}
		
		
		override public function hide():void
		{
			this.facade.removeMediator( NAME );
			
			_page.removeEventListener(SelectGameTypeView.COMPUTER, handlerSelectComputer);
			_page.removeEventListener(SelectGameTypeView.PLAYER, handlerSelectPlayer);
			
			_page.close();
			_page = null;
		}
		
		private function handlerSelectComputer(e:Event):void
		{
			_page.removeEventListener(SelectGameTypeView.COMPUTER, handlerSelectComputer);
			_page.removeEventListener(SelectGameTypeView.PLAYER, handlerSelectPlayer);
			
			this.sendNotification(ApplicationCommands.CREATE_NEW_GAME, GameType.P_VS_C);
		}
		
		private function handlerSelectPlayer(e:Event):void
		{
			_page.removeEventListener(SelectGameTypeView.COMPUTER, handlerSelectComputer);
			_page.removeEventListener(SelectGameTypeView.PLAYER, handlerSelectPlayer);
			
			this.sendNotification(ApplicationCommands.CREATE_NEW_GAME, GameType.P_VS_P_NET);
		}
	}
}