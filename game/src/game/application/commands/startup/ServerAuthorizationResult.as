package game.application.commands.startup
{
	import game.application.ProxyList;
	import game.application.connection.ActionQueueData;
	import game.application.connection.ActionType;
	import game.application.connection.actions.AuthorizationData;
	import game.application.data.user.UserData;
	import game.application.interfaces.actions.IActionsQueue;
	import game.application.interfaces.data.IUserDataProxy;
	import game.application.startup.StartupProxy;
	import game.services.ServicesList;
	import game.services.interfaces.IServerConnection;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ServerAuthorizationResult extends SimpleCommand
	{
		public function ServerAuthorizationResult()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void
		{
			var actionsQueue:IActionsQueue = notification.getBody() as IActionsQueue;
			
			var action:ActionQueueData;
			
			action = actionsQueue.getNextAction();
			while( action )
			{
				if(action.type == ActionType.AUTHORIZATION) 
				{
					updateUserAuthorizationData(action as AuthorizationData);
				}
				
				action = actionsQueue.getNextAction();
			}
			
			var startup:StartupProxy = this.facade.retrieveProxy(ProxyList.STARTUP_PROXY) as StartupProxy;
			if(startup)
			{
				startup.handlerSignInComplete();
			}
		}
		
		private function updateUserAuthorizationData(data:AuthorizationData):void
		{
			var userProxy:IUserDataProxy = this.facade.retrieveProxy(ProxyList.USER_DATA_PROXY) as IUserDataProxy;
			
			if(userProxy)
			{
				var userData:UserData = userProxy.getUserData();
				
				if(data.login && userData.getValue("login") != data.login) userData.setValue("login", data.login);
				if(data.pass && userData.getValue("pass") != data.pass) userData.setValue("pass", data.pass);
				
				userProxy.commitChanges();
			}
			
			
			var serverConnection:IServerConnection = ServicesList.getSearvice( ServicesList.SERVER_CONNECTION ) as IServerConnection;
			if(serverConnection)
			{
				serverConnection.setSessionKey( data.session );
			}
		}
	}
}