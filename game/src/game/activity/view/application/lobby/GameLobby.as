package game.activity.view.application.lobby
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.activity.BaseMediator;
	import game.activity.view.application.AdMobContainer;
	
	public class GameLobby extends Sprite
	{
		public static const COMPUTER:	String = "computer";
		public static const PLAYER:		String = "player";
		public static const PROFILER:	String = "profiler";
		
		private var _skin:				MovieClip;
		
		public function GameLobby()
		{
			super();
			
			
			createViewSkin();
		}
		
		public function close():void
		{
			if(_skin) _skin.removeEventListener(MouseEvent.CLICK, handlerMouseClick);
			if(this.parent) this.parent.removeChild( this );
			
			_skin = null;
		}
		
		
		private function createViewSkin():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewActiveGame");
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
				
				_skin.addEventListener(MouseEvent.CLICK, handlerMouseClick);
			}
			
			AdMobContainer.getInstance().addTopBanner();
		}
		
		
		private function handlerMouseClick(e:MouseEvent):void
		{
			if(e.target.name == "allPlayer")
			{
				this.dispatchEvent( new Event(PLAYER) );
			}
			else if(e.target.name == "computerPullBtn")
			{
				this.dispatchEvent( new Event(COMPUTER) );
			}
			else if(e.target.name == "profileBtn")
			{
				this.dispatchEvent( new Event(PROFILER) );
			}
		}
	}
}