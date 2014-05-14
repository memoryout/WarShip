package game.services.interfaces
{
	import flash.events.IEventDispatcher;
	
	import game.services.device.DeviceInfo;

	public interface IDeviceManager extends IEventDispatcher
	{
		function get deviceInfo():DeviceInfo;
		function retrieveDeviceInfo():void;
	}
}