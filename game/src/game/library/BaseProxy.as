package game.library
{
	import flash.events.EventDispatcher;
	
	import game.application.interfaces.IBaseProxy;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class BaseProxy extends Proxy implements IBaseProxy
	{
		public static const LOG_MESSAGE:			String = "log_message";
		
		
		private const _dispacther:EventDispatcher = new EventDispatcher();
		
		public function BaseProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		
		override public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			CONFIG::TRACE_SEND_NOTIFICATION { trace("sendNotification: " + notificationName); }
			
			super.sendNotification(notificationName, body, type);
		}
		
		
		public function log(value:String):void
		{
			this.sendNotification(LOG_MESSAGE, value);
		}
		
		public function get dispacther():EventDispatcher
		{
			return _dispacther;
		}
	}
}