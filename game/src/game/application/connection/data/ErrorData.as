package game.application.connection.data
{
	import game.application.connection.ChannelData;
	
	public class ErrorData extends ChannelData
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