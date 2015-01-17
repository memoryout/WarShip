package game.activity.view.application.windows.authorization_users
{
	import com.adobe.protocols.oauth2.OAuth2;
	import com.adobe.protocols.oauth2.event.GetAccessTokenEvent;
	import com.adobe.protocols.oauth2.grant.AuthorizationCodeGrant;
	import com.adobe.protocols.oauth2.grant.IGrantType;
	import com.facebook.graph.FacebookMobile;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import game.AppGlobalVariables;
	import game.activity.BaseMediator;
	import game.application.data.user.UserData;
	
	import org.as3commons.logging.setup.LogSetupLevel;
	
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
		public var userPass:		String;
		public var userEmail:		String;
		
		private var webView:StageWebView;
		
		private var loginBtnFacebook:		SimpleButton;
		private var loginBtnGooglePlus:		SimpleButton;
		private var loginBtnVK:				SimpleButton;
		
		private var label:String;
		
		public function SelectCurrentUserWindow()
		{
			super();
			
			createViewComponents();
			
			
			addListaners();
//			initVk();
//			initFaceBook();		
		}
		
		private function addListaners():void
		{		
			loginBtnFacebook.addEventListener(MouseEvent.CLICK, 	getOuth, false, 0, true);
			loginBtnGooglePlus.addEventListener(MouseEvent.CLICK, 	getOuth, false, 0, true);
			loginBtnVK.addEventListener(MouseEvent.CLICK, 			getOuth, false, 0, true);
		}
		
		private function getOuth(e:Event):void
		{
			var oauth2:OAuth2; 
			var grant:IGrantType;
		
			if(e.target.name == "login_btn_facebook")
			{
//				oauth2 = new OAuth2(AppGlobalVariables.AUTH_ENDPOINT_FACEBOOK, AppGlobalVariables.TOKEN_ENDPOINT_FACEBOOK, LogSetupLevel.ALL);
//				grant  = new AuthorizationCodeGrant(getWebView(), AppGlobalVariables.FACEBOOK_APP_ID, AppGlobalVariables.CLIENT_SECRET_FACEBOOK, AppGlobalVariables.REDIRECT_URL_FACEBOOK);
				
				FacebookMobile.init(AppGlobalVariables.FACEBOOK_APP_ID, onFacebookInit);
				
			}else if(e.target.name == "login_btn_google_plus")
			{
				oauth2 = new OAuth2(AppGlobalVariables.AUTH_ENDPOINT_GOOGLE_PLUS, AppGlobalVariables.TOKEN_ENDPOINT_GOOGLE_PLUS, LogSetupLevel.ALL);
				grant  = new AuthorizationCodeGrant(getWebView(), AppGlobalVariables.CLIENT_ID_GOOGLE_PLUS, AppGlobalVariables.CLIENT_SECRET_GOOGLE_PLUS, AppGlobalVariables.URL_PLUS, AppGlobalVariables.SCOPE_PLUS);
				
			}else if(e.target.name == "login_btn_vk"){
				
				oauth2 = new OAuth2(AppGlobalVariables.AUTH_ENDPOINT_VK, AppGlobalVariables.TOKEN_ENDPOINT_VK, LogSetupLevel.ALL);
				grant  = new AuthorizationCodeGrant(getWebView(), AppGlobalVariables.VK_APP_ID, AppGlobalVariables.VK_SECRET, AppGlobalVariables.URL_VK);
			}
			
			// make the call
			
			if(oauth2)
			{
				oauth2.addEventListener(GetAccessTokenEvent.TYPE, onGetAccessToken);
				oauth2.getAccessToken(grant);
			}
			
		}
		
		private function onGetAccessToken(getAccessTokenEvent:GetAccessTokenEvent):void
		{
			if (getAccessTokenEvent.errorCode == null && getAccessTokenEvent.errorMessage == null)
			{
				// success!
				trace("Your access token value is: " + getAccessTokenEvent.accessToken);
				if(webView)				webView.dispose();
			}
			else
			{
				// fail :(
			}
		} 
		
		private function initVk():void
		{
			import flash.media.StageWebView;
			var sendHeader:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			
			var url:String = "https://oauth.vk.com/authorize?" + "client_id=4579404" + "&scope=" + "user_id" 
				+ "&redirect_uri=http://api.vk.com/blank.html" + "&display=page" + "&v=5.25" + "&response_type=token";
			
			var request:URLRequest = new URLRequest(url);
			request.requestHeaders.push(sendHeader);
			request.method = URLRequestMethod.GET;
			
			var requestor:URLLoader = new URLLoader();
			requestor.addEventListener(Event.COMPLETE, apiVKAccessToken);
			try {
				requestor.load(request);
			}catch (error:Error) {
				trace("error# " + error.message);
			}
			
			function apiVKAccessToken(e:Event):void {                    
				//var stageWebView:StageWebView = new StageWebView()
				var obj:Object = e.target.data;
				var webView:StageWebView = new StageWebView();
				webView.stage=this.stage;
				webView.viewPort=new Rectangle(0,0,500,400);
				//webView.addEventListener(ErrorEvent.ERROR,onError);
				//webView.addEventListener(LocationChangeEvent.LOCATION_CHANGING,onChanging);
				//webView.addEventListener(Event.COMPLETE,onComplete);
				webView.loadURL(url);
				trace(obj);
				requestor.removeEventListener(Event.COMPLETE, apiVKAccessToken);
				//                    flashVars['acces_token'] = stage.loaderInfo.parameters['http://api.vk.com/blank.html#access_token'];
			} 
		}	
		
		private function handleLoginClickVK(event:MouseEvent):void 
		{		
			if (label == "Login") 
			{				
				FacebookMobile.login(onFacebookInit, this.stage , AppGlobalVariables.FACEBOOK_PERMISSIONS, getWebView(), "touch");
				
			} else {
				trace("LOGOUT\n");				
				FacebookMobile.logout(onLogout, AppGlobalVariables.FACEBOOK_APP_ORIGIN); //Redirect user back to your app url				
			}
		}
		
		
		private function initFaceBook():void
		{
//			loginBtn = _skin.getChildByName("login_btn") as SimpleButton;				
			
			FacebookMobile.init(AppGlobalVariables.FACEBOOK_APP_ID, onFacebookInit);
			
//			loginBtn.addEventListener(MouseEvent.CLICK, handleLoginClick, false, 0, true);
		}
		
		private function onFacebookInit(result:Object, fail:Object):void			
		{			
			if(result)				
			{				
				AppGlobalVariables.accessToken = result.accessToken;
				label = "Logout";
//				loginBtn.alpha = 0.5;
				trace("Your access token value is: " + result.accessToken);
				
			}else
			{				
				label = "Login";
				FacebookMobile.login(onFacebookInit, this.stage , AppGlobalVariables.FACEBOOK_PERMISSIONS, getWebView(), "touch");
//				loginBtn.alpha = 1;
			}			
		}
		
		private function handleLoginClick(event:MouseEvent):void 
		{		
			if (label == "Login") 
			{				
				FacebookMobile.login(onFacebookInit, this.stage , AppGlobalVariables.FACEBOOK_PERMISSIONS, getWebView(), "touch");
			
			} else {
				trace("LOGOUT\n");				
				FacebookMobile.logout(onLogout, AppGlobalVariables.FACEBOOK_APP_ORIGIN); //Redirect user back to your app url				
			}
		}
		
		private function onLogout(response:Object):void 
		{
			label = "Login";
//			loginBtn.alpha = 1;
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
			userName  = _txt.text;
			userPass  = _txt.text;
			userEmail = _txt.text;
			
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
			
			loginBtnFacebook	=  _skin.getChildByName("login_btn_facebook") as SimpleButton;	
			loginBtnGooglePlus	=  _skin.getChildByName("login_btn_google_plus") as SimpleButton;	
			loginBtnVK			=  _skin.getChildByName("login_btn_vk") as SimpleButton;	
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