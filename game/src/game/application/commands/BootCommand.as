package game.application.commands
{
	import flash.display.Stage;
	
	import game.activity.view.BootStageMediator;
	import game.application.MainApplicationProxy;
	import game.application.ProxyList;
	import game.application.data.user.UserDataProxy;
	import game.application.server.ServerConnectionProxy;
	import game.application.startup.StartupProxy;
	import game.core.GameCoreManager;
	import game.services.ServicesList;
	import game.services.asset.AssetManager;
	import game.services.device.DeviceManager;
	import game.services.net.ServerConnectionInterface;
	import game.services.sql.SQLManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class BootCommand extends SimpleCommand
	{
		public function BootCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var stage:Stage = notification.getBody() as Stage;
			
			
			registerCommands();
			
			registerProxy();
			
			registerMediator(stage);
			
			
			this.sendNotification( StartupProxy.STARTUP );
		}
		
		
		private function registerCommands():void
		{
			this.facade.registerCommand( StartupProxy.STARTUP_COMPLETE, StartupCompleteCommand);
			this.facade.registerCommand( StartupProxy.STARTUP, StartupCommand);
		}
		
		
		private function registerMediator(stage:Stage):void
		{
			this.facade.registerMediator( new BootStageMediator(stage) );
		}
		
		
		private function registerProxy():void
		{
			SQLManager.init();
			DeviceManager.init();
			ServerConnectionInterface.init();
			AssetManager.init();
			
			this.facade.registerProxy(new UserDataProxy(ProxyList.USER_DATA_PROXY) );
			this.facade.registerProxy(new ServerConnectionProxy(ProxyList.SERVER_PROXY) );
			this.facade.registerProxy(new MainApplicationProxy(ProxyList.MAIN_APPLICATION_PROXY) );
		}
	}
}