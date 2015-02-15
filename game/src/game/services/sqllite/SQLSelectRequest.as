package game.services.sqllite
{
	import flash.utils.Dictionary;

	public class SQLSelectRequest extends SQLRequest
	{
		private var _from:String;
		private var _select:String;
		
		private var _whereParams:		Dictionary;
		
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
		
		public function addWhere(name:String, value:String):void
		{
			if(!_whereParams) _whereParams = new Dictionary();
			_whereParams[name] = value;
		}
		
		
		override public function getRawRequest():String
		{
			var str:String = "";
			
			str = 'SELECT ' + _select + ' FROM ' + _from;
			
			if(_whereParams != null)
			{
				var condition:String = "";
				
				var par:String;
				for(par in _whereParams)
				{
					if(condition != "") condition += " AND ";
					condition += par + "=" + _whereParams[par];
				}
				
				str += " WHERE " + condition;
			}
			
			return str;
		}
	}
}