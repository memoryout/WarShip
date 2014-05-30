package game.activity.view.application.menu.pages.ships_positions
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.activity.BaseMediator;
	import game.application.data.game.ShipData;
	import game.application.data.game.ShipDirrection;
	
	public class ShipsPositionsView extends Sprite
	{
		public static const AUTO_ARRANGEMENT:		String = "autoArrangement";
		public static const BACK:					String = "back";
		
		private var _skin:			MovieClip;
		
		private var _ships:			Vector.<ShipData>;
		private var _shipPlaceholder:MovieClip;
		
		public function ShipsPositionsView()
		{
			super();
			
			createViewComponents();
		}
		
		
		public function setShipsData(v:Vector.<ShipData>):void
		{
			_ships = v;
		}
		
		
		public function updateShipPositions():void
		{
			var i:int;
			_shipPlaceholder.graphics.clear();
			
			_shipPlaceholder.graphics.beginFill(0xff0000);
			
			for(i = 0; i < _ships.length; i++)
			{
				if(_ships[i].dirrection == ShipDirrection.HORIZONTAL) _shipPlaceholder.graphics.drawRect(_ships[i].x * 30, _ships[i].y*30, _ships[i].deck * 30, 30);
				else _shipPlaceholder.graphics.drawRect(_ships[i].x * 30, _ships[i].y*30, 30, _ships[i].deck * 30);
			}
		}
		
		
		private function createViewComponents():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewShipLocation");
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
				
				_shipPlaceholder = _skin.getChildByName("player_field") as MovieClip;
				
				_skin.addEventListener(MouseEvent.CLICK, handlerMouseClick);
			}
		}
		
		
		private function handlerMouseClick(e:MouseEvent):void
		{
			var name:String = e.target.name;
			
			switch(name)
			{
				case "btn_shuffle":
				{
					this.dispatchEvent( new Event(AUTO_ARRANGEMENT) );
					break;
				}
					
				case "btn_menu":
				{
					this.dispatchEvent( new Event(BACK) );
					break;
				}
			}
		}
	}
}