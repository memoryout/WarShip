package game.application.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class DataRequest extends EventDispatcher
	{
		public function DataRequest(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function start():void
		{
			
		}
		
		protected function dispatchComplete():void
		{
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
	}
}