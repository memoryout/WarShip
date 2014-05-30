package game.utils
{
	import flash.geom.Rectangle;
	
	import game.application.data.game.ShipData;
	import game.application.data.game.ShipDirrection;

	public class ShipPositionSupport
	{
		private static var _instance:			ShipPositionSupport = new ShipPositionSupport();
		
		public function ShipPositionSupport()
		{
			
		}
		
		
		public static function getInstance():ShipPositionSupport
		{
			return _instance;
		}
		
		
		public function shipsAutoArrangement(ships:Vector.<ShipData>, gameFieldWidth:uint, gameFieldHeight:uint):void
		{
			var placedShips:Vector.<Rectangle> = new Vector.<Rectangle>;
			
			var t:Number = new Date().time;
			
			var i:int, rect:Rectangle, j:int, placed:Boolean;
			for(i = 0; i < ships.length; i++)
			{
				placed = false;
				
				while(!placed)
				{
					rect = new Rectangle();
					
					if(Math.random() >= 0.5)
					{
						rect.width = ships[i].deck + 2;
						rect.height = 3;
						ships[i].dirrection = ShipDirrection.HORIZONTAL;
						
						
					}
					else
					{
						rect.width = 3;
						rect.height = ships[i].deck + 2;
						ships[i].dirrection = ShipDirrection.VERTICAL;
						
						
					}
					
					placed = true;
					
					rect.x = Math.round( Math.random() * (gameFieldWidth + 2 - rect.width) );
					rect.y = Math.round( Math.random() * (gameFieldHeight + 2 - rect.height) );	
					
					
					for(j = 0; j < placedShips.length; j++)
					{
						if( rect.intersects(placedShips[j]) )
						{
							placed = false;
							break;
						}
					}
						
					if(placed)
					{
						ships[i].x = rect.x;
						ships[i].y = rect.y;
						
						rect.x += 1;
						rect.y += 1;
						rect.width -= 2;
						rect.height -= 2;
						
						placedShips.push(rect);	
						break;
					}
				}
			}
		}
	}
}