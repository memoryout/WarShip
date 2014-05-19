package game.application.commands.server
{
	import game.application.ProxyList;
	import game.application.data.UserData;
	import game.application.interfaces.data.IUserDataProxy;
	import game.application.server.ServerResponce;
	import game.application.server.ServerResponceDataType;
	import game.application.server.data.AuthorizationData;
	import game.application.server.data.ResponceData;
	import game.application.startup.StartupProxy;
	import game.services.ServicesList;
	import game.services.interfaces.IServerConnection;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ServerRequestAuthorizationCommand extends SimpleCommand
	{
		public function ServerRequestAuthorizationCommand()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void
		{
			
		}
		
		
		
	}
}