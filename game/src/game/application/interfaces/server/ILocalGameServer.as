package game.application.interfaces.server
{
	import game.application.data.game.ShipData;

	public interface ILocalGameServer
	{
		function sendHitPointPosition(x:uint, y:uint, userId:String):void;
		
		function sendUserShipLocation( ships:Array, userId:String ):void;
		function initGame():void;
		function registerPlayer(id:String):void
		function startGame():void
	}
}