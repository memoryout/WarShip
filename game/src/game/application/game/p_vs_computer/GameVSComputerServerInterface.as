package game.application.game.p_vs_computer
{
	import game.application.ProxyList;
	import game.application.computer.ComputerAI;
	import game.application.interfaces.server.ILocalGameServer;
	import game.application.server.LocalGameServer;

	public class GameVSComputerServerInterface
	{
		private var _localServer:			ILocalGameServer;
		private var _computerAI:			ComputerAI;
		
		public function GameVSComputerServerInterface()
		{
			
		}
		
		public function init():void
		{
			_localServer = new LocalGameServer(ProxyList.LOCAL_GAME_SERVER) as ILocalGameServer;
			
			_computerAI = new ComputerAI();
			_localServer.registerPlayer( ComputerAI.PLAYER_ID );
			
			
		}
	}
}