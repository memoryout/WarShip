package game.activity.view.application.game.exit
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.activity.BaseMediator;
	import game.application.data.DataProvider;

	public class ExitView extends Sprite
	{
		private const SHOW_TIME:Number = 0.3;
		
		public static const MENU		:String = "menu";
		private var mainContainer		:DisplayObjectContainer;
		public  var isShowed			:Boolean;
		private var viewLink			:MovieClip;
		
		private var tween				:TweenLite;
		
		public function ExitView(viewComponent:Object)
		{			
			mainContainer = viewComponent as DisplayObjectContainer;
		}
		
		public function shopPopUp():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewExitPopUp");
			
			viewLink = new classInstance();
			mainContainer.addChild( viewLink );	
			viewLink.alpha = 0;
			
			viewLink.addEventListener(MouseEvent.CLICK, handlerMouseClick);
			
			isShowed = true;
			
			tween = TweenLite.to(viewLink, SHOW_TIME, {alpha:1});			
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