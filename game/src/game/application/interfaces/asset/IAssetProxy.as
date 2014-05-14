package game.application.interfaces.asset
{
	import flash.display.LoaderInfo;

	public interface IAssetProxy
	{
		function isAssetExist():Boolean;
		function loadSource(url:String):LoaderInfo
		function getClass(className:String):Class;
	}
}