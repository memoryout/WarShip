package game.application.data.game
{
	import flash.utils.Dictionary;

	public class BattleField
	{
		private const _fieldCeilCache:		Dictionary
		
		public function BattleField()
		{
			_fieldCeilCache = new Dictionary();
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
					_fieldCeilCache[i + "_" + j] = v[i];
				}
			}
		}
	}
}