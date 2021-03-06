package game.activity.view.application
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import game.GameType;
	import game.activity.BaseMediator;
	import game.activity.view.application.context.pvc.PvCContextMediator;
	import game.activity.view.application.context.pvpnet.PvPNetGameContextMediator;
	import game.activity.view.application.game.GameViewMediator;
	import game.activity.view.application.game.result.ResultMediator;
	import game.activity.view.application.lobby.GameLobby;
	import game.activity.view.application.menu.MenuMediator;
	import game.activity.view.application.menu.pages.profiler.ProfilerMediator;
	import game.activity.view.application.windows.WindowsMediator;
	import game.application.ApplicationCommands;
	import game.application.ApplicationEvents;
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class ApplicationMediator extends ActivityLayoutMediator
	{
		public static const NAME:				String = "mediator.application";
		
		private var _appView:				ApplicationView;
		
		private var _appProxy:				IMainApplicationProxy;
		
		
		private var _gameLobby:				GameLobby;
		
		public function ApplicationMediator(name:String, viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			_appView = new ApplicationView();
			(viewComponent as DisplayObjectContainer).addChild( _appView );
			
			//_appProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			
			createWindowsMediator();
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationEvents.START_UP_COMPLETE,
						ApplicationEvents.BUTTLE_PROXY_INIT_COMPLETE,
						ApplicationEvents.GAME_CONTEXT_CREATE_COMPLETE,
						ApplicationEvents.SHOW_USER_PROFILER,
						ApplicationEvents.SHOW_RESULT_WINDOW
					];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case ApplicationEvents.START_UP_COMPLETE:
				{
					createGameLobby();
					//createMenuMediator();
					break;
				}
					
				case ApplicationEvents.BUTTLE_PROXY_INIT_COMPLETE:
				{
					createGameMediator();
					break;
				}
					
				case ApplicationEvents.GAME_CONTEXT_CREATE_COMPLETE:
				{
					createGameContextActivity( notification.getBody() as uint );
					break;
				}
				
				case ApplicationEvents.SHOW_USER_PROFILER:
				{
					showUserProfilerPage();
					break;
				}
					
				case ApplicationEvents.SHOW_RESULT_WINDOW:
				{
					createGameResult(notification.getBody());
					break;
				}
			}
		}
		
		private function showUserProfilerPage():void
		{
			this.facade.registerMediator( new ProfilerMediator( viewComponent as DisplayObjectContainer ) );
		}
				
		private function createMenuMediator():void
		{
			this.facade.registerMediator( new MenuMediator( _appView.getMenuLayer()));
		}
		
		private function createWindowsMediator():void
		{
			this.facade.registerMediator( new WindowsMediator( _appView.getWindowsLayer()));
		}
		
		
		private function createGameMediator():void
		{
			this.facade.registerMediator( new GameViewMediator( _appView.getGameLayer()));
		}
		
		private function createGameResult(val:Object):void
		{
			this.facade.removeMediator( GameViewMediator.NAME);
			this.facade.registerMediator( new ResultMediator(_appView.getWindowsLayer(), val));
		}
		
		
		private function createGameLobby():void
		{
			_gameLobby = new GameLobby();
			(viewComponent as DisplayObjectContainer).addChild( _gameLobby );
			
			_gameLobby.addEventListener( GameLobby.COMPUTER,	 handlerCreateUserVsComputerContext);
			_gameLobby.addEventListener( GameLobby.PLAYER,		 handlerCreateUserVsUserNetContext);
			_gameLobby.addEventListener( GameLobby.PROFILER,	 handlerSelectProfiler);
			
		}
		
		
		private function handlerCreateUserVsComputerContext(e:Event):void
		{			
			this.sendNotification(ApplicationCommands.CREATE_NEW_GAME, GameType.P_VS_C);
		}
		
		private function handlerCreateUserVsUserNetContext(e:Event):void
		{			
			this.sendNotification(ApplicationCommands.CREATE_NEW_GAME, GameType.P_VS_P_NET);
		}
		
		private function handlerSelectProfiler(e:Event):void
		{	
			this.sendNotification(ApplicationCommands.CREATE_PROFILER, null);
		}
		
		private function createGameContextActivity(type:uint):void
		{
			switch(type)
			{
				case GameType.P_VS_P_NET:
				{
					createActivity( PvPNetGameContextMediator, PvPNetGameContextMediator.NAME );
					break;
				}
				
				case GameType.P_VS_C:
				{
					createActivity( PvCContextMediator, PvCContextMediator.NAME );
					break;
				}
			}
		}
			
		override public function onPause():void
		{
			var canvas:DisplayObjectContainer = this.viewComponent as DisplayObjectContainer;
			
			if(canvas.contains(_gameLobby)) 
				canvas.removeChild( _gameLobby );
			
			_gameLobby.removeEventListener( GameLobby.COMPUTER, 	handlerCreateUserVsComputerContext);
			_gameLobby.removeEventListener( GameLobby.PLAYER,  		handlerCreateUserVsUserNetContext);
			_gameLobby.removeEventListener( GameLobby.PROFILER, 	handlerSelectProfiler);
			
			_gameLobby = null;
		}
				
		/*override override function onResume():void
		{
			
		}*/
		
		override public function onStop():void
		{
			
		}
	}
}