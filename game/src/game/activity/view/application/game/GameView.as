package game.activity.view.application.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.activity.BaseMediator;
	
	public class GameView extends Sprite
	{
		public static const SELECT_OPPONENT_CEIL:		String = "selectOpponentCeil";
		
		private var _skin:			MovieClip;
		
		private var _opponentField:	MovieClip;
		private var _userField:		MovieClip;
		
		private var _ceilX:			uint;
		private var _ceilY:			uint;
		
		private var _txt:			TextField;
		
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
		
		
		public function lockGame():void
		{
			_opponentField.removeEventListener(MouseEvent.MOUSE_UP, handlerSelectCeil);
		}
		
		
		public function unlockGame():void
		{
			_opponentField.addEventListener(MouseEvent.MOUSE_UP, handlerSelectCeil);
		}
		
		
		
		public function waiting():void
		{
			this.alpha = 0.5;
			_txt.text = "WAITING";
		}
		
		
		public function opponentStep():void
		{
			this.alpha = 1;
			_txt.text = "OPPONENT STEP";
		}
		
		public function userStep():void
		{
			this.alpha = 1;
			_txt.text = "USER STEP";
		}
		
		public function waitingGame():void
		{
			this.alpha = 0.5;
			_txt.text = "WAITNIG GAME ANSWER";
		}
		
		
		/**
		 * Игрок сделал выстрел, значит рисуем на поле оппонента.
		 * */
		public function userMakeHit(x:uint, y:uint, result:uint):void
		{
			if(result == 0) _opponentField.graphics.beginFill(0x0000ff);
			else if(result == 1) _opponentField.graphics.beginFill(0xff0000);

			var rectX:Number = (_opponentField.width/10) * x;
			var rectY:Number = (_opponentField.height/10) * y;
				
			_opponentField.graphics.drawRect(rectX, rectY, _opponentField.width/10, _opponentField.height/10);
			_opponentField.graphics.endFill();
		}
		
		
		/**
		 * Противник сделал выстрел, значит отмечаем его на своём поле.
		 * Для вычислений используеться _opponentField хотя рисуеться на _userField - это временно
		 * */
		public function opponentMakeHit(x:uint, y:uint, result:uint):void
		{
			
			if(result == 0) _opponentField.graphics.beginFill(0x0000ff);
			else if(result == 1) _opponentField.graphics.beginFill(0xff0000);
			
			var rectX:Number = (_opponentField.width/10) * x;
			var rectY:Number = (_opponentField.height/10) * y;
			
			_userField.graphics.drawRect(rectX, rectY, _opponentField.width/10, _opponentField.height/10);
			_userField.graphics.endFill();
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
				
				
				_userField = new MovieClip();
				_skin.addChild( _userField );
				
				var playerField:MovieClip = _skin.getChildByName("player_field") as MovieClip;
				
				_userField.x = playerField.x;
				_userField.y = playerField.y;
				
				_txt = new TextField();
				_txt.background = true;
				_txt.x = 820;
				_txt.y = 20;
				_txt.width = 300;
				
				this.addChild( _txt );
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