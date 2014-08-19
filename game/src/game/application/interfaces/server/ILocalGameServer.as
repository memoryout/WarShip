package game.application.interfaces.server
{
	import game.application.data.game.ShipData;
	import game.library.ILocalDispactherProxy;

	public interface ILocalGameServer extends ILocalDispactherProxy
	{
		function sendHitPointPosition(x:uint, y:uint, userId:String):void;
		
		function sendUserShipLocation( ships:Array, userId:String ):void;
		function initGame():void;
		function registerPlayer(id:String):void
		function startGame():void
	}
}