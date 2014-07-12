package game.application.connection.actions
{
	import game.application.connection.ActionQueueData;
	
	public class ErrorData extends ActionQueueData
	{
		public var code:			uint;
		public var description:		String;
		public var severity:		int;
		
		public function ErrorData(type:uint)
		{
			super(type);
		}
	}
}