package game.activity.view
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import game.activity.ViewGlobalVariables;
	import game.activity.view.application.ApplicationView;
	import game.activity.view.preloader.PreloaderView;
	
	public class AppScreen extends Sprite
	{
		private var _canvas:			Sprite;
		
		private var _preloaderLayer:	Sprite;
		private var _appViewLayer:		Sprite;
		private var _logLayer:			Sprite;
		
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
		
		
		public function getLogLayer():Sprite
		{
			if(!_logLayer)
			{
				_logLayer = new Sprite();
				_canvas.addChild( _logLayer );
				_logLayer.mouseChildren = false;
				_logLayer.mouseEnabled = false;
			}
			
			return _logLayer;
		}
		
		
		private function handlerAddedToStage(e:Event):void
		{		
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
			
			_canvas = new Sprite();
			super.addChild( _canvas );
			
			initViewLayers();
			
			rescaleCanvas();			
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
			/*var screeWidth:Number = Math.max(this.stage.fullScreenWidth, this.stage.fullScreenHeight);
			var screenHeight:Number = Math.min(this.stage.fullScreenWidth, this.stage.fullScreenHeight);
			
			var scaleKoef:Number = screeWidth / ViewGlobalVariables.SOURCE_WIDTH;
			
			var newSize:Number;
			
			newSize = ViewGlobalVariables.SOURCE_HEIGHT * scaleKoef;
			
			if(newSize > screenHeight) scaleKoef = screenHeight / ViewGlobalVariables.SOURCE_HEIGHT;
			
			_canvas.scaleX = _canvas.scaleY = scaleKoef;*/
			
//			_canvas.x = (screeWidth - ViewGlobalVariables.SOURCE_WIDTH * scaleKoef) >> 1;
//			_canvas.y = (screenHeight - ViewGlobalVariables.SOURCE_HEIGHT * scaleKoef) >> 1;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var serverString:String = unescape(Capabilities.serverString); 
			var reportedDpi:Number = Number(serverString.split("&DP=", 2)[1]);		
			
			
			var guiSize:Rectangle = new Rectangle(0, 0, 1280, 720); 
			var deviceSize:Rectangle = new Rectangle(0, 0, Math.max(stage.fullScreenWidth, stage.fullScreenHeight), Math.min(stage.fullScreenWidth, stage.fullScreenHeight)); 
			var appScale:Number = 1; 
			var appSize:Rectangle = guiSize.clone(); 
			var appLeftOffset:Number = 0; 
			// if device is wider than GUI's aspect ratio, height determines scale 
			if ((deviceSize.width/deviceSize.height) > (guiSize.width/guiSize.height)) 
			{ 
				appScale = deviceSize.height / guiSize.height; 
				appSize.width = deviceSize.width / appScale; 
				appLeftOffset = Math.round((appSize.width - guiSize.width) / 2); } 
			// if device is taller than GUI's aspect ratio, width determines scale 
			else 
			{ 
				appScale = deviceSize.width / guiSize.width; 
				appSize.height = deviceSize.height / appScale; 
				appLeftOffset = 0; 
			} 
			
			_canvas.scaleX = _canvas.scaleY = appScale;
			
//			 scale the entire interface 
//			_canvas.scale = appScale; 
			// map stays at the top left and fills the whole screen 
//			_canvas.x = 0; 
			// menus are centered horizontally 
			_canvas.x = appLeftOffset; 
			// crop some menus which are designed to run off the sides of the screen 
//			_canvas.scrollRect = appSize;
		}
	}
}