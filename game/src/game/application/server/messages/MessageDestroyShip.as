package game.application.server.messages
{
	public class MessageDestroyShip extends MessageData
	{
		public var deck:uint;
		
		public var startX:			int;
		public var startY:			int;
		
		public var finishX:			int;
		public var finishY:			int;
		
		public var currentX:		int;
		public var currentY:		int;
		
		public function MessageDestroyShip(type:uint, player:String)
		{
			super(type, player);
		}
	}
}