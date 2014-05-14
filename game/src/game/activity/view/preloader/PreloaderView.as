package game.activity.view.preloader
{
	import flash.display.Sprite;
	
	public class PreloaderView extends Sprite
	{
		private var _mediator:			PreloaderMediator;
		
		public function PreloaderView()
		{
			super();
			
			_mediator = new PreloaderMediator(this);
		}
		
		
		public function show():void
		{
			
		}
		
		
		public function hide():void
		{
			
		}
	}
}