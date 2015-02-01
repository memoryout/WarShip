package game.services.sqllite
{
	public class SQLSelectRequest extends SQLRequest
	{
		private var _from:String;
		private var _select:String;
		
		public function SQLSelectRequest()
		{
			
		}
		
		public function set select(value:String):void
		{
			_select = value;
		}
		
		public function set from(table:String):void
		{
			_from = table;
		}
		
		
		override public function getRawRequest():String
		{
			var str:String = "";
			
			str = 'SELECT ' + _select + ' FROM ' + _from;
			
			return str;
		}
	}
}