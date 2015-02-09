package game.services.interfaces
{
	import flash.display.LoaderInfo;
	
	import game.services.asset.MultiLoader;

	public interface IAssetManager
	{
		function isAssetExist():Boolean;
		function loadSource(url:String):LoaderInfo
		function getClass(className:String):Class;
		function getMultiloader():MultiLoader;
	}
}