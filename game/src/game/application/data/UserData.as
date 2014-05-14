package game.application.data
{
	public class UserData
	{
		private var _changed:			Boolean;
		
		private var _dataObject:		Object;
		
		public function UserData(obj:Object):void
		{
			_dataObject = obj;
			_changed = false;
		}
		
		
		public function isChanged():Boolean
		{
			return _changed;
		}
		
		public function getValue(field:String):*
		{
			if( _dataObject.hasOwnProperty(field) ) return _dataObject[field];
			return undefined;
		}
		
		public function setValue(field:String, data:*):void
		{
			if( _dataObject.hasOwnProperty(field) ) 
			{
				if(_dataObject[field] != data)
				{
					_dataObject[field] = data;
					_changed = true;
				}
			}
		}
		
		
		public function getFields():Array
		{
			var arr:Array = [];
			var par:String;
			for(par in _dataObject)
			{
				arr.push(par);
			}
			
			return arr;
		}
	}
}