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
		
		
		public function testCollision(ship:ShipData, shipList:Vector.<ShipData>):Vector.<GamePoint>
		{
			var i:int, point:GamePoint, collisionRect:Rectangle, j:int;
			
			const tempRect:Rectangle = new Rectangle();
			const shipRect:Rectangle = new Rectangle();
			
			const v:Vector.<GamePoint> = new Vector.<GamePoint>;
			
			shipRect.x = ship.x - 1;
			shipRect.y = ship.y - 1;
			
			if(ship.dirrection == ShipDirrection.HORIZONTAL)
			{
				shipRect.width = ship.deck + 2;
				shipRect.height = 3;
			}
			else
			{
				shipRect.width = 3
				shipRect.height = ship.deck + 2;;
			}
			
			for(i = 0; i < shipList.length; i++)
			{
				if( shipList[i] != ship )
				{
					tempRect.x = shipList[i].x;
					tempRect.y = shipList[i].y;
					
					if(shipList[i].dirrection == ShipDirrection.HORIZONTAL)
					{
						tempRect.width = shipList[i].deck;
						tempRect.height = 1;
					}
					else
					{
						tempRect.height = shipList[i].deck;
						tempRect.width = 1;
					}
					
					collisionRect = shipRect.intersection( tempRect );
					
					if(collisionRect.width)
					{
						for(j = 0; j < collisionRect.width; j++)
						{
							point = new GamePoint();
							point.x = collisionRect.x + j;
							point.y = collisionRect.y;
							
							v.push( point );
						}
						
						for(j = 1; j < collisionRect.height; j++)
						{
							point = new GamePoint();
							point.x = collisionRect.x;
							point.y = collisionRect.y + j;
							
							v.push( point );
						}
					}
				}
			}
			
			return v;
			
		}
	}
}