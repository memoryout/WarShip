package game.activity.view.application.menu.pages.ships_positions
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.activity.BaseMediator;
	
	public class ShipsPositionsView extends Sprite
	{
		public static const AUTO_ARRANGEMENT:		String = "autoArrangement";
		public static const BACK:					String = "back";
		
		private var _skin:			MovieClip;
		
		public function ShipsPositionsView()
		{
			super();
			
			createViewComponents();
		}
		
		
		private function createViewComponents():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewShipLocation");
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
				
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