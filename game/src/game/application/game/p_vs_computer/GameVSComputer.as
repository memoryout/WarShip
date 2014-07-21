package game.application.game.p_vs_computer
{
	import game.application.ApplicationCommands;
	import game.application.ApplicationEvents;
	import game.application.ProxyList;
	import game.application.commands.game.UserInGameActionCommand;
	import game.application.computer.ComputerAI;
	import game.application.connection.ActionsQueueEvent;
	import game.application.data.game.ShipPositionPoint;
	import game.application.game.MainGameProxy;
	import game.application.game.battle.GameBattleProxy;
	import game.application.game.battle.GameBattleStatus;
	import game.application.interfaces.actions.IActionsQueue;
	import game.application.interfaces.server.ILocalGameServer;
	
	public class GameVSComputer extends MainGameProxy
	{
		public static const LOCAL_PLAYER_ID:		String = "local_player";
		
		private const shipsDeckList:	Vector.<uint> = new <uint>[4, 3, 3, 2, 2, 2, 1, 1, 1, 1];
		
		private var _actionsQueue:		IActionsQueue;
		private var _battleProxy:		GameBattleProxy;
		private var _localServerProxy:	ILocalGameServer;
		
		private var _computerAi:		ComputerAI;
		
		public function GameVSComputer(proxyName:String=null)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			super.generateShipList( shipsDeckList );
			
			_localServerProxy = this.facade.retrieveProxy(ProxyList.LOCAL_GAME_SERVER) as ILocalGameServer;
			_actionsQueue = this.facade.retrieveProxy(ProxyList.ACTIONS_QUEUE_PROXY) as IActionsQueue;
			
			_computerAi = new ComputerAI();
			
			_localServerProxy.initGame();
			_localServerProxy.registerPlayer( LOCAL_PLAYER_ID );
			_localServerProxy.registerPlayer( ComputerAI.PLAYER_ID );

			this.sendNotification(ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS);
			
			this.facade.registerCommand(ApplicationCommands.USER_HIT_POINT, UserInGameActionCommand);
		}
		
		override public function userLocatedShips():void
		{
			var i:int, coords:Vector.<ShipPositionPoint>;
			var ships:Array = [];
			var arr:Array;
			for(i = 0; i < shipsList.length; i++)
			{
				coords = shipsList[i].coopdinates;
				
				arr = [];
				arr.push( [ coords[0].x, coords[0].y] );
				arr.push( [ coords[coords.length - 1].x, coords[coords.length - 1].y] );
				
				ships.push( arr );
			}
			
			
			_localServerProxy.sendUserShipLocation( ships );
			
			createGameBattleProxy();
			
			
			_battleProxy.setStatus(GameBattleStatus.WAITING_FOR_START);
			_battleProxy.finishDataUpdate();
		}
		
		private function createGameBattleProxy():void
		{
			_battleProxy = new GameBattleProxy()
			this.facade.registerProxy( _battleProxy );
			
			_battleProxy.init(10, 10);
			_battleProxy.initUserShips( shipsList );
		}
	}
}