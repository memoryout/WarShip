package game.application.interfaces.game.battle
{
	import game.application.data.game.GamePlayerData;
	import game.application.game.battle.GameBattleAction;
	import game.application.interfaces.IBaseProxy;

	public interface IGameBattleProxy extends IBaseProxy
	{
		function getStatus():uint;
		function getAction():GameBattleAction;
		function getUserPlayerInfo():GamePlayerData;
		function getOpponentPlayerInfo():GamePlayerData
		
	}
}