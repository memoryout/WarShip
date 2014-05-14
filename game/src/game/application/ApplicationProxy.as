package game.application
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ApplicationProxy extends Proxy
	{
		
		public function ApplicationProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		
		override public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			CONFIG::TRACE_SEND_NOTIFICATION { trace("sendNotification: " + notificationName); }
			
			super.sendNotification(notificationName, body, type);
		}
	}
}