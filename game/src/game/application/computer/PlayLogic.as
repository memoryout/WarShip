package game.application.computer
{	
	import flash.events.TimerEvent;

	public class PlayLogic
	{
		private var _userData:	Data;	
		
		public function PlayLogic(){}
		
		public function checkIfIsHit():Boolean
		{		
			if(_userData._hitData && _userData._hitData.hitInfo)
			{
				if(_userData._hitData.hitInfo.status == 1) return true; 
			}			
			
			return false;
		}
		
		public function checkIfIsKill():Boolean
		{		
			if(_userData._hitData && _userData._hitData.hitInfo)
			{
				if(_userData._hitData.hitInfo.status == 2) return true; 
			}			
			
			return false;
		}
				
		public function selectCellForHit():Array
		{
			var result:Array;
			
			if(!_userData.oponentShipIsHit || _userData.findAnotherShip)
			{
				if(_userData.findAnotherShip)	
					_userData.findAnotherShip = false;
				
				result = elementToSelect();	
					
				_userData.enemyBattleField[result[0]][result[1]] = 1;
		
			}else	result = setNextPositionAfterHit();		
								
			return 	result;
		}
						
		public function setWaterAroundFullKilledShip(vc:Vector.<Vector.<int>>, arr_t:Array, pushJustToMain:Boolean = true, pushJustToSelected:Boolean = true):Vector.<Vector.<int>>
		{
			var low_column:int, high_column:int, low_line:int, high_line:int;
			
			var _vc:Vector.<Vector.<int>> = vc.concat();
					
			if(arr_t[0][0] - 1 >= 0) 				low_column  = arr_t[0][0] - 1; 					else low_column  = 0;
			
			if(arr_t[arr_t.length - 1][0] + 1 <= 9)	high_column = arr_t[arr_t.length - 1][0] + 1;	else high_column = 9;
			
			if(arr_t[0][1] - 1 >= 0)				low_line 	= arr_t[0][1] - 1;					else low_line 	 = 0;			
			
			if(arr_t[arr_t.length - 1][1] + 1 <= 9)	high_line 	= arr_t[arr_t.length - 1][1] + 1;	else high_line   = 9;
			
			for (var i:int = low_column; i < high_column + 1; i++) 
			{
				for (var j:int = low_line; j < high_line + 1; j++) 
				{					
					if(pushJustToMain)		_vc[i][j] = 6;
					if(pushJustToSelected) _userData.enemyBattleField[i][j] = 1;
				}
			}				
			
			return _vc;		
		}
				
		/**
		 * Remove cells of arrays with the strategy of movement. 		
		 */		
		private function removeFromStrategyHitedCell(column:int, line:int):void
		{
			if(_userData.strategyArrayOne.length > 0)
			{
				for (var i:int = 0; i < _userData.strategyArrayOne.length; i++) 
				{
					if(_userData.strategyArrayOne[i][0] == column && 
						_userData.strategyArrayOne[i][1] == line)
					{
						_userData.strategyArrayOne.splice(i,1);						
						return;
					}
				}				
			}
			
			if(_userData.strategyArrayTwo.length > 0)
			{
				for (var k:int = 0; k < _userData.strategyArrayTwo.length; k++) 
				{
					if(_userData.strategyArrayTwo[k][0] == column && 
						_userData.strategyArrayTwo[k][1] == line)
					{
						_userData.strategyArrayTwo.splice(k,1);		
						return;
					}
				}		
			}
			
			if(_userData.strategyArrayThree.length > 0)
			{
				for (var p:int = 0; p < _userData.strategyArrayThree.length; p++) 
				{
					if(_userData.strategyArrayThree[p][0] == column && 
						_userData.strategyArrayThree[p][1] == line)
					{
						_userData.strategyArrayThree.splice(p,1);
						return;
					}
				}		
			}
		}
		
		/**
		 * Set position of cell to next hit.
		 * @param vc - player battlefield.
		 */		
		public function setNextPositionAfterHit():Array
		{			
			var res:Array = new Array(), way:String;
			
			var arrayOfHitedCells:Array = _userData.hitedPlayerShipPosition;
			var numberOfHitedCells:int = arrayOfHitedCells.length;				
			
			if(numberOfHitedCells == 3) /// sort elements in array						
				sortArray(arrayOfHitedCells);					
			
			if(numberOfHitedCells > 1)
			{
				if(arrayOfHitedCells[1][1] 		> arrayOfHitedCells[0][1])		way = "right";
				else if(arrayOfHitedCells[1][1] < arrayOfHitedCells[0][1])		way =  "left";		
				if(arrayOfHitedCells[1][0] 		> arrayOfHitedCells[0][0])		way = "down";			
				else if(arrayOfHitedCells[1][0] < arrayOfHitedCells[0][0])		way = "up";
			}		
			
			var arrWithPossibleNextPosition:Array = checkCellOnException(arrayOfHitedCells[0][1], arrayOfHitedCells[0][0], numberOfHitedCells, way);	
			
			/// check all possible position if they are not selected
			for (var i:int = 0; i < arrWithPossibleNextPosition.length; i++) 
			{
				var singleElement:Array = arrWithPossibleNextPosition[i];
				
				if(_userData.enemyBattleField[singleElement[0]][singleElement[1]] != 1)
				{
					res = singleElement;					
					_userData.enemyBattleField[res[0]][res[1]] = 1;
					
					break;
				}
			}
			
			if(res.length == 0)
			{
				trace("!!");
			}
									
			return res;		
		}
		
		private function sortArray(arr:Array):void
		{			
			if(arr[0][0] == arr[1][0])
			{
				arr.sortOn([1], [Array.NUMERIC]);
				
			}else if(arr[0][1] == arr[1][1])
			{
				arr.sortOn([0], [Array.NUMERIC]);			
			}	
		}
		
		/**
		 * Set combination to hit ship.
		 * @param culumn - cell on y
		 * @param line	 - cell on x
		 * @param hited_cells - number of hited cells
		 * @param way	 - direction of locating ship
		 * @return - combination of cell wich computer can select to hitn next deck on ship
		 * -------------
		 * |1|  |2|  |3|
		 * |           |
		 * |7|  |9|  |8|
		 * |		   |
		 * |4|  |5|  |6|
		 * -------------
		 */		
		private function checkCellOnException(line:int, culumn:int, hited_cells:int, way:String):Array
		{
			var res:Boolean;
			var arr:Array = new Array();
			
			if(culumn == 0 && line == 0)		//1
			{
				if(hited_cells > 1 && way)
				{					
					if(     way == "right")	arr.push([culumn, 				line + hited_cells]);					
					else if(way == "down")	arr.push([culumn + hited_cells, line]);	
				
				}else
				{
					arr.push([culumn + 1, 	line]);
					arr.push([culumn, 	 	line + 1]);
				}				
				
			}else if(culumn == 0 && line > 0)	//2
			{
				if(hited_cells > 1 && way)
				{
					arr = usualCalculation(line, culumn, hited_cells, way);	
					
				}else if(hited_cells == 1 && way)
				{	
					if(way == "right")		arr.push([culumn, line + hited_cells]);					
					else if(way == "left")	arr.push([culumn, line - hited_cells]);		
					else if(way == "down")	arr.push([culumn + hited_cells, line]);		
				
				}else
				{
					arr.push([culumn,	 	line - 1]);
					arr.push([culumn + 1,	line]);
					arr.push([culumn, 	 	line + 1]);
				}
				
			}else if(culumn == 0 && line == 9)	//3
			{
				if(hited_cells > 1 && way)
				{	
					if(way == "left")		arr.push([culumn, 				line - hited_cells]);					
					else if(way == "down")	arr.push([culumn + hited_cells, line]);	
				
				}else
				{
					arr.push([culumn, 	 line - 1]);
					arr.push([culumn + 1,line]);
				}			
				
			}else if(culumn == 9 && line == 0)	//4
			{
				if(hited_cells > 1 && way)
				{	
					if(way == "right")		arr.push([culumn, 				line + hited_cells]);					
					else if(way == "up")	arr.push([culumn - hited_cells, line]);	
				
				}else
				{
					arr.push([culumn - 1, line]);
					arr.push([culumn, 	  line + 1]);
				}			
				
			}else if(culumn == 9 && line > 0)	//5
			{
				if(hited_cells > 1 && way)
				{
					arr = usualCalculation(line, culumn, hited_cells, way);	
					
				}else if(hited_cells == 1 && way)
				{		
					if(way == "right")		arr.push([culumn, 				line + hited_cells]);					
					else if(way == "left")	arr.push([culumn, 				line - hited_cells]);	
					else if(way == "up")	arr.push([culumn - hited_cells, line]);		
				
				}else
				{						
					arr.push([culumn - 1, line]);
					arr.push([culumn, 	  line + 1]);		
					arr.push([culumn, 	  line - 1]);						
				}
				
			}else if(culumn == 9 && line == 9)	//6
			{				
				if(hited_cells > 1 && way)
				{	
					if(way == "left")		arr.push([culumn, 				line - hited_cells]);					
					else if(way == "down")	arr.push([culumn - hited_cells, line]);	
			
				}else{					
					arr.push([culumn - 1, line]);				
					arr.push([culumn, 	  line - 1]);	
				}
				
				
			}else if(culumn > 0 && line == 0)	//7
			{
				if(hited_cells > 1 && way)
				{
					arr = usualCalculation(line, culumn, hited_cells, way);	
					
				}else if(hited_cells == 1 && way)
				{
					if(way == "up")			arr.push([culumn - hited_cells, line]);					
					else if(way == "down")	arr.push([culumn + hited_cells, line]);	
					if(way == "right")		arr.push([culumn, 				line + hited_cells]);	
				
				}else{
					
					arr.push([culumn, 		line + 1]);	
					arr.push([culumn - 1, 	line]);			
					arr.push([culumn + 1, 	line]);	
				}
								
			}else if(culumn > 0 && line == 9)	//8
			{
				if(hited_cells > 1 && way)
				{
					arr = usualCalculation(line, culumn, hited_cells, way);	
					
				}else if(hited_cells == 1 && way)
				{
					if(way == "up")			arr.push([culumn - hited_cells, line]);					
					else if(way == "down")	arr.push([culumn + hited_cells, line]);	
					if(way == "left")		arr.push([culumn, 				line - hited_cells]);	
				
				}else
				{
					arr.push([culumn, 		line - 1]);	
					arr.push([culumn - 1, 	line]);			
					arr.push([culumn + 1,	line]);	
				}			
				
				
			}else{								//9	
				
				if(hited_cells == 1)
				{					
					arr.push([culumn + 1, line]);
					arr.push([culumn - 1, line]);
					arr.push([culumn, 	  line + 1]);
					arr.push([culumn, 	  line - 1]);					
					
				}else{
					arr = usualCalculation(line, culumn, hited_cells, way);	
				}
			}
			
			if(arr[0][0] > 9)
			{
				trace("> 9");
				arr[0][0] = 9;
			}
			
			if(arr[0][1] > 9)
			{
				trace("> 9");
				arr[0][1] = 9;
			}
			
			if(arr[0][0] < 0)
			{
				trace("< 0");
				arr[0][0] = 0;
			}
			
			if(arr[0][1] < 0)
			{
				trace("< 0");
				arr[0][1] = 0;
			}
			
			return arr;
		}		
		
		private function usualCalculation(line:int, culumn:int, hited_cells:int, way:String):Array
		{
			var arr:Array = new Array();
			
			
			if(way == "up")			
			{						
				arr.push([culumn - hited_cells, line]);		
				arr.push([culumn + 1,		 	line]);
			}
			else if(way == "down")	
			{						
				arr.push([culumn + hited_cells, line]);	
				arr.push([culumn - 1,		 	line]);
			}
			else if(way == "left")	
			{						
				arr.push([culumn, 				line - hited_cells]);	
				arr.push([culumn,			 	line + 1]);
			}
			else if(way == "right")	
			{						
				arr.push([culumn,			 	line + hited_cells]);
				arr.push([culumn,			 	line - 1]);			
			}
			
			return arr;
		}
		
		private function elementToSelect():Array
		{			
			var res:Array 			= new Array(), 			wasRemove:Boolean,	
			 	strategyArray:Array = getStrategyArray(),			
				randomNumber:int    = randomElement(strategyArray.length);
			
			if(_userData.levelOfGame == 0)
			{
				res = [randomElement(_userData.enemyBattleField[0].length), randomElement(_userData.enemyBattleField[0].length)];
				
			}else
				res = strategyArray[randomNumber];
			
			if(res && res.length > 0 && _userData.enemyBattleField[res[1]][res[0]] == 1)
			{
				while(_userData.enemyBattleField[res[1]][res[0]] == 1)
				{
					if(!res)
					{
						trace("!!!");
					}
					
					strategyArray = getStrategyArray();				
					randomNumber  = randomElement(strategyArray.length);
					
					res = strategyArray[randomNumber];
					
					if(strategyArray.length > 0)
					{			
						wasRemove = true;
						strategyArray.splice(randomNumber, 1);			
					}
				}	
			}			
			
			if(strategyArray.length > 0 && !wasRemove)	strategyArray.splice(randomNumber, 1);	
			
			if(!res)
			{
				trace("!!!");
			}
			
			return [res[1], res[0]];
		}
		
		private function randomElement(val:int):int
		{
			return  Math.random()*val;
		}
		
		private function getStrategyArray():Array
		{
			var res:Array = new Array();
			
			if(_userData.strategyArrayOne.length > 0)			res = _userData.strategyArrayOne;				
			else if(_userData.strategyArrayTwo.length > 0)		res = _userData.strategyArrayTwo;				
			else if(_userData.strategyArrayThree.length > 0)	res = _userData.strategyArrayThree;
			
			return res;
		}
		
		/**
		 * Correct field range for array 10x10. 		
		 */		
		private function correctRange(val:int):int
		{
			var res:int;			
			if(val > 9 ) res = 9; else if(val < 0)	res = 0; else res = val;			
			return res;			
		}
		
		public function saveGameData(val:Data):void
		{
			_userData = val as Data;			
		}
	}
}