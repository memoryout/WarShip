package game.application.server
{
	import game.application.server.data.ResponceData;

	public class ServerResponce
	{
		private var _rawData:			Object;
		
		private var _dataList:			Vector.<ResponceData>;
		
		public function ServerResponce()
		{
			_dataList = new Vector.<ResponceData>;
		}
		
		
		public function pushData(data:ResponceData):void
		{
			_dataList.push(data);
		}
		
		public function getDataList():Vector.<ResponceData>
		{
			return _dataList;
		}
		
		
		public function setRawData(obj:Object):void
		{
			_rawData = obj;
		}
		
		
		public function getRawData():Object
		{
			return _rawData;
		}
	}
}