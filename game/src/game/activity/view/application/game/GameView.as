package game.activity.view.application.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.activity.BaseMediator;
	import game.application.data.game.ShipData;
	
	public class GameView extends Sprite
	{
		public static const SELECT_OPPONENT_CEIL:		String = "selectOpponentCeil";
		
		private var _skin:			MovieClip;
		
		private var _opponentField:	MovieClip;
		private var _userField:		MovieClip;
		
		private var _ceilX:			uint;
		private var _ceilY:			uint;
		
		private var _txt:			TextField;
		private var selectedCell:	MovieClip;		
		
		private var cellSize:		Number;
		
		private var selectedUserCell:		Array = new Array();
		private var selectedOponentCell:	Array = new Array();
		
		private var brokenCellCounter:int = 1;
		
		private var shipsDescriptionContainer:Array;
		
		private var popUp:			MovieClip;
		
		public function GameView()
		{
			createViewComponents();
		}
		
		
		public function get ceilX():uint
		{
			return _ceilX;
		}
		
		public function get ceilY():uint
		{
			return _ceilY;
		}
		
		
		public function lockGame():void
		{
			_opponentField.removeEventListener(MouseEvent.MOUSE_UP, handlerSelectCell);
			
			_opponentField.removeEventListener(MouseEvent.MOUSE_DOWN,  handlerSelectCellDown);
			_opponentField.removeEventListener(MouseEvent.MOUSE_MOVE,  handlerSelectCellMove);
		}
		
		
		public function unlockGame():void
		{
			_opponentField.addEventListener(MouseEvent.MOUSE_UP, 	handlerSelectCell);
			_opponentField.addEventListener(MouseEvent.MOUSE_DOWN,  handlerSelectCellDown);			
		}
		
		
		
		public function waiting():void
		{
//			this.alpha = 0.5;
//			_txt.text = "WAITING";
		}
		
		
		public function opponentStep():void
		{
			this.alpha = 1;
//			_txt.text = "OPPONENT STEP";
			popUp.visible = true;
		}
		
		public function userStep():void
		{
			this.alpha = 1;
//			_txt.text = "USER STEP";
			popUp.visible = false;
		}
		
		public function waitingGame():void
		{
//			this.alpha = 0.5;
//			_txt.text = "WAITNIG GAME ANSWER";
		}
		
		public function sunkUserShip(val:Object):void
		{
			var i:int;
			
			for (i = 0; i < val.fieldPoint.length; i++) 
			{
				if(val.fieldPoint[i].x > -1 && val.fieldPoint[i].y > -1 && !checkIfCellWasSelected(val.fieldPoint[i], selectedUserCell))
				{
					userMakeHit(val.fieldPoint[i].x, val.fieldPoint[i].y, 0);
					selectedUserCell.push([val.fieldPoint[i].x, val.fieldPoint[i].y]);
				}
			}
			
			for (i = 0; i < val.ship.coopdinates.length; i++) 
			{
				cleanBrokenCellsOnFeild(val.ship.coopdinates[i].x, val.ship.coopdinates[i].y, _opponentField);
			}
			
			addBrokenShipOnField(val.ship.x, val.ship.y, val.ship.deck, val.ship.dirrection, _opponentField);			
		}
		
		public function sunkOponentShip(val:Object):void
		{			
			var i:int;
			
			for (i = 0; i < val.fieldPoint.length; i++) 
			{
				if(val.fieldPoint[i].x > -1 && val.fieldPoint[i].y > -1 && !checkIfCellWasSelected(val.fieldPoint[i], selectedOponentCell))
				{
					opponentMakeHit(val.fieldPoint[i].x, val.fieldPoint[i].y, 0);
					selectedOponentCell.push([val.fieldPoint[i].x, val.fieldPoint[i].y]);
				}
			}
			
			for (i = 0; i < val.ship.coopdinates.length; i++) 
			{
				cleanBrokenCellsOnFeild(val.ship.coopdinates[i].x, val.ship.coopdinates[i].y, _userField);
			}
			
			for (i = 0; i < shipsDescriptionContainer.length; i++) 
			{				
				if(shipsDescriptionContainer[i].x == val.ship.x && shipsDescriptionContainer[i].y == val.ship.y)
				{
					_skin.removeChild(_skin.getChildByName(shipsDescriptionContainer[i].shipName) as MovieClip);
					break;
				}								
			}	
			
			addBrokenShipOnField(val.ship.x, val.ship.y, val.ship.deck, val.ship.dirrection, _userField);	
		}
		
		private function checkIfCellWasSelected(val:Object, container:Array):Boolean
		{			
			for (var i:int = 0; i < container.length; i++) 
			{
				if(container[i][0] == val.x && container[i][1] == val.y)
				{
					return true;
					break;
				}
			}
			
			return false;
		}
		
		private function cleanBrokenCellsOnFeild(x:uint, y:uint, field:MovieClip):void
		{
			for (var i:int = 0; i < field.numChildren; i++) 
			{
				var currentElement:MovieClip = field.getChildAt(i) as MovieClip;
				if(currentElement)
				{
					var nameName:Array = currentElement.name.split("_");	
					
					if(uint(nameName[1]) == x && uint(nameName[2]) == y)
						field.removeChildAt(i);
				}				
			}			
		}
		
		private function addBrokenShipOnField(x:int, y:int, deck:int, dirrection:int, field:MovieClip):void
		{			
			var classInstance:Class = BaseMediator.getSourceClass("drownedShips");
			var drownedShip:MovieClip;
			
			if(classInstance)
			{
				drownedShip = new classInstance();				
				classInstance = null;				
			}	
			
			field.addChild(drownedShip);			
			
			drownedShip.x = cellSize*x;
			drownedShip.y = cellSize*y;
			
			drownedShip.gotoAndStop(deck);
			
			if(dirrection == 0)  drownedShip.table.gotoAndStop(1);		
			else  				 drownedShip.table.gotoAndStop(2);		
		}
		
		
		/**
		 * Игрок сделал выстрел, значит рисуем на поле оппонента.
		 * */
		public function userMakeHit(x:uint, y:uint, result:uint):void
		{
			var hitElement:MovieClip, classInstance:Class, className:String, cellTable:MovieClip;
			
			if(result == 0) 
				className = "hitWater";
			else if(result == 1 || result == 2) 				
				className = "hitFire";
			
			classInstance = BaseMediator.getSourceClass(className);
			
			if(classInstance)
			{
				hitElement = new classInstance();				
				classInstance = null;				
			}
			
			classInstance = BaseMediator.getSourceClass("cellTable");
			
			if(classInstance)
			{
				cellTable = new classInstance();				
				classInstance = null;	
				cellTable.name = "broken_" + x.toString() + "_" + y.toString();				
			}			
			
			_skin.addChildAt(hitElement, _skin.numChildren - 1);
			_skin.addChildAt(cellTable,  _skin.numChildren - 1);
			
			hitElement.x = cellTable.x = cellSize*x + _opponentField.x;
			hitElement.y = cellTable.y = cellSize*y + _opponentField.y;
			
			if(result > 0)
			{
				brokenCellCounter++;
				cellTable.gotoAndStop(brokenCellCounter);
			}
				
			else 
				cellTable.gotoAndStop(1);
			
			var scale:Number = cellSize/cellTable.width;
			
			cellTable.scaleX  = cellTable.scaleY  = scale;			
			hitElement.scaleX = hitElement.scaleY = scale;		
			
			hitElement.gotoAndPlay(2);				
			hitElement.addEventListener("finish_hit", removeHitAnimation);		
			
			lockGame();
		}
		
		
		/**
		 * Противник сделал выстрел, значит отмечаем его на своём поле.
		 * Для вычислений используеться _opponentField хотя рисуеться на _userField - это временно
		 * */
		public function opponentMakeHit(x:uint, y:uint, result:uint):void
		{
			var hitElement:MovieClip, classInstance:Class, className:String, cellTable:MovieClip;
			
			if(result == 0) 
				className = "hitWater";
			else if(result == 1 || result == 2) 				
				className = "hitFire";
			
			classInstance = BaseMediator.getSourceClass(className);
			
			if(classInstance)
			{
				hitElement = new classInstance();				
				classInstance = null;				
			}
			
			classInstance = BaseMediator.getSourceClass("cellTable");
			
			if(classInstance)
			{
				cellTable = new classInstance();				
				classInstance = null;		
				cellTable.name = "broken_" + x.toString() + "_" + y.toString();		
			}			
			
			_skin.addChildAt(hitElement, _skin.numChildren-1);
			_skin.addChildAt(cellTable,  _skin.numChildren-1);
			
			hitElement.x = cellTable.x = cellSize*x + _userField.x;
			hitElement.y = cellTable.y = cellSize*y + _userField.y;
			
			if(result > 0)
				cellTable.gotoAndStop(22);
			else 
				cellTable.gotoAndStop(1);
			
			var scale:Number = cellSize/cellTable.width;
			
			cellTable.scaleX  = cellTable.scaleY  = scale;			
			hitElement.scaleX = hitElement.scaleY = scale;	
			
			//			_opponentField.graphics.drawRect(rectX, rectY, _opponentField.width/10, _opponentField.height/10);
			//			_opponentField.graphics.endFill();
			
			hitElement.gotoAndPlay(2);				
			hitElement.addEventListener("finish_hit", removeHitAnimation);		
			
			selectedOponentCell.push([x, y]);
			
			trace("x: ", x, "y: ", y);
		}
		
		
		private function createViewComponents():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewGame");
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
				
				_opponentField = _skin.getChildByName("oponent_field") as MovieClip;
				_userField = _skin.getChildByName("player_field") as MovieClip;
				
				cellSize = (_userField.getChildByName("field") as MovieClip).width/10; // calculate cell size
				
				_opponentField.addEventListener(MouseEvent.MOUSE_UP, handlerSelectCell);								
				
				
				/*_txt = new TextField();
				_txt.background = true;
				_txt.x = 820;
				_txt.y = 20;
				_txt.width = 100;
				_txt.height = 50;
				
				this.addChild( _txt );*/
				
				
			}
			
			classInstance = BaseMediator.getSourceClass("viewPopUp");
			
			popUp = new classInstance();
			this.addChild( popUp );			
		}
		
		
		private function handlerSelectCell(e:MouseEvent):void
		{
			_ceilX = uint(_opponentField.mouseX/cellSize);
			_ceilY = uint(_opponentField.mouseY/cellSize);
			this.dispatchEvent( new Event(SELECT_OPPONENT_CEIL));
			
			selectedUserCell.push([_ceilX, _ceilY]);
			
			(_opponentField.getChildByName("column") as MovieClip).alpha = 0;
			(_opponentField.getChildByName("line")   as MovieClip).alpha = 0;
			
			_opponentField.removeEventListener(MouseEvent.MOUSE_MOVE,  handlerSelectCellMove);
		}
		
		private function handlerSelectCellDown(e:MouseEvent):void
		{
			_ceilX = uint(_opponentField.mouseX/cellSize);
			_ceilY = uint(_opponentField.mouseY/cellSize);
			
			if( _opponentField.getChildByName("column"))
			{
				var column:MovieClip = _opponentField.getChildByName("column") as MovieClip;
				column.alpha = 1;			
				column.x	 = _ceilX*cellSize;		
			}
			
			if( _opponentField.getChildByName("line"))
			{
				var line:MovieClip   = _opponentField.getChildByName("line")   as MovieClip;
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
				var column:MovieClip = _opponentField.getChildByName("column") as MovieClip;
				var line:MovieClip   = _opponentField.getChildByName("line")   as MovieClip;
				
				column.alpha = 1;			
				line.alpha   = 1;
				
				column.x	= _ceilX*cellSize;		
				line.y  	= (_ceilY + 1)*cellSize;
			}		
		}	
		
		private function handlerSelectCellOut(e:MouseEvent):void
		{
			if(_opponentField.getChildByName("column"))
				(_opponentField.getChildByName("column") as MovieClip).alpha = 0;
			
			if(_opponentField.getChildByName("line"))
			(_opponentField.getChildByName("line")   as MovieClip).alpha = 0;
			
			_opponentField.removeEventListener(MouseEvent.MOUSE_MOVE,  handlerSelectCellMove);
		}
		
		/**
		 * Locate ships on user field.
		 * @param val - ship list
		 * 
		 */		
		public function setShipsLocation(val:Vector.<ShipData>):void
		{		
			shipsDescriptionContainer = new Array();
			
			for (var i:int = 0; i < val.length; i++) 
			{				
				var ship:MovieClip = _skin.getChildByName("s" + val[i].deck + "_" + i) as MovieClip;	
				ship.x = val[i].x*cellSize + _userField.x;
				ship.y = val[i].y*cellSize + _userField.y;
				
				if(val[i].dirrection == 0) ship.gotoAndStop(1);		
				else					   ship.gotoAndStop(2);			
				
				shipsDescriptionContainer.push({"shipName":ship.name, "x":val[i].x, "y":val[i].y});
				
//				trace("x:", val[i].x, "y:", val[i].y, "direction: ", val[i].dirrection,  "deck: ", val[i].deck);
			}			
		}
		
			
		private function removeHitAnimation(e:Event):void
		{
			if(_skin.contains(e.currentTarget as MovieClip)) 
				_skin.removeChild(e.currentTarget as MovieClip);
			
			unlockGame();
		}
		
		public function updateProgressLine(str:String, val:Object):void
		{
			var progressLine:MovieClip;
			
			trace("val: ", val);
			
			if(str == "user")
			{
				progressLine = (_skin.getChildByName("topBar") as MovieClip).getChildByName("oponent_progress_line") as MovieClip;
				
			}else if(str == "opponent")
			{
				progressLine = (_skin.getChildByName("topBar") as MovieClip).getChildByName("user_progress_line") as MovieClip;
			}
			
			progressLine.gotoAndStop(val+1);			
		}
	}
}