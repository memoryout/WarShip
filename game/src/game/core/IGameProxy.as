package game.core
{
	import org.puremvc.as3.interfaces.INotifier;
	import org.puremvc.as3.interfaces.IProxy;

	public interface IGameProxy extends IProxy, INotifier
	{
		function connect(connectionData:Object = null):void;
	}
}