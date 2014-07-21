package game.application.commands.game
{
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class FinishCurrentGameCommand extends SimpleCommand
	{
		public function FinishCurrentGameCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var app:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			app.finishCurrentGame();
			
			
		}
	}
}