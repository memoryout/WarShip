package game.activity.view.application.game
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.activity.BaseMediator;
	import game.application.ApplicationCommands;
	import game.application.ProxyList;
	import game.application.game.battle.GameBattleAction;
	import game.application.game.battle.GameBattleEvent;
	import game.application.game.battle.GameBattleStatus;
	import game.application.interfaces.IMainApplicationProxy;
	import game.application.interfaces.game.battle.IGameBattleProxy;
	
	public class GameViewMediator extends BaseMediator
	{
		public static const NAME:			String = "mediator.game.main_mediator";
		
		private var _gameView:				GameView;
		
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
			
			executeBattleProxyAction();
			setSipLocation();
		}
		
		private function handlerSelectCeil(e:Event):void
		{
			trace(_gameView.ceilX, _gameView.ceilY);
			
			this.sendNotification(ApplicationCommands.USER_HIT_POINT, {x:_gameView.ceilX, y:_gameView.ceilY});
		}
		
		private function setSipLocation():void
		{
			var mainApp:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;		
			_gameView.setShipsLocation( mainApp.getCurrentGame().getShipsList() );
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
						
					case GameBattleAction.USER_MAKE_HIT:
					{
						userMakeHit(action.getData());
						break;
					}
						
					case GameBattleAction.OPPONENT_MAKE_HIT:
					{
						opponentMakeHit(action.getData());
						break;
					}
						
					case GameBattleAction.USER_SANK_OPPONENTS_SHIP:
					{
						// я потопил корабль противника
						// var data = action.getData();
						// data.ship =  ShipData - инфа по кораблю который был потоплен
						// data.fieldPoint = Vector.<ShipPositionPoint> - точки на поле вокруг горабля.
						
						executeBattleProxyAction();
						break;
					}
						
					default:
					{
						executeBattleProxyAction();
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
				_gameView.lockGame();
				_gameView.waiting();
			}
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.STEP_OF_OPPONENT)
			{
				_gameView.lockGame();
				_gameView.opponentStep();
			}
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.STEP_OF_INCOMING_USER)
			{
				_gameView.unlockGame();
				_gameView.userStep();
			}
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.WAITINIG_GAME_ANSWER)
			{
				_gameView.lockGame();
				_gameView.waitingGame();
			}
			
			executeBattleProxyAction();
		}
		
		
		private function userMakeHit(data:Object):void
		{
			_gameView.userMakeHit(data.x, data.y, data.result);
			
			executeBattleProxyAction();
		}
		
		
		private function opponentMakeHit(data:Object):void
		{
			_gameView.opponentMakeHit(data.x, data.y, data.result);
			
			executeBattleProxyAction();
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