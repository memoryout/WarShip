package game.application.interfaces.game
{
	import game.application.data.game.ShipData;
	
	import org.puremvc.as3.interfaces.IProxy;

	public interface IGameProxy extends IProxy
	{
		function getShipsList():Vector.<ShipData>;
		function processActionsQueue():void;
		function hitPoint(x:uint, y:uint):void;
	}
}