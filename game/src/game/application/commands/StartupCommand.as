package game.application.commands
{
	import game.application.ApplicationEvents;
	import game.application.ProxyList;
	import game.application.startup.StartupProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartupCommand extends SimpleCommand
	{
		public function StartupCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var startupProxy:StartupProxy = new StartupProxy(ProxyList.STARTUP_PROXY);
			this.facade.registerProxy( startupProxy );
			
			this.facade.removeCommand( StartupProxy.STARTUP);
		}
	}
}