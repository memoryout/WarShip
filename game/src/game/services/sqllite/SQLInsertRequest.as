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
			var params:String, values:String;
			params = values = "";
			
			
			var reqParams:Object = this.requestParams;
			
			var par:String;
			for(par in reqParams)
			{
				if(params != "")
				{
					params += ",";
					values += ",";
				}
				
				params += '"' + par + '"';
				values += '"' + reqParams[par] + '"';
				
				//delete reqParams[par];
			}
			
			return 'INSERT INTO ' + _into + ' (' + params + ') VALUES (' + values + ')';
		}
	}
}