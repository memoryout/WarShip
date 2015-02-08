package game.application.authorization
{
	import flash.system.Capabilities;
	
	import game.application.ProxyList;
	import game.library.BaseProxy;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class UserAuthorizationProxy extends BaseProxy
	{
		private const _authorizationInfo:		AuthorizationInfo = new AuthorizationInfo();
		
		public function UserAuthorizationProxy()
		{
			super(ProxyList.AUTHORIZATION_PROXY);
		}
		
		override public function onRegister():void
		{
			initializeAuthorization();
		}
		
		private function initializeAuthorization():void
		{
			defineTargetPlatform();
		}
		
		private function defineTargetPlatform():void
		{
			var os:String = Capabilities.version.toLowerCase();
			
			
			trace(os);
			trace(Capabilities.os);
			trace(Capabilities.manufacturer);
		}
	}
}