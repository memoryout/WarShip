package game.activity
{
	import game.services.ServicesList;
	import game.services.interfaces.IAssetManager;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class BaseMediator extends Mediator
	{
		private static const _asset:				IAssetManager = ServicesList.getSearvice(ServicesList.ASSET_MANAGER) as IAssetManager;
		
		public function BaseMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		
		public static function getSourceClass(className:String):Class
		{
			if(_asset) return _asset.getClass(className);
			return null;
		}
	}
}