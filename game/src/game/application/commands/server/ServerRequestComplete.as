package game.application.commands.server
{
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	import game.application.interfaces.game.IGameProxy;
	import game.application.server.ServerResponce;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ServerRequestComplete extends SimpleCommand
	{
		public function ServerRequestComplete()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var mainAppProxy:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			
			var currentGame:IGameProxy = mainAppProxy.getCurrentGame();
			currentGame.receiveServerResponce( notification.getBody() as ServerResponce);
		}
	}
}