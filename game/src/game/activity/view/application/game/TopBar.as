package game.activity.view.application.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.activity.BaseMediator;
	import game.application.data.DataProvider;

	public class TopBar extends Sprite
	{
		public static const OPONENT_STATE:	String = "oponent_state";
		public static const USER_STATE:		String = "user_state";
		
		public static const USER_TYPE:		String = "user";
		public static const OPONENT_TYPE:	String = "opponent";
		
		public static const OPONENT_PROGRESS_LINE:	String = "oponent_progress_line";
		public static const USER_PROGRESS_LINE:		String = "user_progress_line";
	
		private var linkToTopBar:MovieClip;
		
		public function TopBar()
		{
			addElement();
			setUser();
		}
		
		private function addElement():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("TopBar");
			
			if(classInstance)
			{
				linkToTopBar = new classInstance();	
				addChild(linkToTopBar);
			}
			
			linkToTopBar.addEventListener(MouseEvent.CLICK, handlerMouseClick);
		}
		
		private function setUser():void
		{				
			(linkToTopBar.topBar.getChildByName("userName") as TextField).text = DataProvider.getInstance().getUserDataProvider().getUserInfo().name;
			
			(linkToTopBar.topBar.getChildByName("logo_right_side") as MovieClip).visible 		= false;
			(linkToTopBar.topBar.getChildByName("oponent_progress_line") as MovieClip).visible 	= false;
			(linkToTopBar.topBar.getChildByName("opponentAvatar") as MovieClip).visible 		= false;
		}
		
		public function setOpponent():void
		{
			(linkToTopBar.topBar.getChildByName("oponentName") as TextField).text = DataProvider.getInstance().getGameDataProvider().opponent.name;
			
			(linkToTopBar.topBar.getChildByName("logo_right_side") as MovieClip).visible 		= true;
			(linkToTopBar.topBar.getChildByName("oponent_progress_line") as MovieClip).visible 	= true;
			(linkToTopBar.topBar.getChildByName("opponentAvatar") as MovieClip).visible 		= true;
		}
		
		public function setProgress(type:String, val:Object):void
		{
			var progressLine:MovieClip;
		
			if(type == USER_TYPE)			
				progressLine = (linkToTopBar.getChildByName("topBar") as MovieClip).getChildByName(OPONENT_PROGRESS_LINE) as MovieClip;
				
			else if(type == OPONENT_TYPE)			
				progressLine = (linkToTopBar.getChildByName("topBar") as MovieClip).getChildByName(USER_PROGRESS_LINE) as MovieClip;
			
			trace("type: ", type, "val: ", val);
			
			progressLine.gotoAndStop(val+1);			
		}
		
		public function destroy():void
		{
			while(numChildren > 0)
				removeChildAt(0);
			
			linkToTopBar = null;
		}
		
		private function handlerMouseClick(e:MouseEvent):void
		{
			var name:String = e.target.name;
			
			switch(name)
			{
				case "userProgressZone":
				{
					this.dispatchEvent( new Event(USER_STATE, true) );				
					break;
				}
					
				case "oponnentProgressZone":
				{
					this.dispatchEvent( new Event(OPONENT_STATE, true) );
					break;
				}
			}
		}
	}
}