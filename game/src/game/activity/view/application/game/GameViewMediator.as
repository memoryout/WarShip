package game.activity.view.application.game
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.activity.BaseMediator;
	import game.application.ProxyList;
	import game.application.game.battle.GameBattleAction;
	import game.application.game.battle.GameBattleEvent;
	import game.application.game.battle.GameBattleStatus;
	import game.application.interfaces.IMainApplicationProxy;
	import game.application.interfaces.game.battle.IGameBattleProxy;
	import game.core.IGameProxy;
	
	public class GameViewMediator extends BaseMediator
	{
		public static const NAME:			String = "mediator.game.main_mediator";
		
		private var _gameView:				GameView;
		
		private var _gameProxy:				IGameProxy;
		private var _gameBattleProxy:		IGameBattleProxy;
		
		public function GameViewMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			_gameView = new GameView();
			(viewComponent as DisplayObjectContainer).addChild( _gameView );
			
			_gameView.addEventListener(GameView.SELECT_OPPONENT_CEIL, handlerSelectCeil);
			
			
			_gameBattleProxy = this.facade.retrieveProxy( ProxyList.GAME_BATTLE_PROXY) as IGameBattleProxy;
			_gameBattleProxy.dispacther.addEventListener(GameBattleEvent.GAME_UPDATED, handlerGameUpdated);
			_gameBattleProxy.dispacther.addEventListener(GameBattleEvent.GAME_STARTED, handlerGameStarted);
		}
		
		private function handlerSelectCeil(e:Event):void
		{
			trace(_gameView.ceilX, _gameView.ceilY);
		}
		
		
		
		private function executeBattleProxyAction():void
		{
			var action:GameBattleAction = _gameBattleProxy.getAction();
			
			if(action)
			{
				switch(action.type)
				{
					case GameBattleAction.STATUS_CHANGED:
					{
						changeGameStatus();
						break;
					}
				}
			}
			else
			{
				
			}
		}
		
		
		
		private function changeGameStatus():void
		{
			if(_gameBattleProxy.getStatus() == GameBattleStatus.WAITING_FOR_START)
			{
				
			}
		}
		
		
		private function handlerGameUpdated(e:Event):void
		{
			executeBattleProxyAction();
		}
		
		
		private function handlerGameStarted(e:Event):void
		{
			
		}
	}
}