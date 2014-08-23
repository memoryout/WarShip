package game.application.server.messages
{
	public class MessageHit extends MessageData
	{
		public var x:			uint;
		public var y:			uint;
		
		public function MessageHit(type:uint, player:String)
		{
			super(type, player);
		}
		
		
	}
}