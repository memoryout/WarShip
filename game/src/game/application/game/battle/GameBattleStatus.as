package game.application.game.battle
{
	public class GameBattleStatus
	{
		public static const WAITING_FOR_START:    		uint = 0; // wait for oponent
		
		public static const STEP_OF_INCOMING_USER:   	uint = 1; // players step
		public static const STEP_OF_OPPONENT:    		uint = 2; // oponents step
		
		public static const INCOMING_USER_WON:   		uint = 3; // user won   
		public static const OPPONENT_WON:				uint = 4; // player won
		
		public static const INCOMING_USER_OUT:    		uint = 5; // player out
		public static const OPPONENT_OUT:     			uint = 6; // oponent out
		
		
		
		public static const WAITINIG_GAME_ANSWER:		uint = 7;	// internal status that means lock game until proxy will receive result from server
	}
}