package game.activity.view.application
{
	import flash.display.DisplayObjectContainer;
	
	import game.activity.BaseMediator;
	
	public class ActivityLayoutMediator extends BaseMediator
	{
		private var _rootLayout:			LayoutManager;
		
		public function ActivityLayoutMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
			
			_rootLayout = viewComponent as LayoutManager;
			
			this.facade.registerMediator( this );
		}
		
		override public function getMediatorName():String
		{
			return this.mediatorName;
		}
		
		public function createActivity(activityClass:Class, name:String = null):void
		{
			_rootLayout.createActivitiLayout(activityClass, name);
		}
		
		public function createFragment(fragmentClass:Class, name:String, layout:DisplayObjectContainer):void
		{
			this.facade.registerMediator( new fragmentClass(name, layout, this) );
		}
		
		public function onCreate():void
		{
			
		}
		
		
		public function onStop():void
		{
			
		}
		
		public function onPause():void
		{
			
		}
		
		public function onCloseFragment():void
		{
			
		}
		
		
		
		public function onResume():void
		{
			this.facade.registerMediator( this );
		}
		
		public function pauseActivity():void
		{
//			this.facade.removeMediator( getMediatorName() );
			this.onPause();
		}
		
		public function stopActivity():void
		{
			this.facade.removeMediator( getMediatorName() );
			this.onStop();
		}
		
		public function resumeActivity():void
		{
			
		}
	}
}