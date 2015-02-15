package game.application.connection.data
{
	public class UserInfo
	{
		public var uid:					uint;
		public var name:				String;
		public var status:				uint;
		public var flag:				uint;
		public var userpic:				uint;
		public var a_ships_skins:		Array;
		public var a_userpics:			Array;
		public var a_flags:				Array;
		
		public var expInfo:				ExperienceInfo;
		
		public function UserInfo()
		{
		}
	}
}