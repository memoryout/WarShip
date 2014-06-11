package game.activity.view.application.menu.pages.ships_positions
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import game.activity.BaseMediator;
	import game.application.data.game.ShipData;
	import game.application.data.game.ShipDirrection;
	
	public class ShipsPositionsView extends Sprite
	{
		private const cellSize:				Number = 31.5;
		
		private const RED:					uint = 0xFF0000;
		private const WHITE:				uint = 0xFFFFFF;
		private const BLACK:				uint = 0x000000;
		private const GREEN:				uint = 0x66FF66;
		
		public static const AUTO_ARRANGEMENT:		String = "autoArrangement";
		public static const BACK:					String = "back";
		public static const NEXT:					String = "next";
		
		public static const SHIP_DRAG:				String = "ship_drag";			// отправляеться когда тягаем корабль по полю ( mouseMove(...) )
		private const _eventShipDrag:		Event = new Event(SHIP_DRAG);
		private var _shipCache:				Dictionary;								// кеш ссылок на корабли. Ключ - мувик корабля которые таскаем по полю, значение - связанный с этим кораблём ShipData.
		public var activeShip:				ShipData;								// задаёться когда начинаем таскать корабль.
		public var isColision:				Boolean;		
		
		private var _skin:			MovieClip;
		
		private var _ships:			Vector.<ShipData>;
		private var _shipPlaceholder:MovieClip;
		
		private var dragedShip:				MovieClip;
		private var rotatedShip:			MovieClip;
		
		private var initShipPoint:Point = new Point();		
		
		private var shipsLocationProcess:	ShipsLocationProcess = new ShipsLocationProcess();	
		
		private var isCleared:				Boolean;	
		private var canLocate:				Boolean;	
		private var tableIsAdd:				Boolean;	
		
		public function ShipsPositionsView()
		{
			TweenPlugin.activate([TintPlugin]);
			
			super();
			
			createViewComponents();			
		}
		
		
		public function setShipsData(v:Vector.<ShipData>):void
		{
			_ships = v;
			shipsLocationProcess.shipsLocationArray = v;
		}
		
		
		public function updateShipPositions():void
		{
			var i:int;
			_shipPlaceholder.graphics.clear();
			
			_shipPlaceholder.graphics.beginFill(0xff0000);
			
			for(i = 0; i < _ships.length; i++)
			{
				if(_ships[i].dirrection == ShipDirrection.HORIZONTAL) _shipPlaceholder.graphics.drawRect(_ships[i].x * cellSize, _ships[i].y*cellSize, _ships[i].deck * cellSize, cellSize);
				else _shipPlaceholder.graphics.drawRect(_ships[i].x * cellSize, _ships[i].y*cellSize, cellSize, _ships[i].deck * cellSize);
			}
		}
		
		
		public function close():void
		{
			if(_skin) _skin.removeEventListener(MouseEvent.CLICK, handlerMouseClick);
			if(this.parent) this.parent.removeChild( this );
			
			_skin = null;
		}
		
		
		private function createViewComponents():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewShipLocation");
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
				
				_shipPlaceholder = _skin.getChildByName("player_field") as MovieClip;
				
				_skin.addEventListener(MouseEvent.CLICK, handlerMouseClick);
				
				
				for (var i:String in _shipPlaceholder) 				
				{
					_shipPlaceholder.getChildByName(i).addEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);			
					(_shipPlaceholder.getChildByName(i) as MovieClip).buttonMode = true;
				}
			}
		}
		
		public function setShipPositionOnTable():void
		{
			_shipCache = new Dictionary();
			
			for (var i:int = 0; i < _ships.length; i++) 
			{
				var ship:MovieClip = _shipPlaceholder.getChildByName("s" + _ships[i].deck + "_" + i) as MovieClip;
				
				ship.x = _ships[i].x*cellSize;
				ship.y = _ships[i].y*cellSize;
								
				ship.gotoAndStop(_ships[i].dirrection + 1);
				
				_shipCache[ship] = _ships[i];
				
			}			
		}
		
		private function mouseMoveActivate(e:MouseEvent):void
		{
			var clip:MovieClip = e.currentTarget as MovieClip;
			var arr:Array = clip.name.split("_");			
			
			dragedShip  = e.currentTarget as MovieClip;
			initShipPoint.x = dragedShip.x;
			initShipPoint.y = dragedShip.y;		
			
			activeShip = _shipCache[dragedShip];
			
			dragedShip.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);	
			dragedShip.addEventListener(MouseEvent.MOUSE_UP,   mouseMoveDeactivate);	
			dragedShip.startDrag();		
		}
		
		private function mouseMove(e:MouseEvent):void
		{
			var xx:uint = Math.round( e.currentTarget.x/cellSize );			// лпределяем позиции корабля.
			var yy:uint = Math.round( e.currentTarget.y/cellSize );
			
			/*if(xx != activeShip.x || yy != activeShip.y)					// проверка что б событие не отправлялось по каждому движению, а только при смене значений координат.
			{*/
				activeShip.x = xx;
				activeShip.y = yy;
				
				this.dispatchEvent( _eventShipDrag );						// событие слушает ShipPositionMediator.as
				
				var lining:MovieClip, level:int, hitMc:MovieClip = e.currentTarget as MovieClip, old_x:int, old_y:int;		
				
				var x_coef:int = shipsLocationProcess.correctRange((hitMc.x + 12)/cellSize);
				var y_coef:int = shipsLocationProcess.correctRange((hitMc.y + 12)/cellSize);
				
				var a:Array 			= hitMc.name.split("s");
				var deckNArray:Array	= a[1].split("_");
				var shipsDeck:int  		= int(deckNArray[0]);			
				var shipDirection:int 	= hitMc.currentFrame - 1;	
								
				_shipPlaceholder.setChildIndex(hitMc, _shipPlaceholder.numChildren - 1);		
				
				if(!tableIsAdd)
				{
					tableIsAdd = true;
					if(_shipPlaceholder.getChildIndex(hitMc) - 1 >= 0) level = _shipPlaceholder.getChildIndex(hitMc) - 1;
					addTable(lining, shipsDeck, shipDirection+1, level);
				}				
				
				lining = (_shipPlaceholder.getChildByName("table_element") as MovieClip);
				
				if(!isCleared)
				{					
					old_x = shipsLocationProcess.shipsLocationArray[int(deckNArray[1])].x;
					old_y = shipsLocationProcess.shipsLocationArray[int(deckNArray[1])].y;
					
					isCleared = true;
					
					shipsLocationProcess.shipsOldPosition = [old_x, old_y];					
					
					shipsLocationProcess.resetShipLocation(0, 0, int(deckNArray[1]));						
				}
				
				shipsLocationProcess.dataForRotate.column = x_coef;
				shipsLocationProcess.dataForRotate.line	  = y_coef;
				shipsLocationProcess.dataForRotate.orient = shipDirection;
				shipsLocationProcess.dataForRotate.deck	  = shipsDeck;	
				
				if(!isColision)
				{			
					canLocate = true;				
					setTint(lining, GREEN, 0, 1);
					
				}else{
					
					canLocate = false;				
					setTint(lining, RED, 0, 1);
				}
				
				if(shipDirection == 0)
				{
					lining.x = shipsLocationProcess.correctRangeForMoving(x_coef, shipsDeck)*cellSize;
					lining.y = y_coef*cellSize;						
					
				}else if(shipDirection == 1)
				{				
					lining.x = x_coef*cellSize;
					lining.y = shipsLocationProcess.correctRangeForMoving(y_coef, shipsDeck)*cellSize;
				}
//			}
		}
		
		private function setTint(_element:MovieClip, _color:uint, _time:int = 0, _alpha:Number = 1):void
		{
			TweenLite.to(_element, _time, {tint:_color,  alpha:_alpha});	
		}
		
		/**
		 * Adding and showing lining under ship.
		 * @param lining  - lining under ship.
		 * @param deck	  - ship deck number.
		 * @param orient  - ship orientation.
		 * @param level   - child index.
		 */		
		private function addTable(lining:MovieClip, deck:int, orient:int, level:int):void
		{
			var classInstance:Class = BaseMediator.getSourceClass("movingTable");
			
			if(classInstance)
			{
				lining = new classInstance();				
				lining.name = "table_element";
				_shipPlaceholder.addChildAt(lining, level);
				lining.gotoAndStop(deck);
				lining.table.gotoAndStop(orient);
				
			}	
		}
		
		private function mouseMoveDeactivate(e:MouseEvent):void
		{
			dragedShip.stopDrag();
			removeMoveListeners();		
			
//			return;
			
			isCleared = tableIsAdd = false;
			dragedShip = rotatedShip = e.currentTarget as MovieClip;					
			
			var a:Array 		 = dragedShip.name.split("s");
			var deckNArray:Array = a[1].split("_");
			var shipsDeck:int  	 = int(deckNArray[0]);	
			var shipOrient:int 	 = (dragedShip.currentFrame - 1);	
			var lining:MovieClip = (_shipPlaceholder.getChildByName("table_element") as MovieClip);			
			
			if(canLocate)
			{
				dragedShip.x = lining.x;
				dragedShip.y = lining.y; 
				
			}else{
				
				dragedShip.x = lining.x = initShipPoint.x;
				dragedShip.y = lining.y = initShipPoint.y; 	
			}	
			
			removeTable();			
			
			var x_coef:int = shipsLocationProcess.correctRange((dragedShip.x + 20)/cellSize);
			var y_coef:int = shipsLocationProcess.correctRange((dragedShip.y + 5)/cellSize);
			
			if(!isColision)
			{
				for (var i:int = 0; i < _ships.length; i++) 
				{
					if(_ships[i].x == activeShip.x &&  _ships[i].y == activeShip.y)
					{
						_ships[i].x == activeShip.x;
						_ships[i].y == activeShip.y;
						break;
					}
						
				}
				
//				shipsLocationProcess.putShipInBattleField(x_coef, y_coef, shipOrient, shipsDeck, true);	
//				shipsLocationProcess.traceShipsArray("drag stop");
			}			
		}
		
		private function removeMoveListeners():void
		{				
			for (var j:int = 0; j < _shipPlaceholder.numChildren; j++) 
			{
				_shipPlaceholder.getChildAt(j).removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}			
		}
		
		/**
		 *  Adding and showing lining under ship.
		 */		
		private function removeTable():void
		{	
			if(_shipPlaceholder.contains(_shipPlaceholder.getChildByName("table_element") as MovieClip))
				_shipPlaceholder.removeChild(_shipPlaceholder.getChildByName("table_element") as MovieClip);		
		}		
		
		private function handlerMouseClick(e:MouseEvent):void
		{
			var name:String = e.target.name;
			
			switch(name)
			{
				case "btn_shuffle":
				{
					this.dispatchEvent( new Event(AUTO_ARRANGEMENT) );
					break;
				}
					
				case "btn_menu":
				{
					this.dispatchEvent( new Event(BACK) );
					break;
				}
				
				case "btn_next":
				{
					this.dispatchEvent( new Event(NEXT) );
					break;
				}
			}
		}
	}
}