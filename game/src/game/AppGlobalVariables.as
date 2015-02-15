package game
{
	import flash.media.StageWebView;

	public class AppGlobalVariables
	{
		public static var SOURCE_URL:						String = "data/source_fp.swf";
		public static var ANIMATIONS_URL:					String = "data/animations_fp.swf";
		public static var SQL_FILE_URL:						String = "data/warship.sqlite";
		
		
		public static var SERVER_URL:						String = "http://sb-stable.kek.net.ua/";
		public static var SERVER_PORT:						String = "";
		public static var CONNECTION_TYPE:					String = "http";
		
		public static const SERVER_CONNECTION_TIMEOUT:		uint = 3000;
		
		//Your App Id as created on Facebook			
		public static var FACEBOOK_APP_ID:String 		= "302102433308270";
		
		//App origin URL		
		public static var FACEBOOK_APP_ORIGIN:String 	= "https://apps.facebook.com/seabattle_app";
		
		//Permissions Array		
		public static var FACEBOOK_PERMISSIONS:Array 	= ["publish_stream"];		
		
		public static var AUTH_ENDPOINT_FACEBOOK:String	= "https://graph.facebook.com/oauth/authorize";
		public static var TOKEN_ENDPOINT_FACEBOOK:String= "https://graph.facebook.com/oauth/access_token";
		
		public static var REDIRECT_URL_FACEBOOK:String  = "urn:ietf:wg:oauth:2.0:oob";
		
		public static var CLIENT_SECRET_FACEBOOK:String = "e9ef5f045a17655dc5e73f6bf2207bf1";
		
		public static var SCOPE_FACEBOOK:String  		= "https://www.facebook.com/dialog/oauth?";
		
		
		//Your App Id as created on VK		
		public static var VK_APP_ID:String 				= "4579404";
		
		public static var VK_SECRET:String 				= "MfXb8AACjilOgKAkIM1D";
						
		public static var VK_URL:String 				= "https://oauth.vk.com/authorize?client_id=";
		
		public static var VK_PERMISSIONS:String 		= "user_id";
		
		
		public static var AUTH_ENDPOINT_VK:String		= "https://oauth.vk.com/authorize";
		public static var TOKEN_ENDPOINT_VK:String		= "https://oauth.vk.com/access_token";
		
		public static var URL_VK:String  				= "https://oauth.vk.com/blank.html";
			
		
		/// google plus
		public static var CLIENT_ID_GOOGLE_PLUS:String  = "707420486365-fv6r0c9use9e4t6l4rhrgvcg4o9if3f7.apps.googleusercontent.com";
		
		public static var CLIENT_SECRET_GOOGLE_PLUS:String  = "56wvtNizL6fZTgteOkBxMmAi";
		
		public static var URL_PLUS:String  				= "urn:ietf:wg:oauth:2.0:oob";
		public static var SCOPE_PLUS:String  			= "https://www.googleapis.com/auth/userinfo.profile";
		
		public static var AUTH_ENDPOINT_GOOGLE_PLUS:String	= "https://accounts.google.com/o/oauth2/auth";
		public static var TOKEN_ENDPOINT_GOOGLE_PLUS:String	= "https://accounts.google.com/o/oauth2/token";
		
		public static var accessToken:String = "";
		
		
		public static const SIMULATOR:				uint = 0;
		public static const GOOGLE:					uint = 1;
		
		public static const TARGET_PLATFORM:			uint = SIMULATOR;
		
		public static const SIMULATOR_EMAIL:		String = "kirga@ukr.net";
		public static const SIMULATOR_PASS:			String = "1234567890";
		public static const SIMULATOR_NAME:			String = "kirga";
		
	}
}