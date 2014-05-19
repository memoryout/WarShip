package game.activity.view.application.windows
{
	import flash.display.Sprite;
	
	public class WindowsView extends Sprite
	{
		private var _alertsWindowsLayer:			Sprite;
		
		public function WindowsView()
		{
			super();
			
			
			createViewLayers();
		}
		
		
		public function getAlertsLayers():Sprite
		{
			return _alertsWindowsLayer;
		}
		
		
		private function createViewLayers():void
		{
			_alertsWindowsLayer = new Sprite();
			this.addChild( _alertsWindowsLayer );
		}
		
	}
}