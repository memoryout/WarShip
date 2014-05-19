package game.services.net.http
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class HTTPRequest
	{
		private static const MAX_ATTEMPT:		uint = 10;
		
		private var _url:		String;
		private var _data:		Object;
		private var _vars:		URLVariables;
		
		private var _onComplete:Function;
		private var _onError:	Function;
		
		private var _loader:	URLLoader;
		private var _repeatCount:uint;
		
		
		public function HTTPRequest()
		{
			_repeatCount = 0;
		}
		
		public function load(url:String, data:Object, onComplete:Function, onError:Function):void
		{
			_url = url;
			_data = data;
			
			_vars = new URLVariables();
			var par:String;
			for(par in _data) _vars[par] = _data[par];
			
			_onComplete = onComplete;
			_onError = onError;
			
			sendRequest();
		}
		
		
		private function sendRequest():void
		{
			if(_loader)
			{
				_loader.removeEventListener(Event.COMPLETE, handlerComplete);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, handlerError);
			}
			
			trace("sendRequest");
			
			var req:URLRequest = new URLRequest(_url);
			req.data = _vars;
			req.data["rnd"] = Math.random();
			req.method = URLRequestMethod.GET;
			
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handlerComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, handlerError);
			_loader.load( req );
		}
		
		
		private function handlerComplete(e:Event):void
		{
			if(_onComplete != null) _onComplete(_loader.data);
		}
		
		private function handlerError(e:IOErrorEvent):void
		{
			_repeatCount ++;
			if(_repeatCount < MAX_ATTEMPT) sendRequest();
			else
			{
				if(_onError != null) _onError();
			}
		}
	}
}