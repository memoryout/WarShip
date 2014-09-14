package game.application.computer
{
	public class PShipsArray
	{
		private static const _instance	:PShipsArray = new PShipsArray();
		
		private var battleField:						Vector.<Vector.<int>>;
		private var Ships:								Vector.<Ship>;		
		private var shipPosition:						Vector.<Array>;
		
		static private const MAXIMUM_CELL_VALUES:		int = 9;
		static private const FIELD_LENGHT:				int = 10;
		
		static private const EMPTY_CELL_INDEX:			int = 0;
		static private const WATER_CELL_INDEX:			int = 9;
		
		static private const HORIZONTAL_DIRECTION:		int = 1;
		static private const VERTICAL_DIRECTION:		int = 0;
		
		static private const ONE_DECK_INDEX:			int = 1;
		static private const TWO_DECK_INDEX:			int = 2;
		static private const THREE_DECK_INDEX:			int = 3;
		static private const FOUR_DECK_INDEX:			int = 4;
			
		static private const ONE_DECK_SHIP_NUMBER:		int = 4;
		static private const TWO_DECK_SHIP_NUMBER:		int = 3;
		static private const THREE_DECK_SHIP_NUMBER:	int = 2;
		static private const FOUR_DECK_SHIP_NUMBER:		int = 1;
		
		private var oneDeckShip:						int;
		private var twoDeckShip:						int;
		private var threeDeckShip:						int;
		private var fourDeckShip:						int;		
		
		/**
		 * The class is responsible for generating the playing field and the locattion of ships on it. 
		 */		
		public function PShipsArray()
		{
			
		}
		
		public static function Get():PShipsArray
		{
			return _instance;
		}
		
		/**
		 *  Returning vector of Ships.
		 */	
		public function getShipsPosition():Vector.<Vector.<Ship>>
		{		
			initVariables();
			fillBattleField();
			
			var res:Vector.<Vector.<Ship>> = new Vector.<Vector.<Ship>>;
			res.push(Ships);				
			return res;
		}
		
		/**
		 *  Returning <b>battleField</b>.
		 */	
		public function getBattleField():Vector.<Vector.<int>>
		{			
			return battleField;
		}		
		
		/** 
		 * Initialization of main variables.
		 */		
		private function initVariables():void
		{
			oneDeckShip 	= ONE_DECK_SHIP_NUMBER;
			twoDeckShip 	= TWO_DECK_SHIP_NUMBER;
			threeDeckShip 	= THREE_DECK_SHIP_NUMBER;
			fourDeckShip	= FOUR_DECK_SHIP_NUMBER;
			
			battleField		= new Vector.<Vector.<int>>;
			Ships 			= new Vector.<Ship>;	
			shipPosition	= new Vector.<Array>;
		
			for (var n:int = 0; n < FIELD_LENGHT; n++) 
			{
				battleField[n] = new Vector.<int>(FIELD_LENGHT, false);
			}					
		}
		
		/**
		 * Filling ships with the necessary parameters of the battlefield. 
		 */		
		private function fillBattleField():void
		{			
			fillBattlefieldTargetElements(FOUR_DECK_SHIP_NUMBER,	FOUR_DECK_INDEX);
			fillBattlefieldTargetElements(THREE_DECK_SHIP_NUMBER, 	THREE_DECK_INDEX);
			fillBattlefieldTargetElements(TWO_DECK_SHIP_NUMBER,		TWO_DECK_INDEX);
			fillBattlefieldTargetElements(ONE_DECK_SHIP_NUMBER,		ONE_DECK_INDEX);		
		}
		
		/**
		 * 	Get the value of a column, line, and direction calling createRandomNumber. 
		 *  Check the received parameters. If received parameters were approached, call putShipInBattleField, saveDataAboutShipLocation;
		 */		
		private function fillBattlefieldTargetElements(_shipNumber:int, _deckNumber:int):void
		{
			var column:	int, line:int, direction:int;
			
			while(_shipNumber > 0)
			{
				shipPosition	= new Vector.<Array>;
				
				column 		= createRandomNumber(FIELD_LENGHT);
				line   		= createRandomNumber(FIELD_LENGHT);
				direction   = createRandomNumber(2);
				
				if(	checkBattleFieldForFreeSpace( column, line, direction, _deckNumber) )
				{
					putShipInBattleField(column, line, direction, _deckNumber);
					saveDataAboutShipLocation(direction, _deckNumber);							
					_shipNumber--;
				}
			}
		}
		
		/**		
		 * Saving main data about instance Ship.
		 */		
		private function saveDataAboutShipLocation(_direction:int, _deckNumber:int):void
		{
			var _ship:Ship 		= new Ship();
			_ship.column 		= shipPosition[0][0];
			_ship.line 			= shipPosition[0][1];
			_ship.direction 	= _direction;
			_ship.deck 			= _deckNumber;					
			_ship.coordinates 	= shipPosition.concat();						
			
			Ships.push(_ship);
		}
		
		/**
		 * Check out whether you can put a ship in battleField with the appropriate parameters:
		 * @param _column 		- column number,
		 * @param _line			- line number,
		 * @param _direction	- direction along a column(1) or a line(0),
		 * @param _deckNumber   - number of decks on ships.
		 */		
		private function checkBattleFieldForFreeSpace(_column:int, _line:int, _direction:int, _deckNumber:int):Boolean
		{
			var res:Boolean, deckCouter:int, i:int;
			
			if(_direction == HORIZONTAL_DIRECTION)
			{				
				if( (MAXIMUM_CELL_VALUES - _column - _deckNumber ) >= 0 )
				{
					for (i = _column; i < _column + _deckNumber; i++) 
					{
						if(battleField[i][_line] == EMPTY_CELL_INDEX)	deckCouter++;
					}	
					
				}else{
					
					for (i = _column; i > _column - _deckNumber; i--) 
					{
						if(battleField[i][_line] == EMPTY_CELL_INDEX)	deckCouter++;
					}
				}
				
			}else if(_direction == VERTICAL_DIRECTION)
			{						
				if( (MAXIMUM_CELL_VALUES - _line - _deckNumber ) >= 0 )
				{
					for (i = _line; i < _line + _deckNumber; i++) 
					{
						if(battleField[_column][i] == EMPTY_CELL_INDEX)	deckCouter++;
					}
					
				}else{
					
					for (i = _line; i > _line - _deckNumber; i--) 
					{
						if(battleField[_column][i] == EMPTY_CELL_INDEX)	deckCouter++;
					}					
				}				
			}
			
			if(deckCouter == _deckNumber) res = true;
			
			return res;
		}
		
		/**
		 * Saving a ship in battleField with the appropriate parameters:
		 * @param _column 		- column number,
		 * @param _line			- line number,
		 * @param _direction	- direction along a column(1) or a line(0),
		 * @param _deckNumber   - number of decks on ships.<br>
		 * 
		 * Setting empty cells around ships with index WATER_CELL_INDEX.
		 */	
		private function putShipInBattleField(_column:int, _line:int, _direction:int, _deckNumber:int):void
		{
			var increment:Boolean, i:int, j:int, lineRanges:Array, columnRanges:Array,	shipPosition:Vector.<int> = new Vector.<int>;
						
			if(_direction == HORIZONTAL_DIRECTION)
			{				
				if( (MAXIMUM_CELL_VALUES - _column - _deckNumber ) >= 0 )
				{
					increment = true;
					
					for (i = _column; i < _column + _deckNumber; i++) 
					{
						if(battleField[i][_line] == EMPTY_CELL_INDEX)
						{
							battleField[i][_line] = _deckNumber;
							saveShipCoordinates(i, _line, true);	
						}
					}											
				}else{
					
					for (i = _column; i > _column - _deckNumber; i--) 
					{
						if(battleField[i][_line] == EMPTY_CELL_INDEX)
						{
							battleField[i][_line] = _deckNumber;
							saveShipCoordinates(i, _line, false);												
						}
					}
				}				
								
				lineRanges 	 = setRange(_line, 1 , increment);			
				columnRanges = setRange(_column, _deckNumber , increment);					
				
				for (j = lineRanges[0]; j < lineRanges[1] + 1; j++) 
				{
					for (i = columnRanges[0]; i < columnRanges[1] + 1; i++) 
					{
						if(battleField[i][j] == EMPTY_CELL_INDEX)	battleField[i][j] = WATER_CELL_INDEX;										
					}
				}				
				
			}else if(_direction == VERTICAL_DIRECTION)
			{						
				if( (MAXIMUM_CELL_VALUES - _line - _deckNumber ) >= 0 )
				{
					increment = true;
					
					for (i = _line; i < _line + _deckNumber; i++) 
					{
						if(battleField[_column][i] == EMPTY_CELL_INDEX)
						{
							battleField[_column][i] = _deckNumber;
							saveShipCoordinates(_column, i, true);							
						}
					}					
				}else{
					
					for (i = _line; i > _line - _deckNumber; i--) 
					{
						if(battleField[_column][i] == EMPTY_CELL_INDEX)
						{
							battleField[_column][i] = _deckNumber;
							saveShipCoordinates(_column, i, false);									
						}
					}					
				}					
			
				lineRanges 	 = setRange(_line, _deckNumber , increment);			
				columnRanges = setRange(_column, 1 , increment);					
				
				for (j = columnRanges[0]; j < columnRanges[1] + 1; j++) 
				{
					for (i = lineRanges[0]; i < lineRanges[1] + 1; i++) 
					{
						if(battleField[j][i] == EMPTY_CELL_INDEX)	battleField[j][i] = WATER_CELL_INDEX;
					}
				}				
			}			
		}
		
		/**
		 * Save the position of all decks for target ship.
		 * @param _column 		- column number,
		 * @param _line			- line number,
		 * @param _moveToTheEnd - save at the beginning or end shipPosition.
		 * 
		 */		
		private function saveShipCoordinates(_column:int, _line:int, _moveToTheEnd:Boolean):void
		{
			if(_moveToTheEnd)	shipPosition.push([_column, _line]);
			else				shipPosition.unshift([_column, _line]);
		}
		
		/**
		 * Calculate range for filling water around ship depend on parameters:
		 * @param _cell 		- init ship position, column or line,
		 * @param _deckNumber   - number of decks on ships,
		 * @param _increment	- check next or previous cell. <br>
		 * 
		 * Return element with [0] - low range, [1] - high range.
		 */		
		private function setRange(_cell:int, _deckNumber:int, _increment:Boolean):Array
		{
			var lowRange:int, highRange:int;
			
			if(_cell == 0)
			{
				lowRange  = 0;
				highRange = _cell + _deckNumber;
				
			}else if(_cell == MAXIMUM_CELL_VALUES)
			{
				lowRange  = _cell - _deckNumber;
				highRange = MAXIMUM_CELL_VALUES;
				
			}else
			{
				if(_increment)
				{
					lowRange  = _cell - 1;
					highRange = _cell + _deckNumber;
					
				}else{
					
					lowRange  = _cell - _deckNumber;
					highRange = _cell + 1;
				}
			}			
		
			return 	[lowRange, highRange];
		}
		
		/**
		 *  Get random int number from 0 to <b>_value</b>.
		 */		
		private function createRandomNumber(_value:int):int
		{			
			return Math.random()*_value;	
		}
		
		/** 
		 * Reset variables.
		 */		
		public function cleanData():void
		{
			if(battleField)		battleField.length = 0;			
			if(shipPosition) 	shipPosition.length = 0;		
			
			battleField  = null;
			shipPosition = null;
		}
		
		public function traceShipsArray(txt:Object, clear:Boolean = false):void
		{
			if(clear) txt.text = "";
			
			for (var i:int = 0; i < battleField.length; i++) 
			{ 
				txt.text += 
					battleField[i][0].toString() + "   " + 
					battleField[i][1].toString() + "   " +
					battleField[i][2].toString() + "   " + 
					battleField[i][3].toString() + "   " + 
					battleField[i][4].toString() + "   " + 
					battleField[i][5].toString() + "   " +
					battleField[i][6].toString() + "   " + 
					battleField[i][7].toString() + "   " + 
					battleField[i][8].toString() + "   " + 
					battleField[i][9].toString() + "\n";				
			}			
		}
	}
}