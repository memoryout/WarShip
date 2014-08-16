package game.application.connection.data
{
	import game.application.connection.ChannelData;
	
	public class HitInfoData extends ChannelData
	{
		public var pointX:		int;
		public var pointY:		int;
		public var status:		int;
		
		public function HitInfoData(type:uint)
		{
			super(type);
		}
	}
}