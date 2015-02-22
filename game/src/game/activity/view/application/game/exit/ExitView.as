package game.activity.view.application.game.exit
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.activity.BaseMediator;

	public class ExitView extends Sprite
	{
		public static const MENU:		String = "menu";
		private var mainContainer:DisplayObjectContainer;
		public var isShowed:Boolean;
		private var viewLink:MovieClip;
		
		public function ExitView(viewComponent:Object)
		{			
			mainContainer = viewComponent as DisplayObjectContainer;
		}
		
		public function shopPopUp():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewExitPopUp");
			
			viewLink = new classInstance();
			mainContainer.addChild( viewLink );	
			
			viewLink.addEventListener(MouseEvent.CLICK, handlerMouseClick);
			
			isShowed = true;
		}
		
		public function hidePopUp():void
		{
			isShowed = false;
			
			mainContainer.removeChild(viewLink);	
		}
		
		private function handlerMouseClick(e:MouseEvent):void
		{
			var name:String = e.target.name;
			
			switch(name)
			{
				case "menuBtn":
				{
					hidePopUp();
					this.dispatchEvent( new Event(MENU) );					
					break;
				}
					
				case "resumeBtn":
				{				
					hidePopUp();
					break;
				}
			}
		}
	}
}