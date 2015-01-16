package game.application.data
{
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	
	import game.services.interfaces.IDeviceManager;

	public class StartupInfo extends EventDispatcher
	{
		private var _loaderInfo:		LoaderInfo;
		private var _device:			IDeviceManager;
		
		public function StartupInfo()
		{
			
		}
		
		public function setLoaderInfo(loaderInfo:LoaderInfo):void
		{
			_loaderInfo = loaderInfo;
		}
		
		public function getLoaderInfo():LoaderInfo
		{
			return _loaderInfo;
		}
		
		
		public function setDeviceManager(device:IDeviceManager):void
		{
			_device = device;
		}
		
		public function getDeviceManager():IDeviceManager
		{
			return _device;
		}
	}
}