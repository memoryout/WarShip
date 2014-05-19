package game.services.net
{
	import flash.events.Event;

	public class ServerConnectionEvent extends Event
	{
		public static const CONNECTION_INIT:			String = "connectionInitComplete";
		public static const CONNECTION_ERROR:			String = "connectionInitError";
		public static const REQUEST_COMPLETE:			String = "requestComplete";
		public static const REQUEST_ERROR:				String = "requestError";
		
		private var _data:			Object;
		
		public function ServerConnectionEvent(type:String, data:Object = null):void
		{
			super(type);
			_data = data;
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}