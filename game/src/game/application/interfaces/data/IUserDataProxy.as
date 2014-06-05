package game.application.interfaces.data
{
	import game.application.data.user.UserData;

	public interface IUserDataProxy
	{
		function connect():void;
		function getUserData():UserData;
		function getUsersList():Vector.<UserData>;
		function selectCurrentUser(id:uint):void;
		function commitChanges():void;
		function retrieveUsersList():void;
		function createNewUser(name:String):void;
	}
}