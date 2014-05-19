package game.activity.view.application
{
	import flash.display.Sprite;
	
	import game.activity.view.application.game.GameView;
	
	public class ApplicationView extends Sprite
	{
		private var _gameViewLayer:			Sprite;
		private var _menuLayer:				Sprite;
		private var _windowsLayer:			Sprite;
		
		public function ApplicationView()
		{
			super();
			
			createViewLayers();
		}
		
		
		private function createViewLayers():void
		{
			_gameViewLayer = new Sprite();
			this.addChild( _gameViewLayer );
			
			_menuLayer = new Sprite();
			this.addChild( _menuLayer );
			
			_windowsLayer = new Sprite();
			this.addChild( _windowsLayer );
		}
		
		
		public function getGameLayer():Sprite
		{
			return _gameViewLayer;
		}
		
		public function getMenuLayer():Sprite
		{
			return _menuLayer;
		}
		
		public function getWindowsLayer():Sprite
		{
			return _windowsLayer;
		}
	}
}