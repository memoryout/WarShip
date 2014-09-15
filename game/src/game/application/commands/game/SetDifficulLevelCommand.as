package game.application.commands.game
{
	import game.application.ProxyList;
	import game.application.game.p_vs_computer.GameVSComputer;
	import game.application.interfaces.IMainApplicationProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SetDifficulLevelCommand extends SimpleCommand
	{
		public function SetDifficulLevelCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var level:int = notification.getBody() as int;
			
			var mainApp:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			var currentGameProxy:GameVSComputer = mainApp.getCurrentGame() as GameVSComputer;
			currentGameProxy.setDifficultLevel( level );
		}
	}
}