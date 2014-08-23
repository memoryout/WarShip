package game.application.server
{
	public class LocalServerShip
	{
		public var deck:		uint;
		
		private const _coordX:	Vector.<uint> = new Vector.<uint>;
		private const _coordY:	Vector.<uint> = new Vector.<uint>;
		private const _state:	Vector.<uint> = new Vector.<uint>;
		
		private var _isSank:	Boolean;
		
		public function LocalServerShip()
		{
			deck = 0;
			_isSank = false;
		}
		
		public function setCoords(arr:Array):void
		{
			var i:int;
			
			if(arr[0][0] == arr[1][0] && arr[0][1] == arr[1][1])
			{
				deck = 1;
				_coordX.push(arr[0][0]);
				_coordY.push(arr[0][1]);
				_state[ 0 ] = 0;
			}
			else
			{
				if(arr[0][0] == arr[1][0])
				{
					for(i = arr[0][1]; i <= arr[1][1]; i++)
					{
						_coordX[ deck ] = arr[0][0];
						_coordY[ deck ] = i;
						_state[ deck ] = 0;
						deck ++;
					}
				}
				else 
				{
					for(i = arr[0][0]; i <= arr[1][0]; i++)
					{
						_coordX[ deck ] = i;
						_coordY[ deck ] = arr[0][1];
						_state[ deck ] = 0;
						deck ++;
					}
				}
			}
		}
		
		
		public function tryToDrown(x:uint, y:uint):Boolean
		{
			var res:Boolean = false;
			var i:uint;
			for(i = 0; i < _coordX.length; i++)
			{
				if( _coordX[i] == x && _coordY[i] == y )
				{
					_state[i] = 1;
					res = true;
					break;
				}
			}
			
			if( _state.indexOf(0) == -1 ) _isSank = true;
			
			return res;
		}
		
		public function thisShipIsSank(x:uint, y:uint):Boolean
		{
			var res:Boolean = false;
			var i:uint;
			for(i = 0; i < _coordX.length; i++)
			{
				if( _coordX[i] == x && _coordY[i] == y )
				{
					res = _isSank;
					break;
				}
			}
			
			return res;
		}
		
		public function isSank():Boolean
		{
			return _isSank;
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