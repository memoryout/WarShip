package game.application.authorization
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AuthorizationInfo extends EventDispatcher
	{
		public function AuthorizationInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}