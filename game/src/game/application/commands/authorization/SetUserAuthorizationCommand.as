package game.application.commands.authorization
{
	import game.application.ApplicationCommands;
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
			var name:String = notification.getName();
			
			var startup:StartupProxy = this.facade.retrieveProxy(ProxyList.STARTUP_PROXY) as StartupProxy;
			
			switch(name)
			{
				case ApplicationCommands.STARTUP_SELECT_USER:
				{
					startup.setCurrentUser( uint( notification.getBody() ) );
					break;
				}
					
				case ApplicationCommands.STARTUP_SET_LOGIN:
				{
					startup.setUserAuthorizationData(notification.getBody() as String);
					break;
				}
			}
		}
	}
}