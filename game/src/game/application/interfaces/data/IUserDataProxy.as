package game.application.interfaces.data
{
	import game.application.data.user.UserData;

	public interface IUserDataProxy
	{
		function connect():void;
		function getUserData():UserData;
		function commitChanges():void;
	}
}