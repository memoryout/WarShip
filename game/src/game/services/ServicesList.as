package game.services
{
	import flash.utils.Dictionary;

	public class ServicesList
	{
		public static const SQL_MANAGER:		String = "sql_manager";
		public static const DEVICE_MANAGER:		String = "device_manager";
		
		
		private static const _serviceList:		Dictionary = new Dictionary()
		
		public static function addSearvice(service:IService ):void
		{
			if( !_serviceList[service.serviceName] ) _serviceList[service.serviceName] = service;
		}
		
		
		public static function getSearvice(name:String):IService
		{
			return _serviceList[name];
		}
	}
}