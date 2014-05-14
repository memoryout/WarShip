package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import game.ApplicationFacade;
	
	[SWF(frameRate="60")]
	public class WarShip extends Sprite
	{
		public function WarShip()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.addEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
		}
		
		
		private function handlerAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
			
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handlerApplicationDeactivate);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, handlerApplicationExit);
			
			ApplicationFacade.getInstance().startup( this.stage );
		}
		
		
		private function handlerApplicationDeactivate(e:Event):void
		{
			trace("handlerApplicationDeactivate");
			//ApplicationFacade.getInstance().applicationClosed();
			
		}
		
		
		private function handlerApplicationExit(e:Event):void
		{
			trace("handlerApplicationExit")
			ApplicationFacade.getInstance().applicationClosed();
		}
	}
}