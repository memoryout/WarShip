package game.activity.view
{
	import flash.display.Stage;
	
	import game.activity.view.application.ApplicationMediator;
	import game.activity.view.application.LayoutManager;
	import game.activity.view.log.LogMediator;
	import game.activity.view.preloader.PreloaderMediator;
	import game.application.ApplicationCommands;
	import game.application.ApplicationEvents;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class BootStageMediator extends Mediator
	{
		private var _stage:				Stage;
		
		private var _appScreen:			AppScreen;
		
		public function BootStageMediator(stage:Stage)
		{
			super();
			
			_stage = stage;
		}
		
		override public function onRegister():void
		{
			buildView();
			
			var layoutManager:LayoutManager = new LayoutManager();
			_appScreen.getAppViewLayer().addChild( layoutManager );
			
			layoutManager.createActivitiLayout( ApplicationMediator );
			
			//this.facade.registerMediator( new ApplicationMediator(ApplicationMediator.NAME, _appScreen.getAppViewLayer() ) );
			
			
			createLogView();
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationEvents.START_UP_SOURCE_LOAD_COMPLETE,
					ApplicationEvents.START_UP_SOURCE_LOAD_ERROR,
					ApplicationEvents.REQUIRED_USER_AUTHORIZATION,
					ApplicationEvents.START_UP_COMPLETE
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case ApplicationEvents.START_UP_COMPLETE:
				{
					startUpComplete();
					break;
				}
				
				case ApplicationEvents.START_UP_SOURCE_LOAD_COMPLETE:
				{
					createPreloader();
					break;
				}
					
				case ApplicationEvents.START_UP_SOURCE_LOAD_ERROR:
				{
					break;
				}
			}
		}
		
		
		private function buildView():void
		{
			_appScreen = new AppScreen();
			_stage.addChild( _appScreen );
		}
		
		
		private function createPreloader():void
		{
			this.facade.registerMediator( new PreloaderMediator( _appScreen.getPreloaderLayer() ) );
		}
		
		
		private function startUpComplete():void
		{
			
		}
		
		
		private function createLogView():void
		{
			//this.facade.registerMediator( new LogMediator( _appScreen.getLogLayer() ) );
		}
	}
}