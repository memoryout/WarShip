package game.activity.view.application
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class LayoutManager extends Sprite
	{
		private const _activityList:	Vector.<ActivityLayoutMediator> = new Vector.<ActivityLayoutMediator>;
			
		public function LayoutManager()
		{
			
		}
		
		
		public function createActivitiLayout(activityClass:Class, activityName:String = null):void
		{
			var activityInstance:ActivityLayoutMediator = new activityClass(activityName, this) as ActivityLayoutMediator;
			
			if( _activityList.length > 0 )
			{
				var currentActivity:ActivityLayoutMediator = _activityList[_activityList.length - 1];
				
				currentActivity.pauseActivity();
			}
			
			_activityList.push( activityInstance );	
		}
		
		public function closeActivity():void
		{
			var currentActivity:ActivityLayoutMediator
			
			if( _activityList.length > 0 )
			{
				currentActivity = _activityList[_activityList.length - 1];
				
				currentActivity.stopActivity();
				_activityList.pop();
			}
			
			if( _activityList.length > 0 )
			{
				currentActivity = _activityList[_activityList.length - 1];
				currentActivity.resumeActivity();
			}
		}
	}
}