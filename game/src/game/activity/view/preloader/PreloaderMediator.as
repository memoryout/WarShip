package game.activity.view.preloader
{
	import com.milkmangames.nativeextensions.GoogleGames;
	import com.milkmangames.nativeextensions.events.GoogleGamesEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import game.activity.BaseMediator;
	import game.application.ApplicationEvents;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PreloaderMediator extends BaseMediator
	{
		public static const NAME:			String = "mediator.preloader";
		
		private var _view:				PreloaderView;
		
		public function PreloaderMediator(view:Object = null)
		{
			super(NAME, view);
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationEvents.START_UP_COMPLETE];
		}
		
		
		override public function onRegister():void
		{
			_view = new PreloaderView();
			(viewComponent as DisplayObjectContainer).addChild( _view );
			
			
//			_view.addEventListener(MouseEvent.CLICK, handlerClickSignIn);
			
			
		}
		
		
		/*private function handlerClickSignIn(e:MouseEvent):void
		{
			//GoogleGames.games.signOut();
			
			
			if (GoogleGames.games.isSignedIn())
			{
				trace("Is signed in already")
			}
			else
			{
				trace("try to sign in")
				GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, onSignedIn);
				GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_FAILED, onGamesError);
				GoogleGames.games.signIn();
			}
			
		}
		
		private function onSignedIn(e:GoogleGamesEvent):void
		{
			trace("Player signed in! : "+GoogleGames.games.getCurrentPlayerId()+"["+GoogleGames.games.getCurrentPlayerName()+"]");
		}
		
		/** Signed Out */
		/*private function onGamesError(e:GoogleGamesEvent):void
		{
			trace("ERROR: "+e.type+": "+e.failureReason);
		}*/
		
		override public function onRemove():void
		{
			_view = null;
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case ApplicationEvents.START_UP_COMPLETE:
				{
					hidePreloader();
					break;
				}
			}
		}
		
		
		
		private function hidePreloader():void
		{
			(viewComponent as DisplayObjectContainer).removeChild( _view );
			
			this.facade.removeMediator(NAME);
		}
	}
}