package game
{
	import flash.media.StageWebView;

	public class AppGlobalVariables
	{
		public static var SOURCE_URL:						String = "data/source_fp.swf";
		public static var SQL_FILE_URL:						String = "data/warship.sqlite";
		
		
		public static var SERVER_URL:						String = "http://sb-stable.kek.net.ua/";
		public static var SERVER_PORT:						String = "";
		public static var CONNECTION_TYPE:					String = "http";
		
		public static const SERVER_CONNECTION_TIMEOUT:		uint = 3000;
		
		//Your App Id as created on Facebook
		
		public static var APP_ID:String = "302102433308270";
		
		//App origin URL
		
		public static var FACEBOOK_APP_ORIGIN:String = "https://apps.facebook.com/seabattle_app";
		
		//Permissions Array
		
		public static var PERMISSIONS:Array = ["publish_stream"];
		
		//SatgeWebView to render Facebook login
		
		public static var facebookWebView:StageWebView;
		
		public static var accessToken:String = "CAAESwrQ5Hm4BAHXvHwqarSsMmn5jbSZAkdFyKwLKWhTPKKA4iXQ3Wtr55C3Q181AjVT9U89OMwvoGcSqMf9ZCOJ2BzN3jXFp5vSkdYhDQzq8Q0cOthOFjncj7IwwxFK6XJImszP2XmBnEbKDecYFusr0oXCxmZCLSnw7l6NXcPEgVa1opAMQP01YN6kTQvWqLNwIJFYaU3ZAHrTnRXhgIt1ZAXNNhUtMZD";
	}
}