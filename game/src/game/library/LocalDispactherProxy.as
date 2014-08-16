package game.library
{
	import flash.utils.Dictionary;

	public class LocalDispactherProxy extends BaseProxy implements ILocalDispactherProxy
	{
		private const _listeners:			Dictionary = new Dictionary();
		
		public function LocalDispactherProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		public function addLocalListener(event:uint, listener:Function):void
		{
			if( !_listeners[event] ) _listeners[event] = new Vector.<Function>;
			
			var list:Vector.<Function> = _listeners[event];
			var i:int;
			
			for(i = 0; i < list.length; i++)
			{
				if(list[i] == listener) return;
			}
			
			list.push( listener );
		}
		
		public function removeLocalListener(event:uint, listener:Function):void
		{
			if( !_listeners[event] ) return;
			
			var list:Vector.<Function> = _listeners[event];
			var i:int;
			
			for(i = 0; i < list.length; i++)
			{
				if(list[i] == listener)
				{
					list.splice(i, 1);
					break;
				}
			}
		}
		
		public function dispactherLocalEvent(event:uint, data:* = null):void
		{
			if( !_listeners[event] || _listeners[event].length == 0) return;
			
			var list:Vector.<Function> = _listeners[event];
			var i:int;
			var lEvent:LocalEvent = new LocalEvent(event, proxyName, data);
			
			for(i = 0; i < list.length; i++)
			{
				list[i](lEvent);
			}
		}
		
		public function destroy():void
		{
			var par:String;
			var i:int;
			
			for(par in _listeners)
			{
				_listeners[par].length = 0;
				delete _listeners[par];
			}
		}
	}
}