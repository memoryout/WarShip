package game.application.server.data
{
	import game.application.server.ServerResponceDataType;

	public class ErrorResponce extends ResponceData
	{
		public var code:			uint;
		public var description:		String;
		public var severity:		int;
		
		public function ErrorResponce()
		{
			super();
		}
		
		override public function get responceDataType():String
		{
			return ServerResponceDataType.ERROR;
		}
	}
}