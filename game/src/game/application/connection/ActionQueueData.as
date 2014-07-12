package game.application.connection
{
	public class ActionQueueData
	{
		protected var _type:				uint;
		
		public function ActionQueueData(type:uint = 0)
		{
			if(type) _type = type;
		}
		
		
		public function get type():uint
		{
			return _type;
		}
	}
}