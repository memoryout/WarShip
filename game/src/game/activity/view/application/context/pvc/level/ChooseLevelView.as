package game.activity.view.application.context.pvc.level
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.activity.BaseMediator;
	
	public class ChooseLevelView extends Sprite
	{
		public static const CHOOSE:		String = "choose";
		public static const BACK:		String = "back";
		
		private var _skin:				MovieClip;
		
		public var  selectedLevel:		int;
		
		public function ChooseLevelView()
		{
			super();
		}
		
		public function init():void
		{
			var classRef:Class = BaseMediator.getSourceClass("viewWindowChooseLevel");
			
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
				
				(_skin.getChildByName("btlevel_1") as SimpleButton).addEventListener(MouseEvent.CLICK, handlerClickButton);
				(_skin.getChildByName("btlevel_2") as SimpleButton).addEventListener(MouseEvent.CLICK, handlerClickButton);
				(_skin.getChildByName("btlevel_3") as SimpleButton).addEventListener(MouseEvent.CLICK, handlerClickButton);
				
				(_skin.getChildByName("back_btn") as MovieClip).addEventListener(MouseEvent.CLICK, clickBack);				
				
			}
		}
		
		private function handlerClickButton(e:MouseEvent):void
		{
			var n:String = e.target.name;
			
			var path:Array = n.split("_");
			
			if(path.length == 2)
			{
				(_skin.getChildByName("btlevel_1") as SimpleButton).removeEventListener(MouseEvent.CLICK, handlerClickButton);
				(_skin.getChildByName("btlevel_2") as SimpleButton).removeEventListener(MouseEvent.CLICK, handlerClickButton);
				(_skin.getChildByName("btlevel_3") as SimpleButton).removeEventListener(MouseEvent.CLICK, handlerClickButton);
				
				selectedLevel = int( path[1] );
				this.dispatchEvent( new Event(CHOOSE) );
			}
		}
		
		private function clickBack(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(BACK));
		}
	}
}