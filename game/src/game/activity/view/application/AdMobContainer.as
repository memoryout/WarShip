package game.activity.view.application
{
	import com.milkmangames.nativeextensions.AdMob;
	import com.milkmangames.nativeextensions.events.AdMobErrorEvent;
	import com.milkmangames.nativeextensions.events.AdMobEvent;

	public class AdMobContainer
	{
		private var TOP_BANNER_AD	:String = "ca-app-pub-8376756760215386/4607981759";
		private var BANNER_AD		:String = "ca-app-pub-8376756760215386/2096240155";
		
		private static var _this	:AdMobContainer;
		
		public function AdMobContainer()
		{
			
		}
		
		public function addTopBanner():void
		{			
			if(AdMob.isSupported)
				AdMob.init(TOP_BANNER_AD);
			
			else
			{
				trace("AdMob won't work on this platform!");
				return;
			}
			
			AdMob.loadInterstitial(TOP_BANNER_AD, true);			
			
			AdMob.enableTestDeviceIDs(AdMob.getCurrentTestDeviceIDs());
			
			addListeners();			
		}
		
		public function addBanner():void
		{
			if(AdMob.isSupported)
				AdMob.init(BANNER_AD);
			
			else
			{
				trace("AdMob won't work on this platform!");
				return;
			}
			
			
			AdMob.loadInterstitial(BANNER_AD, true);			
			
			AdMob.enableTestDeviceIDs(AdMob.getCurrentTestDeviceIDs());
			
			addListeners();			
		}
		
		private function addListeners():void
		{
			AdMob.addEventListener(AdMobErrorEvent.FAILED_TO_RECEIVE_AD,	onFailedReceiveAd);
			AdMob.addEventListener(AdMobEvent.RECEIVED_AD,					onReceiveAd);
			AdMob.addEventListener(AdMobEvent.SCREEN_PRESENTED,				onScreenPresented);
			AdMob.addEventListener(AdMobEvent.SCREEN_DISMISSED,				onScreenDismissed);
			AdMob.addEventListener(AdMobEvent.LEAVE_APPLICATION,			onLeaveApplication);
		}
		
		/** On Failed Receive Ad */
		private function onFailedReceiveAd(e:AdMobErrorEvent):void
		{
			trace("ERROR receiving ad, reason: '"+e.text+"'");
		}
		
		/** On Receive Ad */
		private function onReceiveAd(e:AdMobEvent):void
		{
			trace("Received ad:"+e.isInterstitial+":"+e.dimensions);
		}
		
		/** On Screen Presented */
		private function onScreenPresented(e:AdMobEvent):void
		{
			trace("Screen Presented.");
		}
		
		
		/** On Screen Dismissed */
		private function onScreenDismissed(e:AdMobEvent):void
		{
			trace("Screen Dismissed.");
		}
		
		/** On Leave Application */
		private function onLeaveApplication(e:AdMobEvent):void
		{
			trace("Leave Application.");
		}
		
		public static function getInstance():AdMobContainer
		{
			if(!_this)
				_this = new AdMobContainer();
			
			return _this;
		}
	}
}