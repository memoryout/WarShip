package game.library
{
	public class LocalEvent
	{
		public var sender:		String;
		public var event:		uint;
		public var data:		*;
		
		public function LocalEvent(event:uint, sender:String = "", data:* = null)
		{
			 this.sender = sender;
			 this.event = event;
			 this.data = data;
		}
	}
}