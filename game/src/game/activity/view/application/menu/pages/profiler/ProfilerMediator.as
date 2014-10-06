package game.activity.view.application.menu.pages.profiler
{
	import flash.display.DisplayObjectContainer;
	
	import game.activity.view.application.menu.MenuPageMediator;
	
	public class ProfilerMediator extends MenuPageMediator
	{
		public static const NAME:			String = "mediator.menu.pages.profiler";
		
		private var _page:					ProfilerView;
		
		public function ProfilerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			_page = new ProfilerView();
			(viewComponent as DisplayObjectContainer).addChild( _page );
		}
		
		
		override public function hide():void
		{
			this.facade.removeMediator( NAME );
			
			_page.close();
			_page = null;
		}
	}
}