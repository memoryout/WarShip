package game.activity.view.application
{
	import game.GameType;
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	
	import org.puremvc.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator
	{
		private var _appView:				ApplicationView;
		
		private var _appProxy:				IMainApplicationProxy;
		
		public function ApplicationMediator(viewComponent:ApplicationView)
		{
			super();
			
			_appView = viewComponent;
			
			_appProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			
			
		}
		
		
		
		public function startGameVSComputer():void
		{
			_appProxy.createGame( GameType.P_VS_C );
		}
		
		
		public function startGameVSRandomPlayer():void
		{
			_appProxy.createGame( GameType.P_VS_P_NET );
		}
		
		
		public function startGameVSFacebookFriend():void
		{
			_appProxy.createGame( GameType.P_VS_P_NET );
		}
	}
}