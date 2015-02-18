package game.application.connection
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import game.application.connection.data.AuthorizationData;
	import game.application.connection.data.DestroyShipData;
	import game.application.connection.data.ErrorData;
	import game.application.connection.data.ExperienceInfo;
	import game.application.connection.data.GameInfoData;
	import game.application.connection.data.HitInfoData;
	import game.application.connection.data.OpponentInfoData;
	import game.application.connection.data.UserInfo;
	import game.application.connection.data.UserInfoData;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.library.BaseProxy;
	import game.library.LocalDispactherProxy;
	
	public class ServerDataChannel extends LocalDispactherProxy implements IServerDataChannel
	{
		private const _queue:				Vector.<ChannelData> = new Vector.<ChannelData>;
		
		private const _event:				Event = new Event(ServerDataChannelEvent.ACTIONS_QUEUE_COMPLETE);
		
		public function ServerDataChannel(proxyName:String=null)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			
		}
		
		
		public function processRawData(data:Object):void
		{
			if(data.cmd)
			{
				switch(data.cmd)
				{
					case "login_gg":
					case "login":
					{
						parseLoginData(data);
						break;
					}
					
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
			
			
			sendData();
		}
		
		
		public function sendData():void
		{
			this.sendNotification(ServerDataChannelEvent.ACTIONS_QUEUE_CREATE, proxyName);
			this.dispactherLocalEvent( ServerDataChannelLocalEvent.ACTIONS_QUEUE_CREATE);
			
			var i:int;
			for(i = 0; i < _queue.length; i++)
			{
				this.dispactherLocalEvent( ServerDataChannelLocalEvent.CHANNEL_DATA, _queue[i]);
			}
			
			_queue.length = 0;
			
			this.dispactherLocalEvent( ServerDataChannelLocalEvent.ACTIONS_QUEUE_COMPLETE);
			this.sendNotification(ServerDataChannelEvent.ACTIONS_QUEUE_COMPLETE, this);
		}
		
		
		public function pushData(data:ChannelData):void
		{
			_queue.push( data );
		}
		
		
		private function parseLoginData(data:Object):void
		{
			var auth:AuthorizationData;
			auth = new AuthorizationData();
			
			if(data.error)
			{
				auth.error = true;
				auth.errorCode = data.error.code;
				auth.errorMessage = data.error.description;
				
				_queue.push( auth );
			}
			else
			{
				var userInfo:Object = data.userInfo;
				
				if(userInfo)
				{
					auth.userInfo = new UserInfo();
					auth.userInfo.uid = userInfo.uid;
					auth.userInfo.name = userInfo.name;
					auth.userInfo.status = userInfo.status;
					auth.userInfo.flag = userInfo.flag;
					auth.userInfo.userpic = userInfo.userpic;
					auth.userInfo.a_ships_skins = userInfo.a_ships_skins;
					auth.userInfo.a_userpics = userInfo.a_userpics;
					auth.userInfo.a_flags = userInfo.a_flags;
					
					if(userInfo.experienceInfo)
					{
						auth.userInfo.expInfo = new ExperienceInfo();
						auth.userInfo.expInfo.experience = userInfo.experienceInfo.experience;
						auth.userInfo.expInfo.rank = userInfo.experienceInfo.rank;
						auth.userInfo.expInfo.ships_destroyed = userInfo.experienceInfo.ships_destroyed;
						auth.userInfo.expInfo.games_won = userInfo.experienceInfo.games_won;
						auth.userInfo.expInfo.games_lose = userInfo.experienceInfo.games_lose;
						auth.userInfo.expInfo.achievements = userInfo.experienceInfo.achievements;
					}
				}
				
				if(data.loginInfo)
				{
					auth.session = data.loginInfo.session;
				}
				
				_queue.push( auth );
			}
		}
		
		
		private function parseAuthorizationData(data:Object):void
		{
			var loginInfo:Object = data.loginInfo;
			
			var auth:AuthorizationData;
			auth = new AuthorizationData();
			
			if(loginInfo)
			{
				//auth.login = loginInfo.login;
				//auth.name = loginInfo.name;
				//auth.pass = loginInfo.pass;
				auth.session = loginInfo.session;
				
				_queue.push( auth );
			}
			else if(data.error)
			{
				auth.error = true;
				auth.errorCode = data.error.code;
				auth.errorMessage = data.error.description;
				
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
			
			if(isUser) action = new HitInfoData(ChannelDataType.USER_HIT_INFO);
			else action = new HitInfoData(ChannelDataType.OPPONENT_HIT_INFO);
			
			action.pointX = data.target[0];
			action.pointY = data.target[1];
			action.status = data.status;
			
			_queue.push( action );
			
			if(data.ship) createDestroyShipAction(data.ship, isUser);
		}
		
		
		private function createDestroyShipAction(data:Object, isUser:Boolean):void
		{
			var action:DestroyShipData;
			
			if(isUser) action = new DestroyShipData(ChannelDataType.USER_DESTROY_OPPONENT_SHIP);
			else action = new DestroyShipData(ChannelDataType.OPPONENT_DESTROY_USER_SHIP);
			
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
			
			action.gameTime = data.game_time;
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
			action.name = data.name;
			
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
			var action:ErrorData = new ErrorData(ChannelDataType.ERROR);
			
			action.code = data.code;
			action.description = data.description;
			action.severity = data.severity;
			
			
			_queue.push( action );
		}
		
		
		
		override public function destroy():void
		{
			_queue.length = 0;
			
			this.facade.removeProxy( this.proxyName );
			
			super.destroy();
		}
	}
}