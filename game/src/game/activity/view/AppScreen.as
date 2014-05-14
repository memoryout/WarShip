package game.activity.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.activity.ViewGlobalVariables;
	import game.activity.view.application.ApplicationView;
	import game.activity.view.preloader.PreloaderView;
	
	public class AppScreen extends Sprite
	{
		private var _canvas:			Sprite;
		
		private var _preloaderLayer:	Sprite;
		private var _appViewLayer:		Sprite;
		
		public function AppScreen()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
		}
		
		
		public function getPreloaderLayer():Sprite
		{
			return _preloaderLayer;
		}
		
		
		public function getAppViewLayer():Sprite
		{
			return _appViewLayer;
		}
		
		
		private function handlerAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
			
			_canvas = new Sprite();
			super.addChild( _canvas );
			
			rescaleCanvas();
			
			initViewLayers();
		}
		
		
		private function initViewLayers():void
		{
			_preloaderLayer = new Sprite();
			_canvas.addChild( _preloaderLayer );
			
			_appViewLayer = new Sprite();
			_canvas.addChild( _appViewLayer );
		}
		
		private function rescaleCanvas():void
		{
			var screeWidth:Number = Math.max(this.stage.fullScreenWidth, this.stage.fullScreenHeight);
			var screenHeight:Number = Math.min(this.stage.fullScreenWidth, this.stage.fullScreenHeight);
			
			var scaleKoef:Number = screeWidth / ViewGlobalVariables.SOURCE_WIDTH;
			
			var newSize:Number;
			
			newSize = ViewGlobalVariables.SOURCE_HEIGHT * scaleKoef;
			
			if(newSize > screenHeight) scaleKoef = screenHeight / ViewGlobalVariables.SOURCE_HEIGHT;
			
			_canvas.scaleX = _canvas.scaleY = scaleKoef;
			
			_canvas.x = (screeWidth - ViewGlobalVariables.SOURCE_WIDTH * scaleKoef) >> 1;
			_canvas.y = (screenHeight - ViewGlobalVariables.SOURCE_HEIGHT * scaleKoef) >> 1;
		}
	}
}