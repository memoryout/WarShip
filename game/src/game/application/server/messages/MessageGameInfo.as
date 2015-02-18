package game.application.server.messages
{
	public class MessageGameInfo extends MessageData
	{
		public function MessageGameInfo(type:uint, player:String)
		{
			super(type, player);
		}
		
		public var userPoints:uint;
		public var opponentsPoint:uint;
	}
}