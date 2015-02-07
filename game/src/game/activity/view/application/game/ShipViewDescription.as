package game.activity.view.application.game
{
	import flash.display.MovieClip;

	public class ShipViewDescription
	{
		private var _shipName:String;
		
		private var _x:Number;
		private var _y:Number;
		
		private var _sunk:Boolean;
		
		private var _deck:int;
		
		private var _link:MovieClip;
		
		private var _dirrection:int;	
		
		public function ShipViewDescription()
		{
		}
		
		
		public function set shipName(name:String):void
		{
			_shipName = name;
		}
		
		public function get shipName():String
		{
			return _shipName;
		}
		
		public function set x(val:Number):void
		{
			_x = val;
		}
		
		public function get x():Number
		{
			return _x;
		}
				
		public function set y(val:Number):void
		{
			_y = val;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set sunk(val:Boolean):void
		{
			_sunk = val;
		}
		
		public function get sunk():Boolean
		{
			return _sunk;
		}
				
		public function set deck(val:int):void
		{
			_deck = val;
		}
		
		public function get deck():int
		{
			return _deck;
		}		
		
		public function set link(val:MovieClip):void
		{
			_link = val;
		}
		
		public function get link():MovieClip
		{
			return _link;
		}
		
		public function set dirrection(val:int):void
		{
			_dirrection = val;
		}
		
		public function get dirrection():int
		{
			return _dirrection;
		}
	}
}