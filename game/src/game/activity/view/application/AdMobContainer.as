package game.activity.view.application
{
	import com.milkmangames.nativeextensions.AdMob;
	import com.milkmangames.nativeextensions.events.AdMobErrorEvent;
	import com.milkmangames.nativeextensions.events.AdMobEvent;

	public class AdMobContainer
	{
		public function AdMobContainer()
		{
			addAdMob();
		}
		
		private function addAdMob():void
		{			
			if(AdMob.isSupported){
				AdMob.init("ca-app-pub-8376756760215386/4607981759");
			}
			else
			{
				trace("AdMob won't work on this platform!");
				return;
			}
			
			AdMob.loadInterstitial("ca-app-pub-8376756760215386/4607981759", true);			
			
			AdMob.enableTestDeviceIDs(AdMob.getCurrentTestDeviceIDs());
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
	}
}