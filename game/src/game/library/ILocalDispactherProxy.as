package game.library
{
	public interface ILocalDispactherProxy
	{
		function addLocalListener(event:uint, listener:Function):void
		function removeLocalListener(event:uint, listener:Function):void
		function dispactherLocalEvent(event:uint, data:* = null):void
	}
}