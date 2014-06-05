package game.activity.view.application.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.activity.BaseMediator;
	
	public class GameView extends Sprite
	{
		public static const SELECT_OPPONENT_CEIL:		String = "selectOpponentCeil";
		
		private var _skin:			MovieClip;
		
		private var _opponentField:	MovieClip;
		
		private var _ceilX:			uint;
		private var _ceilY:			uint;
		
		public function GameView()
		{
			createViewComponents();
		}
		
		
		public function get ceilX():uint
		{
			return _ceilX;
		}
		
		public function get ceilY():uint
		{
			return _ceilY;
		}
		
		
		private function createViewComponents():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewGame");
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
				
				_opponentField = _skin.getChildByName("oponent_field") as MovieClip;
				_opponentField.addEventListener(MouseEvent.MOUSE_UP, handlerSelectCeil);
			}
		}
		
		
		private function handlerSelectCeil(e:MouseEvent):void
		{
			_ceilX = uint(_opponentField.mouseX/(_opponentField.width/10));
			_ceilY = uint(_opponentField.mouseY/(_opponentField.height/10));
			this.dispatchEvent( new Event(SELECT_OPPONENT_CEIL));
		}
	}
}