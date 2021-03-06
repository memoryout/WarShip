package game.services.net
{
	public class Request
	{
		private static  var _globalID:	uint = 0;
		
		private const _requestID:		Number = (_globalID ++) + Math.random() * _globalID;
		
		private var _sendData:			Object;
		private var _data:				Object;
		
		public function Request()
		{
			
		}
		
		
		public function get requestID():Number
		{
			return _requestID;
		}
		
		
		public function pushData(obj:Object):void
		{
			_sendData = obj;
		}
		
		
		public function getSendData():Object
		{
			return _sendData
		}
		
		
		public function setResult(data:Object):void
		{
			_data = data;
		}
		
		public function getResult():Object
		{
			return _data;
		}
		
		
		public function destroy():void
		{
			_sendData = null;
			_data = null;
		}
	}
}