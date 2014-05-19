package game.activity.view.application.menu
{
	import flash.display.DisplayObjectContainer;
	
	import game.activity.BaseMediator;
	import game.activity.view.application.menu.pages.game_type.SelectGameTypeMediator;
	
	public class MenuMediator extends BaseMediator
	{
		public static const NAME:			String = "mediator.menu";
		
		private var _menuView:				MenuView;
		
		public function MenuMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			_menuView = new MenuView();
			(viewComponent as DisplayObjectContainer).addChild( _menuView );
			
			
			showSelectGameTypePage();
		}
		
		
		private function showSelectGameTypePage():void
		{
			this.facade.registerMediator( new SelectGameTypeMediator( _menuView.getMenuPageLayer() ) );
		}
	}
}