package game.application.connection.data
{
	import game.application.connection.ChannelData;
	
	public class DestroyShipData extends ChannelData
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