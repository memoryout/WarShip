package game.application.commands.game
{
	import game.application.ProxyList;
	import game.application.game.MainGameProxy;
	import game.application.interfaces.IMainApplicationProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class UserShipsLocatedComlete extends SimpleCommand
	{
		public function UserShipsLocatedComlete()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void
		{
			var mainApp:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			var currentGameProxy:MainGameProxy = mainApp.getCurrentGame() as MainGameProxy;
			currentGameProxy.userLocatedShips();
		}
	}
}