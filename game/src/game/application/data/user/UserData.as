package game.application.data.user
{
	public class UserData
	{
		private var _changed:			Boolean;
		
		private var _dataObject:		Object;
		
		public function UserData(obj:Object = null):void
		{
			_dataObject = obj;
			_changed = false;
		}
		
		public function setData(data:Object):void
		{
			
		}
		
		public function get id():int
		{
			return int(_dataObject.id);
		}
		
		
		public function get name():String
		{
			return _dataObject.name;
		}
		
		public function get deviceID():String
		{
			return _dataObject.deviceID;
		}
		
		public function get login():String
		{
			return _dataObject.login;
		}
		
		public function get pass():String
		{
			return _dataObject.pass;
		}
		
		
		
		public function set name(value:String):void
		{
			if(_dataObject.name != value) _changed = true;
			_dataObject.name = value;
		}
		
		public function set deviceID(value:String):void
		{
			if(_dataObject.deviceID != value) _changed = true;
			_dataObject.deviceID = value;
		}
		
		public function set login(value:String):void
		{
			if(_dataObject.login != value) _changed = true;
			_dataObject.login = value;
		}
		
		public function set pass(value:String):void
		{
			if(_dataObject.pass != value) _changed = true;
			_dataObject.pass = value;
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
				if(par == "id") continue;
				arr.push(par);
			}
			
			return arr;
		}
	}
}