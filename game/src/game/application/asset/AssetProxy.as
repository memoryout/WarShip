package game.application.asset
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import game.application.interfaces.asset.IAssetProxy;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AssetProxy extends Proxy implements IAssetProxy
	{
		private var _assetExist:			Boolean;
		
		private var _assetDomain:			ApplicationDomain;
		
		public function AssetProxy(proxyName:String)
		{
			super(proxyName);
			
			_assetExist = false;
		}
		
		
		public function loadSource(url:String):LoaderInfo
		{
			if(_assetDomain) return null;
			
			_assetDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadFile);
			loader.contentLoaderInfo.addEventListener(Event.INIT, handlerAssetInit);
			loader.load( new URLRequest(url), new LoaderContext(false, _assetDomain) );
			
			return loader.contentLoaderInfo;
		}
		
		public function isAssetExist():Boolean
		{
			return _assetExist;
		}
		
		public function getClass(className:String):Class
		{
			if(_assetDomain && _assetDomain.hasDefinition(className)) return _assetDomain.getDefinition(className) as Class;
			return null;
		}
		
		
		
		
		
		
		private function handlerAssetInit(e:Event):void
		{
			_assetExist = true;
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadFile);
			e.currentTarget.removeEventListener(Event.INIT, handlerAssetInit);
		}
		
		private function handlerErrorLoadFile(e:IOErrorEvent):void
		{
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadFile);
			e.currentTarget.removeEventListener(Event.INIT, handlerAssetInit);
		}
	}
}