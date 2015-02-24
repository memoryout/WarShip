package game.application.authorization
{
	import flash.events.Event;

	public class AuthorizationEvent extends Event
	{
		public static const FAILED:			String = "authFailed";
		
		public function AuthorizationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
	}
}