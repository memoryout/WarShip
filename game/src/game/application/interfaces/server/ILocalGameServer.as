package game.application.interfaces.server
{
	import game.application.data.game.ShipData;

	public interface ILocalGameServer
	{
		function sendHitPointPosition(x:uint, y:uint):void;
		
		function sendUserShipLocation( ships:Array ):void;
		function initGame():void;
		function registerPlayer(id:String):void
		function startGame():void
	}
}