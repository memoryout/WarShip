package game.activity.view.application.windows.sign_in
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.activity.BaseMediator;
	
	public class SignInWindow extends Sprite
	{	
		private var _skin:				MovieClip;
		private var _btOk:				SimpleButton;
		private var _txt:				TextField;
		
		public function SignInWindow()
		{
			super();
			
			createViewSkin();
		}
		
		
		private function createViewSkin():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewLoginPage");
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
				
				_btOk = _skin.getChildByName("ok_btn") as SimpleButton;
				if(_btOk) _btOk.addEventListener(MouseEvent.CLICK, handlerClickOk);
				
				_txt = _skin.getChildByName("nameTxt") as TextField;
			}
		}
		
		
		public function getValue():String
		{
			return _txt.text;
		}
		
		
		private function handlerClickOk(e:MouseEvent):void
		{
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
	}
}