package game.activity.view.application.menu
{
	import flash.display.Sprite;
	
	public class MenuView extends Sprite
	{
		private var _menuPagesLayer:			Sprite;
		
		public function MenuView()
		{
			super();
			
			createViewLayers();
		}
		
		private function createViewLayers():void
		{
			_menuPagesLayer = new Sprite();
			this.addChild( _menuPagesLayer );
		}
		
		
		public function getMenuPageLayer():Sprite
		{
			return _menuPagesLayer;
		}
	}
}