package game.application.data.game
{
	import flash.utils.Dictionary;

	public class BattleField
	{
		private const _fieldCeilCache:		Dictionary = new Dictionary();
		
		public function BattleField()
		{
			
		}
		
		public function init(width:uint, height:uint):void
		{
			var i:int, j:int;
			for(i = 0; i < width; i++)
			{
				for(j = 0; j < height; j++)
				{
					_fieldCeilCache[i + "_" + j] = FieldCeilValues.WATER;
				}
			}
		}
		
		
		public function setShips(v:Vector.<ShipData>):void
		{
			var i:int,j:int, coords:Vector.<ShipPositionPoint>;
			
			for(i = 0; i < v.length; i++)
			{
				coords = v[i].coopdinates;
				
				for(j = 0; j < coords.length; j++)
				{
					_fieldCeilCache[coords[i].x + "_" + coords[i].y] = v[i];
				}
			}
		}
		
		public function setHit(x:uint, y:uint, status:uint):void
		{
			if(status == 2) status = 1;
			_fieldCeilCache[x + "_" + y] = status;
		}
		
		
		public function isWaterCeil(x:int, y:int):Boolean
		{
			return _fieldCeilCache[x + "_" + y] == FieldCeilValues.WATER;
		}
		
		
		public function pushShip(ship:ShipData):Vector.<ShipPositionPoint>
		{
			var i:int,j:int, coords:Vector.<ShipPositionPoint>, points:Vector.<ShipPositionPoint>;
			
			points = new Vector.<ShipPositionPoint>;
			coords = ship.coopdinates;
			
			for(i = 0; i < coords.length; i++)
			{
				_fieldCeilCache[coords[i].x + "_" + coords[i].y] = ship;
				
				if(ship.dirrection == ShipDirrection.HORIZONTAL)
				{
					if(i == 0)
					{
						setFieldPointValue(coords[i].x - 1, coords[i].y - 1, FieldCeilValues.EMPTY_HIT, points);
						setFieldPointValue(coords[i].x - 1, coords[i].y + 1, FieldCeilValues.EMPTY_HIT, points);
						setFieldPointValue(coords[i].x - 1, coords[i].y, FieldCeilValues.EMPTY_HIT, points);
					}
					
					if(i == coords.length - 1)
					{
						setFieldPointValue(coords[i].x + 1, coords[i].y - 1, FieldCeilValues.EMPTY_HIT, points);
						setFieldPointValue(coords[i].x + 1, coords[i].y + 1, FieldCeilValues.EMPTY_HIT, points);
						setFieldPointValue(coords[i].x + 1, coords[i].y, FieldCeilValues.EMPTY_HIT, points);
					}
					
					setFieldPointValue(coords[i].x, coords[i].y - 1, FieldCeilValues.EMPTY_HIT, points);
					setFieldPointValue(coords[i].x, coords[i].y + 1, FieldCeilValues.EMPTY_HIT, points);
					
				}
				else
				{
					if(i == 0)
					{
						setFieldPointValue(coords[i].x - 1, coords[i].y - 1, FieldCeilValues.EMPTY_HIT, points);
						setFieldPointValue(coords[i].x + 1, coords[i].y - 1, FieldCeilValues.EMPTY_HIT, points);
						setFieldPointValue(coords[i].x, coords[i].y - 1, FieldCeilValues.EMPTY_HIT, points);
					}
					
					if(i == coords.length - 1)
					{
						setFieldPointValue(coords[i].x - 1, coords[i].y + 1, FieldCeilValues.EMPTY_HIT, points);
						setFieldPointValue(coords[i].x + 1, coords[i].y + 1, FieldCeilValues.EMPTY_HIT, points);
						setFieldPointValue(coords[i].x, coords[i].y + 1, FieldCeilValues.EMPTY_HIT, points);
					}
					
					setFieldPointValue(coords[i].x - 1, coords[i].y, FieldCeilValues.EMPTY_HIT, points);
					setFieldPointValue(coords[i].x + 1, coords[i].y, FieldCeilValues.EMPTY_HIT, points);
				}
			}
			
			return points;
		}
		
		private function setFieldPointValue(x:int, y:int, value:int, points:Vector.<ShipPositionPoint>):void
		{
			if(x >= 0 && x <= 9 && y >= 0 && y <= 9)
			{
				if(_fieldCeilCache[x + "_" + y] != value)
				{
					_fieldCeilCache[x + "_" + y] = value;
					points.push( new ShipPositionPoint(x, y) );
				}
			}
		}
		
		
		private function pushPoint(v:Vector.<ShipPositionPoint>, x:Number, y:Number):void
		{
			var point:ShipPositionPoint = new ShipPositionPoint(x, y);
			v.push(point);
		}
	}
}