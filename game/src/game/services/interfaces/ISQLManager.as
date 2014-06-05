package game.services.interfaces
{
	import game.services.sqllite.SQLRequest;

	public interface ISQLManager
	{
		function connect(url:String, onConnect:Function, onError:Function):void;
		function executeRequest(request:SQLRequest):void;
		function closeConnection():void;
	}
}