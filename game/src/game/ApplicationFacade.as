package game
{
	import flash.display.Stage;
	
	import game.application.ApplicationCommands;
	import game.application.ApplicationEvents;
	import game.application.commands.ApplicationCloseCommand;
	import game.application.commands.BootCommand;
	import game.application.commands.CommandPressBack;
	
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.observer.Notification;
	
	public class ApplicationFacade extends Facade
	{	
		public function ApplicationFacade()
		{
			super();
		}
		
		
		public function startup(stage:Stage):void
		{
			this.notifyObservers( new Notification("boot", stage) );
		}
		
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			this.registerCommand(ApplicationCommands.USER_PRESS_BACK, CommandPressBack); 
			
			this.registerCommand("boot", BootCommand); 
			this.registerCommand(ApplicationCommands.APPLICATION_CLOSE, ApplicationCloseCommand); 
		}
		
		
		public static function getInstance():ApplicationFacade
		{
			if(instance == null) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		
		public function applicationClosed():void
		{
			this.notifyObservers( new Notification(ApplicationCommands.APPLICATION_CLOSE) );
		}
		
		
		public function userPressBack():void
		{
			
			this.notifyObservers( new Notification(ApplicationCommands.USER_PRESS_BACK) );
		}
	}
}