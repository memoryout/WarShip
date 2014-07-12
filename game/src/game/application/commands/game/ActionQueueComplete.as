package game.application.commands.game
{
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	import game.application.interfaces.game.IGameProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ActionQueueComplete extends SimpleCommand
	{
		public function ActionQueueComplete()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var mainAppProxy:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			
			var currentGame:IGameProxy = mainAppProxy.getCurrentGame();
			currentGame.processActionsQueue();
		}
	}
}