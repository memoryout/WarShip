package game.application.server
{
	public class LocalServerShip
	{
		public var deck:		uint;
		
		private const _coordX:	Vector.<uint> = new Vector.<uint>;
		private const _coordY:	Vector.<uint> = new Vector.<uint>;
		
		public function LocalServerShip()
		{
			deck = 0;
		}
		
		public function setCoords(arr:Array):void
		{
			var i:int;
			
			if(arr[0] == arr[2])
			{
				for(i = arr[1]; i < arr[3]; i++)
				{
					_coordX[ deck ] = arr[0];
					_coordY[ deck ] = i;
					deck ++;
				}
			}
			else if(arr[1] == arr[3])
			{
				for(i = arr[0]; i < arr[2]; i++)
				{
					_coordX[ deck ] = arr[1];
					_coordY[ deck ] = i;
					deck ++;
				}
			}
			else
			{
				deck = 1;
				_coordX.push(arr[0]);
				_coordY.push(arr[1]);
			}
		}
		
		public function getX(id:uint):uint
		{
			if(id < _coordX.length) return _coordX[id];
			return 0;
		}
		
		public function getY(id:uint):uint
		{
			if(id < _coordY.length) return _coordY[id];
			return 0;
		}
	}
}