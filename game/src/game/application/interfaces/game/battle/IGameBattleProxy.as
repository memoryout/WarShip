package game.application.interfaces.game.battle
{
	import game.application.game.battle.GameBattleAction;
	import game.application.interfaces.IBaseProxy;

	public interface IGameBattleProxy extends IBaseProxy
	{
		function getStatus():uint;
		function getAction():GameBattleAction;
	}
}