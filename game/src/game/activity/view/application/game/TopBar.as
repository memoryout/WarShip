package game.activity.view.application.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import game.activity.BaseMediator;

	public class TopBar extends Sprite
	{
		public static const USER_TYPE:		String = "user";
		public static const OPONENT_TYPE:	String = "opponent";
		
		public static const OPONENT_PROGRESS_LINE:	String = "oponent_progress_line";
		public static const USER_PROGRESS_LINE:		String = "user_progress_line";
	
		private var linkToTopBar:MovieClip;
		
		public function TopBar()
		{
			addElement();
		}
		
		private function addElement():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("TopBar");
			
			if(classInstance)
			{
				linkToTopBar = new classInstance();	
				addChild(linkToTopBar);
			}
		}
		
		public function setProgress(type:String, val:Object):void
		{
			var progressLine:MovieClip;
		
			if(type == USER_TYPE)			
				progressLine = linkToTopBar.getChildByName(OPONENT_PROGRESS_LINE) as MovieClip;
				
			else if(type == OPONENT_TYPE)			
				progressLine = linkToTopBar.getChildByName(USER_PROGRESS_LINE) as MovieClip;
			
			
			progressLine.gotoAndStop(val+1);			
		}
	}
}