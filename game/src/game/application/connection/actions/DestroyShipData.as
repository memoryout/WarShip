package game.application.connection.actions
{
	import game.application.connection.ActionQueueData;
	
	public class DestroyShipData extends ActionQueueData
	{
		public var decks:			int;
		public var status:			int;
		
		public var startX:			int;
		public var startY:			int;
		
		public var finishX:			int;
		public var finishY:			int;
		
		public function DestroyShipData(type:uint)
		{
			super(type);
		}
	}
}