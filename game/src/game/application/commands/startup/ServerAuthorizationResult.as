package game.application.commands.startup
{
	import game.application.ProxyList;
	import game.application.data.user.UserData;
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
	
	public class ServerAuthorizationResult extends SimpleCommand
	{
		public function ServerAuthorizationResult()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void
		{
			var responce:ServerResponce = notification.getBody() as ServerResponce;
			
			if(responce)
			{
				var dataList:Vector.<ResponceData> = responce.getDataList()
				
				var i:int;
				for(i = 0; i < dataList.length; i++)
				{
					switch(dataList[i].responceDataType)
					{
						case ServerResponceDataType.AUTHORIZATION:
						{
							updateUserAuthorizationData(dataList[i] as AuthorizationData);
							break;
						}
					}
				}
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