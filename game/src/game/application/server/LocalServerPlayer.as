package game.application.server
{
	import game.application.connection.ActionsQueue;

	public class LocalServerPlayer
	{
		private var _id:			String;
		
		public function LocalServerPlayer(id:String)
		{
			_id = id;
		}
		
		
		public function get id():String
		{
			return _id
		}
	}
}