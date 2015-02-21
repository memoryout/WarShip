package game.application
{
	public class ApplicationEvents
	{
		public static const START_UP_INIT:						String = "event.start_up.init";
		public static const START_UP_SOURCE_LOAD_START:			String = "event.start_up.source.load.start";
		public static const START_UP_SOURCE_LOAD_COMPLETE:		String = "event.start_up.source.load.complete";
		public static const START_UP_PRELOADER_LOAD_COMPLETE:	String = "event.start_up.source.load.preloader_load_complete";
		public static const START_UP_SOURCE_LOAD_ERROR:			String = "event.start_up.source.load.error";
		
		public static const START_UP_REQUEST_DEVICE_INFO:	String = "event.start_up.device_info.request";
		public static const START_UP_DEVICE_INFO_RECEIVED:	String = "event.start_up.device_info.received";
		
		public static const START_UP_DB_OPEN_CONNECTION:	String = "event.start_up.db.connection.open";
		public static const START_UP_DB_CONNECTED:			String = "event.start_up.db.connected";
		
		public static const START_UP_AUTHORIZATION_INIT:	String = "event.start_up.auth.init";
		
		public static const REQUIRED_USER_AUTHORIZATION:	String = "event.start_up.required.user_authorization";
		public static const REQUIRED_SELECT_ACTIVE_USER:	String = "event.start_up.required.user_select";
		
		
		public static const GAME_CONTEXT_CREATE_COMPLETE:	String = "event.game.context.create.complete";
		
		
	
		public static const START_UP_COMPLETE:				String = "event.start_up.complete";
		
		public static const GAME_CORE_READY_TO_START_GAME:	String = "event.core.ready_to_start_game";
		
		public static const SHOW_USER_PROFILER:				String = "event.core.show_user_profiler";
		
		public static const USER_DATA_PROXY_CONNECTED:		String = "event.user_data_proxy.connected";
		public static const USER_DATA_RECEIVE_USERS_LIST:	String = "event.user_data_proxy.users_list_receive";
		public static const USER_DATA_USER_CREATED:			String = "event.user_data_proxy.user.created";
		public static const USER_DATA_USER_DELETED:			String = "event.user_data_proxy.user.deleted";
		
		public static const REQUIRED_USER_SHIPS_POSITIONS:	String = "event.game.required_ships_positions";
		public static const REQUIRED_CHOOSE_DIFFICULT_LEVEL:String = "event.game.required_choose_difficult_level";
		
		public static const BUTTLE_PROXY_INIT_COMPLETE:		String = "event.buttle.init.complete";
		public static const BUTTLE_PROXY_GAME_READY_TO_START:String = "event.battle.ready.to.start";
		
		
		public static const USER_PRESS_BACK:				String = "event.user.press.back_button";
		
		public static const SHOW_RESULT_WINDOW:				String = "event.user.press.show_result_window";		
		
	}
}