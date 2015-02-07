package game.activity.view.application.context.pvc
{
	import flash.display.DisplayObjectContainer;
	
	import game.activity.view.application.ActivityLayoutMediator;
	import game.activity.view.application.context.pvc.level.ChooseLevelMediator;
	import game.activity.view.application.game.GameViewMediator;
	import game.activity.view.application.menu.pages.ships_positions.ShipsPositionsMediator;
	import game.application.ApplicationEvents;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class PvCContextMediator extends ActivityLayoutMediator
	{
		public static const NAME:			String = "game_context_mediator";
		
		private var _layout:		PvCContextLayout;
		
		public function PvCContextMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function onRegister():void
		{
			_layout = new PvCContextLayout();
			(viewComponent as DisplayObjectContainer).addChild( _layout );
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationEvents.BUTTLE_PROXY_INIT_COMPLETE,
				ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS,
				ApplicationEvents.USER_PRESS_BACK,
				ApplicationEvents.REQUIRED_CHOOSE_DIFFICULT_LEVEL
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case ApplicationEvents.BUTTLE_PROXY_INIT_COMPLETE:
				{
					createGameInstance();
					break;
				}
					
				case ApplicationEvents.REQUIRED_USER_SHIPS_POSITIONS:
				{
					createUserShipPositionFragment();
					break;
				}
					
				case ApplicationEvents.USER_PRESS_BACK:
				{
					trace("ApplicationEvents.USER_PRESS_BACK");
					break;
				}
					
				case ApplicationEvents.REQUIRED_CHOOSE_DIFFICULT_LEVEL:
				{
					createChooseLevelFragment();
					break;
				}
			}
		}
		
		
		private function createUserShipPositionFragment():void
		{
//			this.facade.registerMediator( new ShipsPositionsMediator( _layout) );
			this.facade.registerMediator( new GameViewMediator( _layout) );
		}
		
		
		private function createGameInstance():void
		{
			this.facade.registerMediator( new GameViewMediator( _layout) );
		}
		
		private function createChooseLevelFragment():void
		{
			this.facade.registerMediator( new ChooseLevelMediator( _layout) );
		}
	}
}