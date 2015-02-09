package game.services.asset
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="progress ", type="flash.events.ProgressEvent")]
	public class MultiLoader extends EventDispatcher
	{
		private var _filesQueue:		Vector.<String>;
		private var _domain:			ApplicationDomain;
		
		private var _filesNumber:		uint;
		private var _filesLoaded:		uint;
		private var _fileProgressRange:	Number;
		
		private var _percent:			Number;
		
		public function MultiLoader(domain:ApplicationDomain)
		{
			super();
			
			_domain = domain;
			_filesQueue = new Vector.<String>();
		}
		
		public function pushFile(url:String):void
		{
			_filesQueue.push(url);
		}
		
		
		public function load():void
		{
			_filesNumber = _filesQueue.length;
			_filesLoaded = 0;
			_fileProgressRange = 1/_filesNumber;
			
			loadNextFile();
		}
		
		private function loadNextFile():void
		{
			if(_filesQueue.length > 0)
			{
				var url:String = _filesQueue.shift();
				
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.INIT, handlerFileLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadFile);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handlerProgressLoadFile);
				loader.load(new URLRequest(url), new LoaderContext(false, _domain));
			}
			else
			{
				this.dispatchEvent( new Event(Event.COMPLETE) );
			}
		}

		
		private function handlerFileLoadComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.INIT, handlerFileLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadFile);
			
			_filesLoaded ++;
			
			loadNextFile();
		}
		
		private function handlerErrorLoadFile(e:IOErrorEvent):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.INIT, handlerFileLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadFile);
			
			loadNextFile();
		}
		
		private function handlerProgressLoadFile(e:ProgressEvent):void
		{
			var value:Number = e.bytesLoaded/e.bytesTotal;
			
			_percent = _filesLoaded * _fileProgressRange + value * _fileProgressRange;
			this.dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS, false, true, _percent, 1 ) );
		}
	}
}