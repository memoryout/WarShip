package game.activity.view.application.game.result
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.activity.BaseMediator;

	public class ResultView extends Sprite
	{
		public static const MENU:		String = "menu";
		public static const REVANGE:	String = "revange";
		public static const PLAY_AGAIN:	String = "play_again";
		
		public function ResultView()
		{
			init();
		}
		
		private function init():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("ResultWindow");
			
			var element:MovieClip = new classInstance();
			this.addChild( element );	
			
			this.addEventListener(MouseEvent.CLICK, handlerMouseClick);
		}
		
		private function setTexts():void
		{
			trace("!");
		}
		
		private function handlerMouseClick(e:MouseEvent):void
		{
			var name:String = e.target.name;
			
			switch(name)
			{
				case "menuBtn":
				{
					this.dispatchEvent( new Event(MENU) );					
					break;
				}
					
				case "revangeBtn":
				{
					this.dispatchEvent( new Event(REVANGE) );
					break;
				}
					
				case "playAgainBtn":
				{
					this.dispatchEvent( new Event(PLAY_AGAIN) );
					break;
				}
			}
		}
	}
}