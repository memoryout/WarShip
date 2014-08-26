package game.activity.view.application.menu.pages.ships_positions
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import game.activity.BaseMediator;
	import game.application.data.game.ShipData;
	import game.application.data.game.ShipDirrection;
	
	public class ShipsPositionsView extends Sprite
	{
		private var cellSize:				Number = 31.5;
		
		private const RED:					uint = 0xFF0000;
		private const WHITE:				uint = 0xFFFFFF;
		private const BLACK:				uint = 0x000000;
		private const GREEN:				uint = 0x66FF66;
		
		private static const SHIP_LINING_NAME:		String = "table_element";
		private static const SHIP_LINING_CONTAINER:	String = "movingTable";
		
		public static const AUTO_ARRANGEMENT:		String = "autoArrangement";
		public static const ROTATE:					String = "rotate";
		public static const BACK:					String = "back";
		public static const NEXT:					String = "next";
		
		public static const SHIP_DRAG:				String = "ship_drag";			// отправляеться когда тягаем корабль по полю ( mouseMove(...) )
		private const _eventShipDrag:		Event = new Event(SHIP_DRAG);
		private var _shipCache:				Dictionary;								// кеш ссылок на корабли. Ключ - мувик корабля которые таскаем по полю, значение - связанный с этим кораблём ShipData.
		public var activeShip:				ShipData;								// задаёться когда начинаем таскать корабль.
		public var isColision:				Boolean;		
		
		private var _skinGameView:			MovieClip;
		private var _skin:					MovieClip;
		
		
		private var _ships:					Vector.<ShipData>;
		private var _shipPlaceholder:		MovieClip;
		private var tableHolder:			MovieClip;
		
		private var dragedShip:				MovieClip;
		private var rotatedShip:			MovieClip;
		private var shipsHolder:			MovieClip;
		
		private var initShipPoint:			Point = new Point();		
		private var initShipsPositions:		Array;
		
		private var shipsLocationProcess:	ShipsLocationProcess = new ShipsLocationProcess();	
		
		private var isCleared:				Boolean;	
		private var canLocate:				Boolean;	
		private var tableIsAdd:				Boolean;	
		
		private var hideTimer:				Timer = new Timer(300, 1);
		
		public  var rotateShipDescription:	Object = {"column":0, "line":0, "orient":0, "deck":0};
		private var shipsArray:Array = [4,3,3,2,2,2,1,1,1,1];
				
		public function ShipsPositionsView()
		{
			TweenPlugin.activate([TintPlugin]);
			
			super();
			
			createViewComponents();	
			shipsUpdate();
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
			var classInstance:Class = BaseMediator.getSourceClass("viewShipLocation"), i:int;	
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
				_skin.addEventListener(MouseEvent.CLICK, handlerMouseClick);
			}
			
			classInstance = BaseMediator.getSourceClass("viewGame");
			
			if(classInstance)
			{
				_skinGameView = new classInstance();
				
				for (i = _skinGameView.numChildren-1; i > -1; i--) 
				{
					_skin.addChildAt( _skinGameView.getChildAt(i), 0);
				}
				
				shipsHolder = _skin.getChildByName("location_table") as MovieClip;
				
				_skin.setChildIndex(shipsHolder, _skin.numChildren - 1);
				
				_skin.setChildIndex(_skin.getChildByName("btn_rotate"), _skin.numChildren - 1);
				_skin.setChildIndex(_skin.getChildByName("btn_shuffle"), _skin.numChildren - 1);
				_skin.setChildIndex(_skin.getChildByName("btn_next"), _skin.numChildren - 1);				
				
				cellSize = _skin.getChildByName("player_field").width/10;
				tableHolder = _skin.getChildByName("player_field") as MovieClip;
				
				var topBar:MovieClip = _skin.getChildByName("topBar") as MovieClip;
				
				(topBar.getChildByName("logo_right_side") as MovieClip).visible = false;
				
				(topBar.getChildByName("oponent_progress_line") as MovieClip).visible = false;
				(topBar.getChildByName("user_progress_line") as MovieClip).visible = false;
				(topBar.getChildByName("number_table") as MovieClip).visible = false;				
			}
		}
		
		private function shipsUpdate():void
		{
			_shipCache 			= new Dictionary();
			initShipsPositions  = new Array();
				
			for (var i:int = 0; i < shipsArray.length; i++) 					
			{			
				var ship:MovieClip = _skin.getChildByName("s" + shipsArray[i] + "_" + i) as MovieClip;
				
				_skin.setChildIndex(ship, _skin.numChildren-1);		
				
				ship.addEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);			
				ship.buttonMode = true;
				
				initShipsPositions.push({"x":ship.x, "y":ship.y});
			}
		}
		
		public function setShipPositionOnTable():void
		{
			_shipCache = new Dictionary();
			
			for (var i:int = 0; i < _ships.length; i++) 
			{
				var ship:MovieClip = _skin.getChildByName("s" + _ships[i].deck + "_" + i) as MovieClip;
				
				ship.x = _ships[i].x*cellSize + tableHolder.x;
				ship.y = _ships[i].y*cellSize + tableHolder.y;
				
				ship.gotoAndStop(_ships[i].dirrection + 1);
				
				_shipCache[ship] = _ships[i];				
			}			
		}
		
		private function mouseMoveActivate(e:MouseEvent):void
		{			
			dragedShip  	= e.currentTarget as MovieClip;
		
			initShipPoint.x = dragedShip.x;
			initShipPoint.y = dragedShip.y;		
			
			activeShip 		= _shipCache[dragedShip];
			
			if(!activeShip)
				activeShip = new ShipData();
			
			dragedShip.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);	
			dragedShip.addEventListener(MouseEvent.MOUSE_UP,   mouseMoveDeactivate);	
			dragedShip.startDrag();		
		}
		
		private function mouseMove(e:MouseEvent):void
		{
			var xx:uint = Math.round( (e.currentTarget.x - tableHolder.x)/cellSize );			// лпределяем позиции корабля.
			var yy:uint = Math.round( (e.currentTarget.y - tableHolder.y)/cellSize );
			
			activeShip.x = xx;
			activeShip.y = yy;
			
			this.dispatchEvent( _eventShipDrag );						// событие слушает ShipPositionMediator.as
			
			var shipLining:MovieClip, layerIndex:int, 			
			hitMc:MovieClip = e.currentTarget as MovieClip;		
			
			var x_coef:int = shipsLocationProcess.correctRange((hitMc.x - tableHolder.x + cellSize/2)/cellSize);
			var y_coef:int = shipsLocationProcess.correctRange((hitMc.y - tableHolder.y + cellSize/2)/cellSize);
			
			defineShip(e.currentTarget as MovieClip);
			
			var deckNArray:Array = hitMc.name.split("s")[1].split("_");
		
			_skin.setChildIndex(hitMc, _skin.numChildren - 1);		
			
			if(!tableIsAdd && checkIfIsOnShipsTable(e.currentTarget.x, e.currentTarget.y) )
			{
				tableIsAdd = true;
				if(_skin.getChildIndex(hitMc) - 1 >= 0) 
					layerIndex = _skin.getChildIndex(hitMc) - 1;
				
				addTable(shipLining, activeShip.deck, activeShip.dirrection+1, layerIndex);
			}				
			
			shipLining = tableHolder.getChildByName(SHIP_LINING_NAME) as MovieClip;
			
			if(!isCleared)
			{				
				isCleared = true;
				
				shipsLocationProcess.resetShipLocation(0, 0, int(deckNArray[1]));						
			}
			
			rotateShipDescription.column  = x_coef;
			rotateShipDescription.line	  = y_coef;
			rotateShipDescription.orient  = activeShip.dirrection;
			rotateShipDescription.deck	  = activeShip.deck;	
			
			if(tableIsAdd)
			{
				if(!checkIfIsOnShipsTable(e.currentTarget.x, e.currentTarget.y))
				{
					tableIsAdd = false;
					removeTable();
					
				}else if(shipLining)
				{
					if(!isColision)
					{			
						canLocate = true;					
						setTint(shipLining, GREEN, 0, 1);
						
					}else{
						
						canLocate = false;						
						setTint(shipLining, RED, 0, 1);
					}
					
					if(activeShip.dirrection == 0)
					{
						shipLining.x = shipsLocationProcess.correctRangeForMoving(x_coef, activeShip.deck)*cellSize;
						shipLining.y = y_coef*cellSize;						
						
					}else if(activeShip.dirrection == 1)
					{				
						shipLining.x = x_coef*cellSize;
						shipLining.y = shipsLocationProcess.correctRangeForMoving(y_coef, activeShip.deck)*cellSize;
					}
				}					
			}		
		}
		
		private function setTint(_element:MovieClip, _color:uint, _time:int = 0, _alpha:Number = 1):void
		{
			if(_element)
				TweenLite.to(_element, _time, {tint:_color,  alpha:_alpha});	
		}
		
		/**
		 * Adding and showing lining under ship.
		 * @param lining  - lining under ship.
		 * @param deck	  - ship deck number.
		 * @param orient  - ship orientation.
		 * @param level   - child index.
		 */		
		private function addTable(shipLining:MovieClip, deck:int, orient:int, level:int):void
		{
			var classInstance:Class = BaseMediator.getSourceClass(SHIP_LINING_CONTAINER);
			
			if(classInstance)
			{
				shipLining = new classInstance();				
				shipLining.name = SHIP_LINING_NAME;
				tableHolder.addChildAt(shipLining, tableHolder.numChildren);
				shipLining.gotoAndStop(deck);
				shipLining.table.gotoAndStop(orient);				
			}	
		}
		
		private function mouseMoveDeactivate(e:MouseEvent):void
		{
			dragedShip.stopDrag();
			removeMoveListeners();	
			
			isCleared = tableIsAdd = false;
			dragedShip = rotatedShip = e.currentTarget as MovieClip;					
			
			var shipLining:MovieClip = tableHolder.getChildByName(SHIP_LINING_NAME) as MovieClip;			
			
			if(canLocate && checkIfIsOnShipsTable(e.currentTarget.x, e.currentTarget.y))
			{
				dragedShip.x = shipLining.x + tableHolder.x;
				dragedShip.y = shipLining.y + tableHolder.y; 
				
			}else if(checkIfIsOnShipsHolder(e.currentTarget.x, e.currentTarget.y))
			{			
				dragedShip.x = initShipsPositions[activeShip.idx].x;
				dragedShip.y = initShipsPositions[activeShip.idx].y;
				dragedShip.gotoAndStop(0);				
				
			}else{
				
				dragedShip.x = initShipPoint.x;
				dragedShip.y = initShipPoint.y; 	
				
				if(shipLining)
				{
					shipLining.x = initShipPoint.x;
					shipLining.y = initShipPoint.y; 	
				}
			}	
			
			removeTable();	
			
			if(!isColision)
			{
				for (var i:int = 0; i < _ships.length; i++) 
				{
					if(_ships[i].id == activeShip.idx)
					{
						_ships[i].x = activeShip.x;
						_ships[i].y = activeShip.y;
						break;
					}					
				}
			}			
		}
		
		/**
		 * Reset rotating ships position.
		 * Update all ships position without ship wich will rotate.
		 * If can rotate, change position. Else show "red table" on unposible position, set timer for hide this red table. 
		 */		
		public function rotateShip():void
		{
			if(rotatedShip)
			{	
				var shipLining:MovieClip, layerIndex:int, directionForRotate:int;					
				
				if(!activeShip)
					activeShip = new ShipData();
				
				defineShip(dragedShip);
				
				activeShip = _ships[activeShip.idx];
				
				if(activeShip.dirrection == ShipDirrection.VERTICAL)
				{
					activeShip.dirrection = ShipDirrection.HORIZONTAL;
					directionForRotate = 0;
				}					
				else 
				{
					activeShip.dirrection = ShipDirrection.VERTICAL;
					directionForRotate = 1;
				}
				
				this.dispatchEvent( _eventShipDrag );	
				
				if( !isColision ) 
				{					
					if(directionForRotate == 0)	
						rotateShipDescription.orient = directionForRotate; 
					else 
						rotateShipDescription.orient = directionForRotate;
					
					rotatedShip.gotoAndStop(directionForRotate + 1);					
					
				}else
				{					
//					if(_shipPlaceholder.getChildIndex(rotatedShip) - 1 >= 0) 
//						layerIndex = _shipPlaceholder.getChildIndex(rotatedShip) - 1;
					
					addTable(shipLining, rotateShipDescription.deck, directionForRotate+1, layerIndex);
					
					shipLining   = tableHolder.getChildByName(SHIP_LINING_NAME) as MovieClip;
					shipLining.x = rotateShipDescription.column*cellSize;
					shipLining.y = rotateShipDescription.line*cellSize;					
					
					setTint(shipLining, RED, 0, 1);
					
					hideTimer.addEventListener(TimerEvent.TIMER, hideTable);
					hideTimer.start();
				}
			}
		}
		
		private function hideTable(e:TimerEvent):void
		{
			hideTimer.stop();
			hideTimer.removeEventListener(TimerEvent.TIMER, hideTable);			
			removeTable();
		}
		
		private function removeMoveListeners():void
		{				
			for (var j:int = 0; j < _skin.numChildren; j++) 
			{
				_skin.getChildAt(j).removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}			
		}
		
		private function defineShip(activeElement:MovieClip):void
		{					
			activeShip.deck 		= int(activeElement.name.split("s")[1].split("_")[0]);		
			activeShip.idx			= int(activeElement.name.split("s")[1].split("_")[1]);
			activeShip.dirrection 	= activeElement.currentFrame - 1;					
		}
		
		/**
		 *  Adding and showing lining under ship.
		 */		
		private function removeTable():void
		{	
			if(tableHolder.getChildByName(SHIP_LINING_NAME) && tableHolder.contains(tableHolder.getChildByName(SHIP_LINING_NAME) as MovieClip))
				tableHolder.removeChild(tableHolder.getChildByName(SHIP_LINING_NAME) as MovieClip);		
		}	
		
		private function checkIfIsOnShipsTable(x:uint, y:uint):Boolean
		{			
			if(x >= tableHolder.x && x <= tableHolder.x + tableHolder.width && y >= tableHolder.y && y <= tableHolder.y + tableHolder.height)
				return true;							
			
			return false;			
		}
		
		private function checkIfIsOnShipsHolder(x:uint, y:uint):Boolean
		{			
			if(x >= shipsHolder.x && x <= shipsHolder.x + shipsHolder.width && y >= shipsHolder.y && y <= shipsHolder.y + shipsHolder.height)
				return true;							
			
			return false;			
		}
		
		private function handlerMouseClick(e:MouseEvent):void
		{
			var name:String = e.target.name;
			
			switch(name)
			{
				case "btn_shuffle":
				{
					this.dispatchEvent( new Event(AUTO_ARRANGEMENT) );
					rotatedShip = null;
					break;
				}
					
				case "btn_rotate":
				{
					this.dispatchEvent( new Event(ROTATE) );
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