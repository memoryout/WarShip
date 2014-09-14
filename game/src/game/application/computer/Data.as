package game.application.computer
{
	public class Data
	{		
		public static const OPPONENT_PLAYER:	uint = 0;
		public static const OPPONENT_COMPUTER:	uint = 1;
				
		static private const FIELD_LENGHT:		int = 10;
		
		public var key:					String;
		public var name:				String;
		public var login:				String;
			
		public var userShips:			Vector.<Vector.<Ship>> = new Vector.<Vector.<Ship>>;
		public var enemyShips:			Vector.<Vector.<Ship>> = new Vector.<Vector.<Ship>>;
		
		public var userBattleField:		Vector.<Vector.<int>>  = new Vector.<Vector.<int>>;
		public var enemyBattleField:	Vector.<Vector.<int>>  = new Vector.<Vector.<int>>;
		
		public var selectedElements:	Vector.<Array> = new Vector.<Array>;
		
		private var _id:				uint;    // current game id
		
		public var _status:				uint;	 // current game status		
		
		public var hitedPlayerShipPosition:			Array = new Array();
		public var pushedIndexesForFindLastCell:	Array = new Array();
		
		public var killedShipsCouterCom:	int;
		public var killedShipsCouterPl:		int;		
		
		public var oponentShipIsHit:	Boolean;
		public var shipIsKill:			Boolean;
		public var findAnotherShip:		Boolean;		
		public var isHited:				Boolean;
		
		public var currentSelectedCell:	Array = new Array();
		
		public var infoAboutShipsDecksPl:	Array = [4,  3, 3,  2, 2, 2, 1, 1, 1, 1];		
		public var infoAboutShipsDecksCom:	Array = [4,  3, 3,  2, 2, 2, 1, 1, 1, 1];
		
		public var _hitData:Object = new Object();
				
		public var strategyArrayOne:Array = 
			[	[0,3], [0,7],
				[1,2], [1,6], 
				[2,1], [2,5], [2,9],
				[3,0], [3,4], [3,8],
				[4,3], [4,7], 
				[5,2], [5,6],
				[6,1], [6,5], [6,9],
				[7,0], [7,4], [7,8],
				[8,3], [8,7],
				[9,2], [9,6] ];
		
		public var strategyArrayTwo:Array = 
			[	[0,1], [0,5],
				[1,0], [1,4], 
				[2,3], [2,7],
				[3,2], [3,6],
				[4,1], [4,5], [4,9],
				[5,0], [5,4], [5,8],
				[6,3], [6,7],
				[7,2], [7,6],
				[8,1], [8,5], [8,9],
				[9,0], [9,4], [9,8]	];
		
		public var strategyArrayThree:Array = 
			[	[0,0], [0,2], [0,4], [0,6], [0,8],
				[1,1], [1,3], [1,5], [1,7], [1,9],
				[2,0], [2,2], [2,4], [2,6], [2,8],
				[3,1], [3,3], [3,5], [3,7], [3,9],
				[4,0], [4,2], [4,4], [4,6], [4,8],
				[5,1], [5,3], [5,5], [5,7], [5,9],
				[6,0], [6,2], [6,4], [6,6], [6,8],
				[7,1], [7,3], [7,5], [7,7], [7,9],
				[8,0], [8,2], [8,4], [8,6], [8,8],
				[9,1], [9,3], [9,5], [9,7], [9,9], 
				
				
				[0,9], [1,8]  ];
		
		// part of variables correspon to game with computer
		
		public function Data()
		{
			enemyBattleField		= new Vector.<Vector.<int>>;
			
			for (var n:int = 0; n < FIELD_LENGHT; n++) 
			{
				enemyBattleField[n] = new Vector.<int>(FIELD_LENGHT, false);
			}	
		}
		
		public function get hitData():Object
		{
			return _hitData;
		}
		
		public function set hitData(val:Object):void
		{
			_hitData = val;
		}
		
		public function get id():uint
		{
			return _id;
		}
		
		public function set id(val:uint):void
		{
			_id = val;
		}
		
		public function get status():uint
		{
			return _status;
		}
		
		public function set status(val:uint):void
		{
			_status = val;
		}
	}
}