package game.activity.view.application.menu.pages.profiler
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.activity.BaseMediator;

	public class ProfilerView extends Sprite
	{
		private var _skin:				MovieClip;
		
		public function ProfilerView()
		{
			createViewSkin();
		}
		
		private function createViewSkin():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewProfile");
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
				
				_skin.addEventListener(MouseEvent.CLICK, handlerMouseClick);
			}
		}
		
		public function close():void
		{
			if(_skin) _skin.removeEventListener(MouseEvent.CLICK, handlerMouseClick);
			if(this.parent) this.parent.removeChild( this );
			
			_skin = null;
		}
		
		private function handlerMouseClick(e:MouseEvent):void
		{
			
		}
	}
}