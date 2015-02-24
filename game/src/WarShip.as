package
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.NetworkInfo;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import game.ApplicationFacade;
	
	[SWF(frameRate="30")]
		
	public class WarShip extends Sprite
	{		
		[Embed(source="../logo/roar_games_logo.png")]
		private var splashScreenImage:Class;
		private var splashScreen:Bitmap;
		
		private var appScale		:Number = 1; 
		private var timer:Timer = new Timer(1000, 1);
		
		public function WarShip()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.addEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
		
			defineScale();
			showSplashScreen();			
		}
		
		private function defineScale():void
		{
			var guiSize			:Rectangle = new Rectangle(0, 0, 1280, 720); 
			var deviceSize		:Rectangle = new Rectangle(0, 0, Math.max(stage.fullScreenWidth, stage.fullScreenHeight), Math.min(stage.fullScreenWidth, stage.fullScreenHeight)); 
			
			var appSize			:Rectangle = guiSize.clone(); 
			var appLeftOffset	:Number = 0; 
			
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
		}
		
		private function showSplashScreen():void
		{
//			stage.addEventListener(Event.DEACTIVATE, deactivate);
			splashScreen = new splashScreenImage() as Bitmap;
			addChild( splashScreen );
			
			splashScreen.scaleX = splashScreen.scaleY = appScale;
			splashScreen.smoothing = true;
			
			splashScreen.x = stage.fullScreenWidth/2 - splashScreen.width/2;
			splashScreen.y = stage.fullScreenHeight/2 - splashScreen.height/2;
		}
		
		
		private function handlerAddedToStage(e:Event):void
		{
//			removeChild( splashScreen );
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, startUpApplication);
			timer.start();
			
		}
		
		private function startUpApplication(e:Event):void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, startUpApplication);
			
			timer = null;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
			
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handlerApplicationDeactivate);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handlerApplicationActivate);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, handlerApplicationExit);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handlerKeyDown);
			
			ApplicationFacade.getInstance().startup( this.stage );
		}
		
		private function handlerApplicationDeactivate(e:Event):void
		{
			trace("handlerApplicationDeactivate");
			//ApplicationFacade.getInstance().applicationClosed();
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;						
		}
		
		private function handlerApplicationActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;						
		}
		
		
		private function handlerKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.BACK:
				{
					e.preventDefault();
					ApplicationFacade.getInstance().userPressBack();
					break;
				}
					
				case Keyboard.MENU:
				{
					trace("Keyboard.MENU")
					break;
				}
					
				case Keyboard.SEARCH:
				{
					trace("Keyboard.SEARCH")
					break;
				}
			}
		}
		
		private function handlerApplicationExit(e:Event):void
		{
			trace("handlerApplicationExit")
			ApplicationFacade.getInstance().applicationClosed();
		}
	}
}