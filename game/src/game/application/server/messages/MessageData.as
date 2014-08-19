package game.application.server.messages
{
	public class MessageData
	{
		public var type:				uint;
		public var player:				String;
		
		public function MessageData(type:uint, player:String)
		{
			this.type = type;
			this.player = player;
		}
	}
}