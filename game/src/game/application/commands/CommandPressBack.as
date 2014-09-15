package game.application.commands
{
	import game.application.ApplicationEvents;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CommandPressBack extends SimpleCommand
	{
		public function CommandPressBack()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			this.sendNotification(ApplicationEvents.USER_PRESS_BACK);
		}
	}
}