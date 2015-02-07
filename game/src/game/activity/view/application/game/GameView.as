package game.activity.view.application.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.activity.BaseMediator;
	import game.application.data.game.ShipData;
	import game.application.data.game.ShipPositionPoint;
	
	public class GameView extends Sprite
	{
		public static const FINISH_HIT_EVENT:		String = "finish_hit";
		
		public static const SELECT_OPPONENT_CEIL:	String = "selectOpponentCeil";
		
		public static const VIEW_GAME_LINK:		String = "viewGame";
		public static const OPONENT_FIELD:		String = "oponent_field";
		public static const PLAYER_FIELD:		String = "player_field";
		
		public static const COLUMN_RED:			String = "column";
		public static const LINE_RED:			String = "line";
		
		public static const SELECTED_CELL_VIEW:	String = "cellTable";
			
		public static const SHIPS_CONTAINER:	String = "ships_container";
		
		public static const HIT_FIRE_ANI:		String = "hitFire";
		public static const HIT_WATER_ANI:		String = "hitWater";
		
		public static const BROKEN_SHIP_INDEX_NAME:		String = "broken_";
		public static const DROWNED_SHIPS:		String = "drownedShips";
					
		public static const SELECTED_EMPTY:		int = 0;
		public static const HIT_SHIP:			int = 1;
		public static const SUNK_SHIP:			int = 2;
		
		private var _skin:			MovieClip;
		
		private var _opponentField:	MovieClip;
		private var _userField:		MovieClip;
		
		private var _ceilX:			uint;
		private var _ceilY:			uint;
		
		private var _txt:			TextField;
		private var selectedCell:	MovieClip;		
		
		private var cellSize:		Number;
		private var cellScale:		Number;
		
		private var selectedUserCell:		Array = new Array();
		private var selectedOponentCell:	Array = new Array();
		
		private var brokenCellCounter:int = 1;
		
		private var shipsDescriptionContainer:Vector.<ShipViewDescription>;
		
		private var popUp:MovieClip;
		
		private var topBar:TopBar;
		
		private var column:MovieClip;
		private var line:MovieClip;
		
		private var shipsContainer:MovieClip;
		private var selectedCellsViewContainer:MovieClip;
		private var cellAnimation:CellAnimation;
		
		public function GameView()
		{
			setViewComponents();			
		}
		
		private function setViewComponents():void
		{
			var classInstance:Class = BaseMediator.getSourceClass(VIEW_GAME_LINK);
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
				
				_opponentField 	= _skin.getChildByName(OPONENT_FIELD) as MovieClip;
				_userField 		= _skin.getChildByName(PLAYER_FIELD) as MovieClip;
				
				cellSize = (_userField.getChildByName("field") as MovieClip).width/10; // calculate cell size
				
				_opponentField.addEventListener(MouseEvent.MOUSE_UP, handlerSelectCell);					
			}
			
			classInstance = BaseMediator.getSourceClass("viewPopUp");
			
			popUp = new classInstance();
			this.addChild( popUp );	
			
			column	= _opponentField.getChildByName(COLUMN_RED) as MovieClip;
			line	= _opponentField.getChildByName(LINE_RED)   as MovieClip;
			
			selectedCellsViewContainer = new MovieClip();
			_skin.addChild(selectedCellsViewContainer);			
			selectedCellsViewContainer.mouseEnabled = false;
			
			cellAnimation = new CellAnimation();
			_skin.addChild(cellAnimation);	
			
			cellAnimation.mouseEnabled = false;
			
			shipsContainer = _skin.getChildByName(SHIPS_CONTAINER) as MovieClip;
			
			shipsContainer.mouseEnabled = false;
						
			_skin.setChildIndex(shipsContainer, _skin.numChildren - 1);
			_skin.setChildIndex(cellAnimation, _skin.numChildren - 1);
			
			topBar = new TopBar();
			addChild(topBar);
		}
				
		public function lockGame():void
		{
			_opponentField.removeEventListener(MouseEvent.MOUSE_UP, 	handlerSelectCell);			
			_opponentField.removeEventListener(MouseEvent.MOUSE_DOWN,  	handlerSelectCellDown);
			_opponentField.removeEventListener(MouseEvent.MOUSE_MOVE,  	handlerSelectCellMove);
		}
		
		public function unlockGame():void
		{
			_opponentField.addEventListener(MouseEvent.MOUSE_UP, 		handlerSelectCell);
			_opponentField.addEventListener(MouseEvent.MOUSE_DOWN,  	handlerSelectCellDown);			
		}	
		
		/**
		 * Locate ships on user field.
		 * @param val - ship list
		 * 
		 */		
		public function setShipsLocation(val:Vector.<ShipData>):void
		{		
			shipsDescriptionContainer = new Vector.<ShipViewDescription>();
			
			for (var i:int = 0; i < val.length; i++) 
			{				
				var ship:MovieClip = shipsContainer.getChildByName("s" + val[i].deck + "_" + i) as MovieClip;	
				
				ship.x = val[i].x*cellSize + _userField.x;
				ship.y = val[i].y*cellSize + _userField.y;
				
				if(val[i].dirrection == 0) 
					ship.gotoAndStop(1);		
				else					   
					ship.gotoAndStop(2);
				
				var shipViewDescription:ShipViewDescription = new ShipViewDescription();
				
				shipViewDescription.shipName = ship.name;
				shipViewDescription.x = val[i].x;
				shipViewDescription.y = val[i].y;
				shipViewDescription.sunk = false;
				shipViewDescription.deck = val[i].deck;
				shipViewDescription.link = ship;
				shipViewDescription.dirrection = val[i].dirrection;
				
				shipsDescriptionContainer.push(shipViewDescription);
			}			
		}
		
		/**
		 * Игрок сделал выстрел, значит рисуем на поле оппонента.
		 * */
		public function userMakeHit(fieldPoint:Object, selectType:uint):void
		{
			var xPosition:Number = cellSize*fieldPoint.x + _opponentField.x,
				yPosition:Number = cellSize*fieldPoint.y + _opponentField.y,
				gotoTableFrame:Number = 1;		
			
			if(selectType != SELECTED_EMPTY)
			{
				brokenCellCounter++;
				gotoTableFrame = brokenCellCounter;
			}
			
			cellAnimation.setShipShootAnimation(shipsDescriptionContainer);			
									
			cellAnimation.setAnimation(xPosition, yPosition, selectType, cellScale, fieldPoint, gotoTableFrame,  addTable, 0);
			
			lockGame();
		}	
			
		/**
		 * Противник сделал выстрел, значит отмечаем его на своём поле.
		 * Для вычислений используеться _opponentField хотя рисуеться на _userField - это временно
		 * */
		public function opponentMakeHit(fieldPoint:Object, selectType:int):void
		{		
			var xPosition:Number = cellSize*fieldPoint.x + _userField.x,
				yPosition:Number = cellSize*fieldPoint.y + _userField.y,		
				gotoTableFrame:Number = 1,
				shootedAni:int;
									
			if(selectType == SELECTED_EMPTY)
				gotoTableFrame = 1;		
									
			selectedOponentCell.push([xPosition, yPosition]);			
			
			if(selectType == HIT_SHIP)
				shootedAni = 1;
			
			cellAnimation.setAnimation(xPosition, yPosition, selectType, cellScale, fieldPoint, gotoTableFrame,  addTable, shootedAni);
			
		}
				
		public function sunkUserShip(val:Object):void
		{
			var xPosition:Number = cellSize*val.ship.x + _opponentField.x,
				yPosition:Number = cellSize*val.ship.y + _opponentField.y;
			
			addWaterAroundSunkShip(userMakeHit, val.fieldPoint, selectedOponentCell);			
			cellAnimation.setSunkAnimation(xPosition, yPosition, val.ship, addBrokenShipOnField);
			
			cleanBrokenCellsOnFeild(val.ship.coopdinates);		
		}
		
		public function sunkOponentShip(val:Object):void
		{
			var xPosition:Number = cellSize*val.ship.x + _userField.x,
				yPosition:Number = cellSize*val.ship.y + _userField.y;
			
			addWaterAroundSunkShip(opponentMakeHit, val.fieldPoint, selectedOponentCell);
			cellAnimation.setSunkAnimation(xPosition, yPosition, val.ship, addBrokenShipOnField);
			
			removeOponentShipFromView(val);		
			cellAnimation.removeShotedAnimation();
		}
		
		private function addTable(fieldPoint:Object, xPosition:Number, yPosition:Number, gotoTableFrame:int):void
		{
			var classInstance:Class, cellTable:MovieClip;
			
			classInstance = BaseMediator.getSourceClass(SELECTED_CELL_VIEW);
			
			if(classInstance)
			{
				cellTable = new classInstance();				
				classInstance = null;	
				cellTable.name = BROKEN_SHIP_INDEX_NAME + fieldPoint.x.toString() + "_" + fieldPoint.y.toString();				
			}	
			
			selectedCellsViewContainer.addChild(cellTable);	
			
			cellTable.x = xPosition;
			cellTable.y = yPosition;
			
			cellScale = cellSize/cellTable.width;
			
			cellTable.scaleX = cellTable.scaleY = cellScale;
			
			cellTable.gotoAndStop(gotoTableFrame);
		}
		
		private function addWaterAroundSunkShip(callForMakeHit:Function, val:Vector.<ShipPositionPoint>, selectedCellsContainer:Array):void
		{
			for (var i:int = 0; i < val.length; i++) 
			{
				var selectedCell:Boolean = checkIfCellWasSelected(val[i], selectedOponentCell);				
				
				if(!selectedCell)
				{						
					callForMakeHit(val[i], SELECTED_EMPTY);			
					
					selectedCellsContainer.push([val[i].x, val[i].y]);
				}				
			}
		}
		
		private function removeOponentShipFromView(val:Object):void
		{
			for (var i:int = 0; i < shipsDescriptionContainer.length; i++) 
			{				
				if(shipsDescriptionContainer[i].x == val.ship.x && shipsDescriptionContainer[i].y == val.ship.y)
				{
					shipsContainer.removeChild(shipsContainer.getChildByName(shipsDescriptionContainer[i].shipName) as MovieClip);
					shipsDescriptionContainer[i].sunk = true;
					break;
				}								
			}
		}
		
		private function checkIfCellWasSelected(val:Object, container:Array):Boolean
		{			
			for (var i:int = 0; i < container.length; i++) 
			{
				if(container[i][0] == val.x && container[i][1] == val.y)				
					return true;				
			}
			
			return false;
		}
		
		private function cleanBrokenCellsOnFeild(coopdinates:Object):void
		{
			for (var j:int = 0; j < coopdinates.length; j++) 
			{
				for (var i:int = 0; i < selectedCellsViewContainer.numChildren; i++) 
				{				
					if(selectedCellsViewContainer.getChildAt(i))
					{
						var nameName:Array = selectedCellsViewContainer.getChildAt(i).name.split("_");	
						
						if(uint(nameName[1]) == coopdinates[j].x && uint(nameName[2]) == coopdinates[j].y)
							selectedCellsViewContainer.removeChildAt(i);
					}				
				}	
			}				
		}
		
		private function addBrokenShipOnField(xPosition:Number, yPosition:Number, deck:int, dirrection:int):void
		{			
			var classInstance:Class = BaseMediator.getSourceClass(DROWNED_SHIPS);
			var drownedShip:MovieClip;
			
			if(classInstance)
			{
				drownedShip = new classInstance();				
				classInstance = null;				
			}	
			
			shipsContainer.addChild(drownedShip);					
			
			drownedShip.x = xPosition;
			drownedShip.y = yPosition;
			
			drownedShip.gotoAndStop(deck);
			
			if(dirrection == 0)  
				drownedShip.table.gotoAndStop(1);		
			else  					 
				drownedShip.table.gotoAndStop(2);		
		}	
			
		private function handlerSelectCell(e:MouseEvent):void
		{
			_ceilX = uint(_opponentField.mouseX/cellSize);
			_ceilY = uint(_opponentField.mouseY/cellSize);
			
			this.dispatchEvent( new Event(SELECT_OPPONENT_CEIL));
			
			selectedUserCell.push([_ceilX, _ceilY]);
			
			if(column)
				column.alpha = 0;
			
			if(line)
				line.alpha = 0;
			
			_opponentField.removeEventListener(MouseEvent.MOUSE_MOVE,  handlerSelectCellMove);
		}
		
		private function handlerSelectCellDown(e:MouseEvent):void
		{
			_ceilX = uint(_opponentField.mouseX/cellSize);
			_ceilY = uint(_opponentField.mouseY/cellSize);
			
			if( column)
			{
				column.alpha = 1;			
				column.x	 = _ceilX*cellSize;		
			}
			
			if(line)
			{
				line.alpha  = 1;
				line.y  	= (_ceilY + 1)*cellSize;
			}
			
			_opponentField.addEventListener(MouseEvent.MOUSE_MOVE,  handlerSelectCellMove);
			_opponentField.addEventListener(MouseEvent.MOUSE_OUT,   handlerSelectCellOut);
		}
		
		private function handlerSelectCellMove(e:MouseEvent):void
		{
			_ceilX = uint(_opponentField.mouseX/cellSize);
			_ceilY = uint(_opponentField.mouseY/cellSize);
			
			if(_ceilX <= 9 && _ceilY <= 9)
			{
				if(column)
				{
					column.alpha = 1;		
					column.x	= _ceilX*cellSize;		
				}
				
				if(line)
				{									
					line.alpha   = 1;
					line.y  	= (_ceilY + 1)*cellSize;
				}			
			}		
		}	
		
		private function handlerSelectCellOut(e:MouseEvent):void
		{
			if(column)
				column.alpha = 0;
			
			if(line)
				line.alpha = 0;
			
			_opponentField.removeEventListener(MouseEvent.MOUSE_MOVE,  handlerSelectCellMove);
		}
						
		public function setUsersData(val:Object):void
		{
			trace(val);
		}
		
		public function updateProgressLine(type:String, val:Object):void
		{
			topBar.setProgress(type, val);			
		}
				
		public function get skin():MovieClip
		{
			return _skin;
		}
		
		public function get ceilX():uint
		{
			return _ceilX;
		}
		
		public function get ceilY():uint
		{
			return _ceilY;
		}
	}
}