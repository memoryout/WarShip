package game.application.commands.startup
{
	import game.application.ProxyList;
	import game.application.startup.StartupProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class UserDataProxyConnectedProxy extends SimpleCommand
	{
		public function UserDataProxyConnectedProxy()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void
		{
			var startup:StartupProxy = this.facade.retrieveProxy(ProxyList.STARTUP_PROXY) as StartupProxy;
			startup.userDataConnected();
		}
	}
}