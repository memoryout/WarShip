package game.application.commands
{
	import game.services.ServicesList;
	import game.services.interfaces.ISQLManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ApplicationCloseCommand extends SimpleCommand
	{
		public function ApplicationCloseCommand()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void
		{
			var sql:ISQLManager = ServicesList.getSearvice(ServicesList.SQL_MANAGER) as ISQLManager;
			sql.closeConnection();
		}
	}
}