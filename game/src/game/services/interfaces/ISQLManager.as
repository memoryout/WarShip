package game.services.interfaces
{
	import game.services.sql.SQLRequest;

	public interface ISQLManager
	{
		function connect(url:String):void;
		function executeRequest(request:SQLRequest):void;
		function closeConnection():void;
	}
}