package game.application.computer
{
	import game.application.ProxyList;
	import game.application.connection.ServerDataChannelEvent;
	import game.application.game.p_vs_computer.GameVSComputerServerInterface;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.library.BaseProxy;

	public class ComputerAI extends BaseProxy
	{
		public static const PLAYER_ID:		String = "computer_id";
		
		private var _dataChannel:			IServerDataChannel;
		private var _serverConnection:		GameVSComputerServerInterface;
		
		private var shipsPositions:			Array = [[2,4,2,7], [7,6,9,6], [3,0,5,0], [0,9,1,9], [5,4,6,4], [8,4,9,4], [7,0,7,0], [4,8,4,8], [3,2,3,2], [7,2,7,2]];
		
		public function ComputerAI()
		{
			super();
		}
		
		public function init():void
		{
			_dataChannel = this.facade.retrieveProxy( ProxyList.LOCAL_DATA_CHANNEL ) as IServerDataChannel;
			
			_serverConnection = this.facade.retrieveProxy( GameVSComputerServerInterface.NAME) as GameVSComputerServerInterface;
			
			generateShipsPosition();
		}
		
		
		private function generateShipsPosition():void
		{
			_serverConnection.sendUserShipLocation( shipsPositions, PLAYER_ID);
		}
	}
}