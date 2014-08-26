package game.application.data.game
{
	public class ShipData
	{
		private static  var _globalId:			uint = 0;
		
		public const id:			uint = _globalId ++;
				
		private var _coordinates:	Vector.<ShipPositionPoint>;
		private var _deck:			uint;
		private var _x:				int;
		private var _y:				int;
		private var _dirrection:	uint;
		private var _id:			uint;
		
		public function ShipData()
		{
			_x = _y = _deck = 0;
			
			_coordinates = new Vector.<ShipPositionPoint>
		}
		
		
		public function set dirrection(value:uint):void
		{
			_dirrection = value;
		}
		
		public function get dirrection():uint
		{
			return _dirrection;
		}
		
		
		public function set deck(value:uint):void
		{
			_deck = value;
		}
		
		public function get deck():uint
		{
			return _deck;
		}
		
		public function set x(value:int):void
		{
			_x = value;
		}
		
		public function get x():int
		{
			return _x;
		}
		
		public function set y(value:int):void
		{
			_y = value;
		}
		
		public function get y():int
		{
			return _y;
		}
		
		public function get coopdinates():Vector.<ShipPositionPoint>
		{
			updateCoordinates();
			
			return _coordinates;
		}
		
		public function set idx(value:int):void
		{
			_id = value;
		}
		
		public function get idx():int
		{
			return _id;
		}		
		
		private function updateCoordinates():void
		{
			var i:int, point:ShipPositionPoint;
			
			
			if(_coordinates.length > _deck) _coordinates.length = _deck;
			
			for(i = 0; i < _deck; i++)
			{
				if(i >= _coordinates.length)
				{
					point = new ShipPositionPoint();
					_coordinates[i] = point;
				}
				
				point = _coordinates[i];
				
				if(_dirrection == ShipDirrection.HORIZONTAL) 
				{
					point.x = _x + i;
					point.y = _y;
				}
				else
				{
					point.x = _x;
					point.y = _y + i;
				}
			}
		}
	}
}