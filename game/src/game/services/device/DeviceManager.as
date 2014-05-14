package game.services.device
{
	import com.freshplanet.ane.AirDeviceId;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import game.services.IService;
	import game.services.ServicesList;
	import game.services.interfaces.IDeviceManager;
	
	public class DeviceManager extends EventDispatcher implements IService, IDeviceManager
	{
		private static const DEVICE_ID_SALT:		String = "123456789";
		
		private var _device:				AirDeviceId;
		
		private var _deviceInfo:			DeviceInfo;
		
		public function DeviceManager()
		{
			super();
		}
		
		public static function init():void
		{
			ServicesList.addSearvice( new DeviceManager() );
		}
		
		public function get serviceName():String
		{
			return ServicesList.DEVICE_MANAGER;
		}
		
		
		public function get deviceInfo():DeviceInfo
		{
			return _deviceInfo;
		}
		
		
		public function retrieveDeviceInfo():void
		{
			_deviceInfo = new DeviceInfo();
			
			_device = AirDeviceId.getInstance();
			_deviceInfo.deviceId = _device.getDeviceId(DEVICE_ID_SALT);
			
			if(_device.isOnAndroid) _deviceInfo.os = DeviceOSList.ANDROID;
			else if(_device.isOnIOS) _deviceInfo.os = DeviceOSList.IOS;
			else if(_device.isOnDevice) _deviceInfo.os = DeviceOSList.UNKNOWN;
			
			this.dispatchEvent( new Event(DeviceManagerEvents.DEVICE_ID_RECEIVE) );
		}
	}
}