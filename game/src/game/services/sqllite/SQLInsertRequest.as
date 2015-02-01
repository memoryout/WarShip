package game.services.sqllite
{
	import flash.utils.Dictionary;

	public class SQLInsertRequest extends SQLRequest
	{
		private var _into:			String;
		
		private var _parameters:	Dictionary;
		
		public function SQLInsertRequest()
		{
			super();
		}
		
		
		public function set into(value:String):void
		{
			_into = value;
		}
		
		override public function getRawRequest():String
		{
			return 'INSERT INTO ' + _into;
		}
	}
}