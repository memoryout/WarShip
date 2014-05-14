package game.application.commands.authorization
{
	import game.application.ProxyList;
	import game.application.startup.StartupProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetUserAuthorizationCommand extends SimpleCommand
	{
		public function SetUserAuthorizationCommand()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void
		{
			var startup:StartupProxy = this.facade.retrieveProxy(ProxyList.STARTUP_PROXY) as StartupProxy;
			startup.setUserAuthorizationData(notification.getBody() as String);
		}
	}
}