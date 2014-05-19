package game.activity.view.preloader
{
	import flash.display.Sprite;
	
	import game.activity.BaseMediator;
	
	public class PreloaderView extends Sprite
	{
		public function PreloaderView()
		{
			super();
			
			createSkin();
		}
		
		
		private function createSkin():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewLoaderWindow");
			if(classInstance)
			{
				this.addChild( new classInstance() );
			}
		}
		
		
		public function show():void
		{
			
		}
		
		
		public function hide():void
		{
			
		}
	}
}