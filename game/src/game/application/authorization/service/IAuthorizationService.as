package game.application.authorization.service
{
	import game.application.authorization.AuthorizationInfo;
	import game.application.interfaces.net.IServerConnectionProxy;
	
	import org.puremvc.as3.interfaces.IProxy;

	public interface IAuthorizationService extends IProxy
	{
		function initialize():void;
		function getAuthorizationState():AuthorizationInfo;
	}
}