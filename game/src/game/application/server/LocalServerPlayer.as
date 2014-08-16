package game.application.server
{
	import flash.utils.Dictionary;
	
	import game.application.connection.ServerDataChannel;

	public class LocalServerPlayer
	{
		private var _id:			String;
		
		private const _gameField:	Dictionary = new Dictionary();
		
		public function LocalServerPlayer(id:String)
		{
			_id = id;
		}
		
		
		public function get id():String
		{
			return _id;
		}
		
		
		public function createShips(data:Array):void
		{
			var i:int, j:int;
			var ship:LocalServerShip;
			
			for(i = 0; i < data.length; i++)
			{
				ship = new LocalServerShip();
				ship.setCoords( data[i] );
				
				trace(data[i]);
			}
		}
		
		
		public function isReadyToStart():Boolean
		{
			return true;
		}
	}
}