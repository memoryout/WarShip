package game.application.data.game
{
	public class ShipData
	{
		private static  var _globalId:			uint = 0;
		
		public const id:			uint = _globalId ++;
				
		private var _coordinates:	Vector.<uint>;
		private var _deck:			uint;
		private var _x:				int;
		private var _y:				int;
		private var _dirrection:	uint;
		
		public function ShipData()
		{
			_x = _y = _deck = 0;
			
			_coordinates = new Vector.<uint>
		}
		
		
		public function set dirrection(value:uint):void
		{
			_dirrection = value;
			updateCoordinates();
		}
		
		public function get dirrection():uint
		{
			return _dirrection;
		}
		
		
		public function set deck(value:uint):void
		{
			_deck = value;
			updateCoordinates();
		}
		
		public function get deck():uint
		{
			return _deck;
		}
		
		public function set x(value:int):void
		{
			_x = value;
			updateCoordinates();
		}
		
		public function get x():int
		{
			return _x;
		}
		
		public function set y(value:int):void
		{
			_y = value;
			updateCoordinates();
		}
		
		public function get y():int
		{
			return _y;
		}
		
		
		private function updateCoordinates():void
		{
			
		}
	}
}