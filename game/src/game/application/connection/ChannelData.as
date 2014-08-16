package game.application.connection
{
	public class ChannelData
	{
		protected var _type:				uint;
		
		public function ChannelData(type:uint = 0)
		{
			if(type) _type = type;
		}
		
		
		public function get type():uint
		{
			return _type;
		}
	}
}