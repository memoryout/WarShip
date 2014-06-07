package game.application.interfaces.game
{
	import game.application.data.game.ShipData;
	import game.application.server.ServerResponce;
	
	import org.puremvc.as3.interfaces.IProxy;

	public interface IGameProxy extends IProxy
	{
		function getShipsList():Vector.<ShipData>;
		function receiveServerResponce(request:ServerResponce):void;
	}
}