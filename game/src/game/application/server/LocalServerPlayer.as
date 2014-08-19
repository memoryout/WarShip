package game.application.server
{
	import flash.utils.Dictionary;
	
	import game.application.connection.ServerDataChannel;

	public class LocalServerPlayer
	{
		private var _id:			String;
		
		private const _ships:		Vector.<LocalServerShip> = new Vector.<LocalServerShip>;
		
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
			
			trace("-----------------", id, data.length);
			for(i = 0; i < data.length; i++)
			{
				trace("set", data[i]);
				ship = new LocalServerShip();
				ship.setCoords( data[i] );
				
				_ships.push( ship );
			}
		}
		
		public function tryHit(x:uint, y:uint):Boolean
		{
			var res:Boolean = false;
			
			var i:int;
			for(i = 0; i < _ships.length; i++)
			{
				res = _ships[i].tryToDrown(x, y);
				if(res) break;
			}
			
			return res;
		}
		
		
		public function isReadyToStart():Boolean
		{
			return _ships.length > 0;
		}
	}
}