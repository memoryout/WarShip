package game.application.server.data
{
	import game.application.server.ServerResponceDataType;

	public class AuthorizationData extends ResponceData
	{
		public var login:		String;
		public var pass:		String;
		public var name:		String;
		public var session:		String;
		
		
		public function AuthorizationData()
		{
			
		}
		
		override public function get responceDataType():String
		{
			return ServerResponceDataType.AUTHORIZATION;
		}
	}
}