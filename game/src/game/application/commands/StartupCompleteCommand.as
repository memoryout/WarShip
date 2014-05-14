package game.application.commands
{
	import game.application.ApplicationEvents;
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	import game.application.startup.StartupProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartupCompleteCommand extends SimpleCommand
	{
		public function StartupCompleteCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var startup:StartupProxy = this.facade.retrieveProxy(ProxyList.STARTUP_PROXY) as StartupProxy;
			startup.destroy();
			this.facade.removeProxy( ProxyList.STARTUP_PROXY );
			
			this.sendNotification(ApplicationEvents.START_UP_COMPLETE);
			
			var application:IMainApplicationProxy = this.facade.retrieveProxy( ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			application.runApplication();
		}
	}
}