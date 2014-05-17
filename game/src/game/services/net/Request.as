package game.services.net
{
	public class Request
	{
		private static  var _globalID:	uint = 0;
		
		private const _requestID:		Number = (_globalID ++) + Math.random() * _globalID;
		
		private var _sendData:			Object;
		
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
			_sendData["rnd"] = _requestID;
		}
		
		
		public function getSendData():Object
		{
			return _sendData
		}
		
		
		public function setResult():void
		{
			
		}
	}
}