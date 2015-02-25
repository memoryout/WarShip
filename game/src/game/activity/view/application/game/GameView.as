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
		private static var _this:		GameView;
		
		public static const USERT_TYPE:		String = "user";
		public static const OPPONENT_TYPE:	String = "oponent";
		
//		public static const FINISH_HIT_EVENT:		String = "finish_hit";
		
		public static const SHOW_PLAYER_STATE_EVENT:String = "finish_hit";
		
		public static const SELECT_OPPONENT_CEIL:	String = "selectOpponentCeil";
		
		public static const VIEW_GAME_LINK:		String = "viewGame";
		public static const OPONENT_FIELD:		String = "oponent_field";
		public static const PLAYER_FIELD:		String = "player_field";
		
		public static const COLUMN_RED:			String = "column";
		public static const LINE_RED:			String = "line";
		
		public static const SELECTED_CELL_VIEW:	String = "cellTable";
			
		public static const SHIPS_CONTAINER:	String = "ships_container";
		public static const LINES_CONTAINER:	String = "lines_container";
		
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
		
		private var cellSize:		Number = 1;
//		private var cellScale:		Number = 1;
		
		private var selectedUserCell:		Array = new Array();
		private var selectedOponentCell:	Array = new Array();
		
		private var brokenCellCounter:int = 1;
				
		private var popUp:MovieClip;
		
		private var topBar:TopBar;
		
		private var column:MovieClip;
		private var line:MovieClip;
		
		private var shipsContainer:MovieClip;
		private var linesContainer:MovieClip;
		private var selectedCellsViewContainer:MovieClip;
		private var cellAnimation:CellAnimation;
		
		private var gameViewMediator:GameViewMediator;
		
		public function GameView(val:GameViewMediator)
		{
			gameViewMediator = val;
			
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
			
			classInstance = BaseMediator.getSourceClass(SELECTED_CELL_VIEW);
			
			if(classInstance)
			{
				var cellTable:MovieClip = new classInstance();				
				classInstance = null;	
			}	
			
//			cellScale = cellSize/cellTable.width;
			
			classInstance = BaseMediator.getSourceClass("viewPopUp");
			
			popUp = new classInstance();
			this.addChild( popUp );	
			
			linesContainer = _skin.getChildByName(LINES_CONTAINER) as MovieClip;
			
			column	= linesContainer.getChildByName(COLUMN_RED) as MovieClip;
			line	= linesContainer.getChildByName(LINE_RED)   as MovieClip;
			
			selectedCellsViewContainer = new MovieClip();
			_skin.addChild(selectedCellsViewContainer);			
			selectedCellsViewContainer.mouseEnabled = false;
			
			cellAnimation = new CellAnimation();
			_skin.addChild(cellAnimation);	
			
			shipsContainer = _skin.getChildByName(SHIPS_CONTAINER) as MovieClip;
			
			shipsContainer.mouseEnabled = false;			
						
			_skin.setChildIndex(shipsContainer, _skin.numChildren - 1);
			_skin.setChildIndex(cellAnimation, _skin.numChildren - 1);
						
			_skin.setChildIndex(linesContainer, _skin.numChildren - 1);
			
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
				
				gameViewMediator.getUserShipsDescription().push(shipViewDescription);
			}			
		}
		
		/**
		 * Игрок сделал выстрел, значит рисуем на поле оппонента.
		 * */
		public function userMakeHit(fieldPoint:Object, selectType:uint):void
		{
			var animationParameters:Object = new Object();
			
			animationParameters.xPosition = cellSize*fieldPoint.x + _opponentField.x;
			animationParameters.yPosition = cellSize*fieldPoint.y + _opponentField.y;
			
			animationParameters.gotoTableFrame = 1;
			
			if(selectType != SELECTED_EMPTY)
			{
				brokenCellCounter++;
				animationParameters.gotoTableFrame = brokenCellCounter;
			}
					
			cellAnimation.setShipShootAnimation(gameViewMediator.getUserShipsDescription());		
			
			selectedUserCell.push([fieldPoint.x, fieldPoint.y]);			
									
			cellAnimation.setAnimation(animationParameters, selectType, fieldPoint, addTable, USERT_TYPE);
			
			lockGame();
		}	
			
		/**
		 * Противник сделал выстрел, значит отмечаем его на своём поле.
		 * Для вычислений используеться _opponentField хотя рисуеться на _userField - это временно
		 * */
		public function opponentMakeHit(fieldPoint:Object, selectType:int):void
		{		
			var animationParameters:Object = new Object();
			
			animationParameters.xPosition = cellSize*fieldPoint.x + _userField.x;
			animationParameters.yPosition = cellSize*fieldPoint.y + _userField.y;		
			animationParameters.gotoTableFrame = 1;
									
			if(selectType == SELECTED_EMPTY)
				animationParameters.gotoTableFrame = 1;		
									
			selectedOponentCell.push([fieldPoint.x, fieldPoint.y]);			
						
			cellAnimation.setAnimation(animationParameters, selectType, fieldPoint,addTable, OPPONENT_TYPE);
			
		}
				
		public function sunkUserShip(val:Object):void
		{
			var xPosition:Number = cellSize*val.ship.x + _opponentField.x,
				yPosition:Number = cellSize*val.ship.y + _opponentField.y;
			
			addWaterAroundSunkShip(val.fieldPoint, selectedUserCell, _opponentField);			
			cellAnimation.setSunkAnimation(xPosition, yPosition, val.ship, addBrokenShipOnField, USERT_TYPE);
			
			///for showing shooted
			xPosition = cellSize*val.cell.x + _opponentField.x,
			yPosition = cellSize*val.cell.y + _opponentField.y,
			
			cellAnimation.setShootedAnimation(xPosition, yPosition, val.cell.x, val.cell.y, OPPONENT_TYPE);
			cellAnimation.setShipShootAnimation(gameViewMediator.getUserShipsDescription());	
			
			///
			
			cleanBrokenCellsOnFeild(val.ship.coopdinates);	
//			cellAnimation.removeShotedAnimation(USERT_TYPE, val.ship.coopdinates);
			
			
			var shipViewDescription:ShipViewDescription = new ShipViewDescription();
			
			//			shipViewDescription.shipName = ship.name;
			shipViewDescription.x = val.cell.x;
			shipViewDescription.y = val.cell.y;
			shipViewDescription.sunk = true;
			shipViewDescription.deck = val.ship.deck;
			//			shipViewDescription.link = ship;
			shipViewDescription.dirrection = val.ship.dirrection;
			
			gameViewMediator.getOponentShipsDescription().push(shipViewDescription);
		}
		
		public function sunkOponentShip(val:Object):void
		{
			var xPosition:Number = cellSize*val.ship.x + _userField.x,
				yPosition:Number = cellSize*val.ship.y + _userField.y;
			
			addWaterAroundSunkShip(val.fieldPoint, selectedOponentCell, _userField);
		
			cellAnimation.setSunkAnimation(xPosition, yPosition, val.ship, addBrokenShipOnField, OPPONENT_TYPE);
			
			///for showing shooted
			xPosition = cellSize*val.cell.x + _userField.x,
			yPosition = cellSize*val.cell.y + _userField.y,
			
			cellAnimation.setShootedAnimation(xPosition, yPosition, val.cell.x, val.cell.y, USERT_TYPE);
			////
			
			removeOponentShipFromView(val);		
//			cellAnimation.removeShotedAnimation(OPPONENT_TYPE);
			
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
			
			cellTable.mouseEnabled = false;
			
//			cellTable.scaleX = cellTable.scaleY = cellScale;
			
			cellTable.gotoAndStop(gotoTableFrame);
		}
		
		private function addWaterAroundSunkShip(val:Vector.<ShipPositionPoint>, selectedCellsContainer:Array, field:MovieClip):void
		{
			for (var i:int = 0; i < val.length; i++) 
			{
				var selectedCell:Boolean = checkIfCellWasSelected(val[i], selectedCellsContainer);				
				
				if(!selectedCell)
				{						
					var xPosition:Number = cellSize*val[i].x + field.x,
						yPosition:Number = cellSize*val[i].y + field.y;
	
					addTable(val[i], xPosition, yPosition, SELECTED_EMPTY);
					
					selectedCellsContainer.push([val[i].x, val[i].y]);
					trace(val[i]);
				}				
			}
		}
		
		private function removeOponentShipFromView(val:Object):void
		{
			for (var i:int = 0; i < gameViewMediator.getUserShipsDescription().length; i++) 
			{				
				if(gameViewMediator.getUserShipsDescription()[i].x == val.ship.x && gameViewMediator.getUserShipsDescription()[i].y == val.ship.y)
				{
					shipsContainer.removeChild(shipsContainer.getChildByName(gameViewMediator.getUserShipsDescription()[i].shipName) as MovieClip);
					gameViewMediator.getUserShipsDescription()[i].sunk = true;
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
			
			drownedShip.mouseEnabled = false;
			
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
			
//			selectedUserCell.push([_ceilX, _ceilY]);
			
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
			topBar.setOpponent();
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
		
		public function destroy():void
		{
			cellAnimation.destroy();
			topBar.destroy();
			
			cellAnimation = null;
			topBar = null;
			
			while(numChildren > 0)
				removeChildAt(0);
		}
				
		public static function getInstance():GameView
		{
			return _this;
		}
	}
}