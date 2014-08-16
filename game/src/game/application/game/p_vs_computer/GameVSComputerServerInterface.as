package game.application.game.p_vs_computer
{
	import game.application.ProxyList;
	import game.application.computer.ComputerAI;
	import game.application.connection.ServerDataChannel;
	import game.application.interfaces.channel.IServerDataChannel;
	import game.application.interfaces.data.IUserDataProxy;
	import game.application.interfaces.server.ILocalGameServer;
	import game.application.server.LocalGameServer;
	import game.library.LocalDispactherProxy;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class GameVSComputerServerInterface extends LocalDispactherProxy
	{
		public static const NAME:			String = "GameVSComputerServerInterface";
		
		private var _localServer:			ILocalGameServer;
		private var _computerAI:			ComputerAI;
		
		private var _userChannel:			IServerDataChannel;
		private var _computerChannel:		IServerDataChannel;
		
		public function GameVSComputerServerInterface()
		{
			super(NAME);
		}
		
		public function init():void
		{
			_localServer = new LocalGameServer(ProxyList.LOCAL_GAME_SERVER) as ILocalGameServer;
			
			_computerAI = new ComputerAI();
			
			_userChannel = this.facade.retrieveProxy( ProxyList.CLIENT_DATA_CHANNEL ) as IServerDataChannel;
			if( !_userChannel )
			{
				_userChannel = new ServerDataChannel( ProxyList.CLIENT_DATA_CHANNEL );
				this.facade.registerProxy( _userChannel as IProxy );
			}
			
			_computerChannel = this.facade.retrieveProxy( ProxyList.LOCAL_DATA_CHANNEL ) as IServerDataChannel;
			if( !_userChannel )
			{
				_computerChannel = new ServerDataChannel( ProxyList.LOCAL_DATA_CHANNEL );
				this.facade.registerProxy( _computerChannel as IProxy );
			}
		}
		
		override public function onRegister():void
		{
			_computerAI.init();
		}
				
		
		public function registerUser(userId:String):void
		{
			_localServer.registerPlayer( userId );
		}
		
		
		public function sendUserShipLocation(ships:Array, userId:String):void
		{
			_localServer.sendUserShipLocation( ships, userId );
		}
		
		public function sendHitPointPosition(x:uint, y:uint, userId:String):void
		{
			_localServer.sendHitPointPosition(x, y, userId);
		}
	}
}