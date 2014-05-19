package game.activity.view.application.menu.pages.game_type
{
	import flash.display.DisplayObjectContainer;
	
	import game.activity.BaseMediator;
	
	public class SelectGameTypeMediator extends BaseMediator
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
		}
	}
}