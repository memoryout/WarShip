package game.application.connection.actions
{
	import game.application.connection.ActionQueueData;
	
	public class HitInfoData extends ActionQueueData
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