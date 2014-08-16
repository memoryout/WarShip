package game.application.connection.data
{
	import game.application.connection.ChannelData;
	import game.application.connection.ChannelDataType;
	
	public class UserInfoData extends ChannelData
	{
		public var exp:				Number;
		public var games_lose:		Number;
		public var games_won:		Number;
		public var rank:			int;
		public var ships_destroyed:	uint;
		
		public function UserInfoData()
		{
			super(ChannelDataType.USER_INFO);
		}
	}
}