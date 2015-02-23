package game.application.server
{
	import flash.utils.Dictionary;
	
	import game.application.connection.ServerDataChannel;

	public class LocalServerPlayer
	{
		private var _id:			String;
		
		private const _ships:		Vector.<LocalServerShip> = new Vector.<LocalServerShip>;
		
		public var points:			uint;
		
		public function LocalServerPlayer(id:String)
		{
			_id = id;
			points = 0;
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
				
				_ships.push( ship );
			}
		}
		
		public function tryHit(x:uint, y:uint):LocalServerShip
		{
			var res:LocalServerShip;
			
			var i:int;
			for(i = 0; i < _ships.length; i++)
			{
				if( !_ships[i].isSank() && _ships[i].tryToDrown(x, y) )
				{
					res = _ships[i];
					break;
				}
			}
			
			return res;
		}
		
		
		public function isShipDestroyed( x:uint, y:uint ):Boolean
		{
			var res:Boolean = false;
			
			var i:int;
			for(i = 0; i < _ships.length; i++)
			{
				res = _ships[i].thisShipIsSank(x, y);
				if(res) break;
			}
			
			return res;
		}
		
		public function isPlayerDefeat():Boolean
		{
			var res:Boolean = true;
			
			var i:int;
			for(i = 0; i < _ships.length; i++)
			{
				if( !_ships[i].isSank() )
				{
					res = false;
					break;
				}
			}
			
			return res;
		}
		
		public function getPoints():uint
		{
			var res:uint = 0;
			
			var i:int;
			for(i = 0; i < _ships.length; i++)
			{
				res += _ships[i].getDestroyedDeckNumber();
			}
			
			return res;
		}
		
		
		public function isReadyToStart():Boolean
		{
			return _ships.length > 0;
		}
	}
}