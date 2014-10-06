package game.activity.view.application.windows.authorization_users
{
	import com.facebook.graph.FacebookMobile;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import game.AppGlobalVariables;
	import game.activity.BaseMediator;
	import game.application.data.user.UserData;
	
	public class SelectCurrentUserWindow extends Sprite
	{
		public static const SELECT_USER:		String = "selectUser";
		public static const CREATE_NEW_USER:	String = "createNewUser";
		
		private var _skin:			MovieClip;
		
		private var _btOk:				SimpleButton;
		private var _txt:				TextField;
		
		private var _buttonsCache:	Dictionary;
		
		public var selectedID:		uint;
		public var userName:		String;
		
		private var webView:StageWebView;
		
		private var loginBtn:SimpleButton;
		private var label:String;
		
		public function SelectCurrentUserWindow()
		{
			super();
			
			createViewComponents();
			
			init();		
		}
		
		private function init():void
		{
			loginBtn = _skin.getChildByName("login_btn") as SimpleButton;				
			
			FacebookMobile.init(AppGlobalVariables.APP_ID, onFacebookInit);
			
			loginBtn.addEventListener(MouseEvent.CLICK, handleLoginClick, false, 0, true);
		}
		
		private function onFacebookInit(result:Object, fail:Object):void			
		{			
			if(result)				
			{				
				AppGlobalVariables.accessToken = result.accessToken;
				label = "Logout";
				loginBtn.alpha = 0.5;
				
			}else
			{				
				label = "Login";
				loginBtn.alpha = 1;
			}			
		}
		
		private function handleLoginClick(event:MouseEvent):void 
		{		
			if (label == "Login") 
			{				
				FacebookMobile.login(onFacebookInit, this.stage , AppGlobalVariables.PERMISSIONS, getWebView(), "touch");
			
			} else {
				trace("LOGOUT\n");				
				FacebookMobile.logout(onLogout, AppGlobalVariables.FACEBOOK_APP_ORIGIN); //Redirect user back to your app url				
			}
		}
		
		private function onLogout(response:Object):void 
		{
			label = "Login";
			loginBtn.alpha = 1;
		}
		
		private function getWebView():StageWebView
		{
			if(webView)
				webView.dispose();
			
			webView = new StageWebView();
			webView.stage=this.stage;
			webView.assignFocus();
			
			webView.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			return webView;
		}
		
		public function removeUserList():void
		{
			var par:Object;
			for(par in _buttonsCache)
			{
				(par as TextField).removeEventListener(MouseEvent.CLICK, handlerSelectUser);
				_skin.removeChild( (par as TextField) );
				
				delete _buttonsCache[par];
			}
		}
		
		
		public function setUserList(v:Vector.<UserData>):void
		{
			_buttonsCache = new Dictionary();
			
			var i:int, txt:TextField, format:TextFormat;
			format = new TextFormat(null, 30, null, true);
			for(i = 0; i < v.length; i++)
			{
				txt = new TextField();
				txt.background = true;
				txt.text = v[i].name + " " + v[i].deviceID;
				txt.setTextFormat( format );
				txt.width = 450;
				txt.selectable = false;
				
				txt.x = 50;
				txt.y = 50 + i * 80;
				txt.height = 35;
				
				_buttonsCache[txt] = v[i];
				
				txt.addEventListener(MouseEvent.CLICK, handlerSelectUser);
				
				_skin.addChild( txt );
			}
			
			_btOk = _skin.getChildByName("ok_btn") as SimpleButton;
			if(_btOk) _btOk.addEventListener(MouseEvent.CLICK, handlerClickOk);
			
			_txt = _skin.getChildByName("nameTxt") as TextField;
		}
		
		private function handlerClickOk(e:MouseEvent):void
		{
			userName = _txt.text;
			this.dispatchEvent( new Event(CREATE_NEW_USER) );
		}
		
		private function createViewComponents():void
		{
			var classRef:Class = BaseMediator.getSourceClass("viewSelectUserWindow");
			
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
			}	
		}
		
		
		private function handlerSelectUser(e:MouseEvent):void
		{
			if(_buttonsCache[e.currentTarget])
			{
				selectedID = _buttonsCache[e.currentTarget].id;
				
				this.dispatchEvent( new Event(SELECT_USER) );
			}
		}
	}
}