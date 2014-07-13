package game.application.data.game
{
	public class ShipPositionPoint
	{
		public var x:		Number;
		public var y:		Number;
		
		public function ShipPositionPoint(x:Number = 0, y:Number = 0)
		{
			this.x = x;
			this.y = y;
		}
		
		
		public function toString():String
		{
			return "[ShipPositionPoint x=" + x.toString() + " y=" + y.toString() + "]"
		}
	}
}