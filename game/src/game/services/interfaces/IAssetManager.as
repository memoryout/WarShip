package game.services.interfaces
{
	import flash.display.LoaderInfo;

	public interface IAssetManager
	{
		function isAssetExist():Boolean;
		function loadSource(url:String):LoaderInfo
		function getClass(className:String):Class;
	}
}