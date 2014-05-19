package game.activity.view.application.menu.pages.game_type
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import game.activity.BaseMediator;
	
	public class SelectGameTypeView extends Sprite
	{
		private var _skin:				MovieClip;
		
		public function SelectGameTypeView()
		{
			super();
			
			createViewSkin();
		}
		
		
		private function createViewSkin():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewActiveGame");
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
			}
		}
	}
}