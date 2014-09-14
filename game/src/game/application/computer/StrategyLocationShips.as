package game.application.computer
{
	public class StrategyLocationShips
	{
		private static const _instance	:StrategyLocationShips = new StrategyLocationShips();
		
		private var strategyOne:Array = 
			[
				{"column":0, "line":0, "dirrection":0, "deck":4},
				{"column":2, "line":0, "dirrection":0, "deck":3},
				{"column":2, "line":4, "dirrection":0, "deck":3},
				{"column":0, "line":5, "dirrection":0, "deck":2},
				{"column":0, "line":8, "dirrection":0, "deck":2},
				{"column":2, "line":8, "dirrection":0, "deck":2}				
			];
		
		private var strategyTwo:Array = 
			[
				{"column":0, "line":0, "dirrection":0, "deck":4},
				{"column":2, "line":0, "dirrection":1, "deck":3},
				{"column":0, "line":5, "dirrection":0, "deck":3},
				{"column":6, "line":0, "dirrection":1, "deck":2},
				{"column":9, "line":0, "dirrection":0, "deck":2},
				{"column":0, "line":9, "dirrection":1, "deck":2}
			];
		
		private var strategyThree:Array = 
			[				
				{"column":0, "line":6, "dirrection":0, "deck":4},
				{"column":9, "line":0, "dirrection":0, "deck":3},
				{"column":9, "line":4, "dirrection":0, "deck":3},
				{"column":0, "line":0, "dirrection":0, "deck":2},
				{"column":0, "line":3, "dirrection":0, "deck":2},
				{"column":9, "line":8, "dirrection":0, "deck":2}
			];
		
		public var strategyArray:Array = 
			[
				strategyOne,
				strategyTwo,
				strategyTwo			
			];
		
		public function StrategyLocationShips()
		{
		}
		
		
		public static function Get():StrategyLocationShips
		{
			return _instance;
		}
		
	}
}