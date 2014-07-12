package game.application.connection
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import game.application.BaseProxy;
	import game.application.connection.actions.AuthorizationData;
	import game.application.connection.actions.ErrorData;
	import game.application.connection.actions.GameInfoData;
	import game.application.connection.actions.HitInfoData;
	import game.application.connection.actions.OpponentInfoData;
	import game.application.connection.actions.DestroyShipData;
	import game.application.connection.actions.UserInfoData;
	import game.application.interfaces.actions.IActionsQueue;
	
	public class ActionsQueue extends BaseProxy implements IActionsQueue
	{
		private const _queue:				Vector.<ActionQueueData> = new Vector.<ActionQueueData>;
		
		public function ActionsQueue(proxyName:String=null)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			
		}
		
		
		public function startQueue():void
		{
			this.sendNotification(ActionsQueueEvent.ACTIONS_QUEUE_CREATE);
		}
		
		public function parseRowData(data:Object):void
		{
			if(data.cmd)
			{
				switch(data.cmd)
				{
					case "authorize":
					{
						parseAuthorizationData(data);
						break;
					}
						
					case "start_game":
					{
						parseGameInfoDataResponce(data);
						break;
					}
						
					case "get_updates":
					{
						parseGameInfoDataResponce(data);
						break;
					}
						
					case "game_play":
					{
						parseGameInfoDataResponce(data);
						break;
					}
				}
			}
		}
		
		
		public function finishQueue():void
		{
			this.sendNotification(ActionsQueueEvent.ACTIONS_QUEUE_COMPLETE, this);
		}
		
		public function getNextAction():ActionQueueData
		{
			return _queue.shift();
		}
		
		
		
		
		
		private function parseAuthorizationData(data:Object):void
		{
			var loginInfo:Object = data.loginInfo;
			
			if(loginInfo)
			{
				var auth:AuthorizationData = new AuthorizationData();
				
				auth.login = loginInfo.login;
				auth.name = loginInfo.name;
				auth.pass = loginInfo.pass;
				auth.session = loginInfo.session;
				
				_queue.push( auth );
			}
		}
		
		
		private function parseGameInfoDataResponce(data:Object):void
		{
			
			if(data.hitInfo)
			{
				createHitAction(data.hitInfo, true);
			}
			
			if(data.gameInfo)
			{
				var gameInfo:Object = data.gameInfo;
				
				if(gameInfo.notifications)
				{
					parseGameNotifications(gameInfo.notifications);
				}
				
				parseGameInfo(data.gameInfo);
				
				
				if(gameInfo.opponent)
				{
					updateOpponentInfo(gameInfo.opponent);
				}
			}
			
			
			if(data.experienceInfo)
			{
				updateUserInfo(data.experienceInfo);
			}
			
			
			if(data.error)
			{
				createErrorAction(data.error);
			}
		}
		
		
		
		private function createHitAction(data:Object, isUser:Boolean):void
		{
			var action:HitInfoData;
			
			if(isUser) action = new HitInfoData(ActionType.USER_HIT_INFO);
			else action = new HitInfoData(ActionType.OPPONENT_HIT_INFO);
			
			action.pointX = data.target[0];
			action.pointY = data.target[1];
			action.status = data.status;
			
			_queue.push( action );
			
			if(data.ship) createDestroyShipAction(data.ship, isUser);
		}
		
		
		private function createDestroyShipAction(data:Object, isUser:Boolean):void
		{
			var action:DestroyShipData;
			
			if(isUser) action = new DestroyShipData(ActionType.USER_DESTROY_OPPONENT_SHIP);
			else action = new DestroyShipData(ActionType.OPPONENT_DESTROY_USER_SHIP);
			
			action.decks = data.decks;
			action.status = data.status;
			
			action.startX = data.coordinates[0][0];
			action.startY = data.coordinates[0][1];
			
			action.finishX = data.coordinates[1][0];
			action.finishY = data.coordinates[1][1];
			
			_queue.push( action );
		}
		
		
		private function parseGameInfo(data:Object):void
		{
			var action:GameInfoData = new GameInfoData();
			
			action.gameTime = data.game_type;
			action.status = data.status;
			action.timeOut = data.time_out;
			action.userPoints = data.points;
			
			if(data.opponent) action.opponentPoints = data.opponent.points;
			
			_queue.push( action );
		}
		
		
		private function updateOpponentInfo(data:Object):void
		{
			var action:OpponentInfoData = new OpponentInfoData();
			
			action.exp = data.experience;
			action.games_lose = data.games_lose;
			action.games_won = data.games_won;
			action.rank = data.rank;
			action.ships_destroyed = data.ships_destroyed;
			
			_queue.push( action );
		}
		
		
		private function updateUserInfo(data:Object):void
		{
			var action:UserInfoData = new UserInfoData();
			
			action.exp = data.experience;
			action.games_lose = data.games_lose;
			action.games_won = data.games_won;
			action.rank = data.rank;
			action.ships_destroyed = data.ships_destroyed;
			
			_queue.push( action );
		}
		
		
		private function parseGameNotifications(notifications:Array):void
		{
			var i:int;
			for(i = 0; i < notifications.length; i++)
			{
				if(notifications[i].type == 0)
				{
					createHitAction(notifications[i].data, false);
				}
			}
		}
		
		
		
		private function createErrorAction(data:Object):void
		{
			var action:ErrorData = new ErrorData(ActionType.ERROR);
			
			action.code = data.code;
			action.description = data.description;
			action.severity = data.severity;
			
			
			_queue.push( action );
		}
	}
}