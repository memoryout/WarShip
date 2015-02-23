package game.activity.view.application.game
{
	import com.freshplanet.ane.AirDeviceId;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.activity.BaseMediator;
	import game.activity.view.application.game.exit.ExitView;
	import game.activity.view.application.game.player_info.ShipLiveView;
	import game.activity.view.application.game.result.ResultMediator;
	import game.activity.view.application.game.ships_positions.ShipsPositionsView;
	import game.application.ApplicationCommands;
	import game.application.ApplicationEvents;
	import game.application.ProxyList;
	import game.application.data.game.ShipData;
	import game.application.game.battle.GameBattleAction;
	import game.application.game.battle.GameBattleEvent;
	import game.application.game.battle.GameBattleStatus;
	import game.application.interfaces.IMainApplicationProxy;
	import game.application.interfaces.game.IGameProxy;
	import game.application.interfaces.game.battle.IGameBattleProxy;
	import game.utils.GamePoint;
	import game.utils.ShipPositionSupport;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class GameViewMediator extends BaseMediator
	{
		private static const DEVICE_ID_SALT		:String = "123456789";
		public static const NAME				:String = "mediator.game.main_mediator";
		
		private var _gameView:				GameView;
		private var _positionView:			ShipsPositionsView;
		
		private var _gameBattleProxy		:IGameBattleProxy;
		
		private var _proxy					:IGameProxy;
		private var _shipsList				:Vector.<ShipData>;
		
		private var exitView				:ExitView;
		private var shipLiveView			:ShipLiveView;
				
		public function GameViewMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
				
		override public function onRegister():void
		{
			_gameView = new GameView();
			(viewComponent as DisplayObjectContainer).addChild( _gameView );
			
			_positionView = new ShipsPositionsView(_gameView);
			(viewComponent as DisplayObjectContainer).addChild( _positionView );
			
			var mainApp:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			_proxy = mainApp.getCurrentGame();
			
			_shipsList = _proxy.getShipsList();
			_positionView.setShipsData( _shipsList );
			addListenersForSetPositions();
		}
		
		
		
		private function hideTableForSetPosition():void
		{			
			_positionView.removeEventListener(ShipsPositionsView.AUTO_ARRANGEMENT, 	handlerAutoArrangement);
			_positionView.removeEventListener(ShipsPositionsView.ROTATE, 			handlerRotate);
			_positionView.removeEventListener(ShipsPositionsView.BACK, 				handlerBack);
			_positionView.removeEventListener(ShipsPositionsView.NEXT, 				handlerNext);
			
			(viewComponent as DisplayObjectContainer).removeChild( _positionView );
			
			_positionView.close();
			_positionView = null;
		}
	
		private function addListenersForGame():void
		{
			_gameView.addEventListener(GameView.SELECT_OPPONENT_CEIL, handlerSelectCeil);
			
			_gameBattleProxy.dispacther.addEventListener(GameBattleEvent.GAME_UPDATED, handlerGameUpdated);
			_gameBattleProxy.dispacther.addEventListener(GameBattleEvent.GAME_STARTED, handlerGameStarted);
		}
				
		private function addListenersForSetPositions():void
		{
			_positionView.addEventListener(ShipsPositionsView.AUTO_ARRANGEMENT, handlerAutoArrangement);
			_positionView.addEventListener(ShipsPositionsView.ROTATE, 			handlerRotate);
			_positionView.addEventListener(ShipsPositionsView.BACK, 			handlerBack);		
			_positionView.addEventListener(ShipsPositionsView.SHIP_DRAG, 		handlerChangeShipPosition);			
			
		}
		
		private function goToGameListener():void
		{
			_positionView.addEventListener(ShipsPositionsView.NEXT, 			handlerNext);
		}
			
		private function handlerAutoArrangement(e:Event):void
		{
			_shipsList = _proxy.getShipsList();
			_positionView.setShipsData( _shipsList );
			
			ShipPositionSupport.getInstance().shipsAutoArrangement(_shipsList, 10, 10);
			//			_view.updateShipPositions();
			_positionView.setShipPositionOnTable();
			
			goToGameListener();
		}
		
		private function handlerRotate(e:Event):void
		{			
			_positionView.rotateShip();				
		}
		
		private function handlerBack(e:Event):void
		{
			
		}
		
		private function handlerNext(e:Event):void
		{
			_positionView.removeEventListener(ShipsPositionsView.AUTO_ARRANGEMENT, handlerAutoArrangement);
			_positionView.removeEventListener(ShipsPositionsView.ROTATE, 	handlerRotate);
			_positionView.removeEventListener(ShipsPositionsView.BACK, 		handlerBack);
			_positionView.removeEventListener(ShipsPositionsView.NEXT, 		handlerNext);
			
			this.sendNotification( ApplicationCommands.USER_SHIPS_LOCATED_COMPLETE);
			
			hideTableForSetPosition();
			
			setGame();
		}
		
		private function setGame():void
		{
			_gameView.addEventListener(GameView.SELECT_OPPONENT_CEIL, handlerSelectCeil);
			
			_gameBattleProxy = this.facade.retrieveProxy( ProxyList.GAME_BATTLE_PROXY) as IGameBattleProxy;
			
			_gameBattleProxy.dispacther.addEventListener(GameBattleEvent.GAME_UPDATED, handlerGameUpdated);
			_gameBattleProxy.dispacther.addEventListener(GameBattleEvent.GAME_STARTED, handlerGameStarted);
			
			executeBattleProxyAction();
			setSipLocation();
			setName();
			
			_gameView.addEventListener(TopBar.OPONENT_STATE, showPlayerState);			
			_gameView.addEventListener(TopBar.USER_STATE, 	 showPlayerState);			
		}
		
		private function showPlayerState(e:Event):void
		{
			if(!shipLiveView)			
				shipLiveView = new ShipLiveView(viewComponent, _gameView);						
			
			if(e.type == TopBar.OPONENT_STATE)
			{
				if(shipLiveView.isShowedOponent)
					shipLiveView.hideOponentPopUp();
				else
				{
					if(shipLiveView.isShowedUser)
						shipLiveView.hideUserPopUp();
					
					shipLiveView.showOponentPopUp(e.type);
				}
				
			}
			else if(e.type == TopBar.USER_STATE)
			{
				if(shipLiveView.isShowedUser)
					shipLiveView.hideUserPopUp();
				else
				{
					if(shipLiveView.isShowedOponent)
						shipLiveView.hideOponentPopUp();
				
					shipLiveView.showUserPopUp(e.type);
				}
			}
		}
		
		private function handlerChangeShipPosition(e:Event):void
		{
			var shipData:ShipData = _positionView.activeShip;				// текущий ShipData
			
			var v:Vector.<GamePoint> = ShipPositionSupport.getInstance().testCollision(shipData, _shipsList);		// вектор объектов точек где произошло пересечение.
			//			trace(v);
			
			if(v.length > 0)
				_positionView.isColision = true;
			else 
				_positionView.isColision = false;
		}		
		
		private function handlerSelectCeil(e:Event):void
		{			
			this.sendNotification(ApplicationCommands.USER_HIT_POINT, {x:_gameView.ceilX, y:_gameView.ceilY});
		}
		
		private function setSipLocation():void
		{
			var mainApp:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;		
			_gameView.setShipsLocation( mainApp.getCurrentGame().getShipsList() );
		}
		
		private function setName():void
		{
			_gameView.setUsersData(_gameBattleProxy.getUserPlayerInfo());
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
						
//						
//						userMakeHit({result:2, x:action.getData().cell.x, y:action.getData().cell.y});
						_gameView.sunkUserShip(action.getData());
						
						executeBattleProxyAction();
						break;
					}
						
					case GameBattleAction.OPPONENT_SANK_USER_SHIP:
					{
//						opponentMakeHit({result:2, x:action.getData().cell.x, y:action.getData().cell.y});
						_gameView.sunkOponentShip(action.getData());
						executeBattleProxyAction();						
						break;
					}
						
					case GameBattleAction.USER_POINTS_UPDATED:
					{
						// action.getData() - points (uint) юзера
						// если нужна вся инфа по юзеру или оппоненту можешь получить их  _gameBattleProxy.getUserPlayerInfo():GamePlayerData и _gameBattleProxy.getOpponentPlayerInfo():GamePlayerData
						_gameView.updateProgressLine("user", action.getData());
						executeBattleProxyAction();
						break;
					}
						
					case GameBattleAction.OPPONENT_POINTS_UPDATED:
					{
						// action.getData() - points (uint) оппонента
						// если нужна вся инфа по юзеру или оппоненту можешь получить их  _gameBattleProxy.getUserPlayerInfo():GamePlayerData и _gameBattleProxy.getOpponentPlayerInfo():GamePlayerData
						_gameView.updateProgressLine("opponent", action.getData());
						executeBattleProxyAction();
						break;
					}
						
					case GameBattleAction.OPPONENT_EXP_UPDATED:
					{
						// action.getData() - exp (uint) оппонента
						// если нужна вся инфа по юзеру или оппоненту можешь получить их  _gameBattleProxy.getUserPlayerInfo():GamePlayerData и _gameBattleProxy.getOpponentPlayerInfo():GamePlayerData
						executeBattleProxyAction();
						break;
					}
						
					case GameBattleAction.USER_EXP_UPDATED:
					{
						// action.getData() - exp (uint) опюзераонента
						// если нужна вся инфа по юзеру или оппоненту можешь получить их  _gameBattleProxy.getUserPlayerInfo():GamePlayerData и _gameBattleProxy.getOpponentPlayerInfo():GamePlayerData
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
//				_gameView.waiting();
			}
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.STEP_OF_OPPONENT)
			{
				_gameView.lockGame();
//				_gameView.opponentStep();
			}
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.STEP_OF_INCOMING_USER)
			{
				_gameView.unlockGame();
//				_gameView.userStep();
			}
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.WAITINIG_GAME_ANSWER)
			{
				_gameView.lockGame();
//				_gameView.waitingGame();
			}
			
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.INCOMING_USER_WON)
			{
				trace("INCOMING_USER_WON");
				
				this.sendNotification(ApplicationEvents.SHOW_RESULT_WINDOW);
			}
			else if(_gameBattleProxy.getStatus() == GameBattleStatus.OPPONENT_WON)
			{
				trace("OPPONENT_WON");
				
				this.sendNotification(ApplicationEvents.SHOW_RESULT_WINDOW);
			}
			
			executeBattleProxyAction();
		}
		
		
		private function userMakeHit(data:Object):void
		{
			_gameView.userMakeHit(data, data.result);
			
			executeBattleProxyAction();
		}
		
		
		private function opponentMakeHit(data:Object):void
		{
			_gameView.opponentMakeHit(data, data.result);
			
			executeBattleProxyAction();
		}
		
		
		private function handlerGameUpdated(e:Event):void
		{
			executeBattleProxyAction();
		}
		
		
		private function handlerGameStarted(e:Event):void
		{
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationCommands.USER_PRESS_BACK
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case ApplicationCommands.USER_PRESS_BACK:
				{
					if(!exitView)
					{
						exitView = new ExitView(viewComponent);
						exitView.addEventListener(ExitView.MENU, gotoMenu);
						exitView.shopPopUp();
					}
					else
					{
						if(exitView.isShowed)
							exitView.hidePopUp();
						else
							exitView.shopPopUp();
					}
					
					break;
				}
			}
		}
		
		private function gotoMenu(e:Event):void
		{
			exitView.removeEventListener(ExitView.MENU, gotoMenu);
			this.sendNotification(ApplicationEvents.START_UP_COMPLETE);
			this.facade.removeMediator(NAME);
		}
		
		override public function onRemove():void
		{
			(viewComponent as DisplayObjectContainer).addChild( _gameView );
			_gameView.destroy();
			_gameView = null;
		}
	}
}