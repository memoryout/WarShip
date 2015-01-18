package game.application.interfaces.data
{
	import game.application.data.user.UserData;
	import game.library.ILocalDispactherProxy;

	public interface IUserDataProxy extends ILocalDispactherProxy
	{
		function connect():void;
		function getUserData():UserData;
		function getUsersList():Vector.<UserData>;
		function selectCurrentUser(id:uint):void;
		function commitChanges():void;
		function retrieveUsersList():void;
		function createNewUser(name:String, login:String, pass:String):void;
		function deleteUser(id:uint):void;
	}
}