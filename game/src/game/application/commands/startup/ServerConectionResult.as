package game.application.commands.startup
{
	import game.application.ProxyList;
	import game.application.server.ServerConnectionProxyEvents;
	import game.application.startup.StartupProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ServerConectionResult extends SimpleCommand
	{
		public function ServerConectionResult()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void
		{
			var startup:StartupProxy = this.facade.retrieveProxy(ProxyList.STARTUP_PROXY) as StartupProxy;
			
			if(startup)
			{
				var name:String = notification.getName();
				
				switch(name)
				{
					case ServerConnectionProxyEvents.CONNECTION_COMPLETE:
					{
						startup.serverConnectionComplete();
						break;
					}
						
					case ServerConnectionProxyEvents.CONNECTION_ERROR:
					{
						break;
					}
				}
			}
		}
	}
}