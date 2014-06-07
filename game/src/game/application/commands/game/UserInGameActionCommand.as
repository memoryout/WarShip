package game.application.commands.game
{
	import game.application.ApplicationCommands;
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	import game.application.interfaces.game.IGameProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class UserInGameActionCommand extends SimpleCommand
	{
		public function UserInGameActionCommand()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case ApplicationCommands.USER_HIT_POINT:
				{
					hitPoint(notification.getBody())
					break;
				}
			}
		}
		
		
		
		private function hitPoint(data:Object):void
		{
			var mainAppProxy:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			
			var currentGame:IGameProxy = mainAppProxy.getCurrentGame();
			currentGame.hitPoint( data.x, data.y);
		}
	}
}