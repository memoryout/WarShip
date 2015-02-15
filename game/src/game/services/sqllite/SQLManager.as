package game.services.sqllite
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import game.services.IService;
	import game.services.ServicesList;
	import game.services.interfaces.ISQLManager;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SQLManager implements ISQLManager, IService
	{
		private var _connection:			SQLConnection;
		private var _isConnected:			Boolean;
		
		private const _quaryList:			Vector.<SQLRequest> = new Vector.<SQLRequest>;
		
		private var _isProcessed:			Boolean;
		private var _currentRequest:		SQLRequest;
		private var _currentStatement:		SQLStatement;
		
		private var _onCompleteConnect:		Function;
		private var _onErrorConnect:		Function;
		
		
		public function SQLManager()
		{
			_isProcessed = false;
			_isConnected = false;
		}
		
		
		public static function init():void
		{
			ServicesList.addSearvice( new SQLManager() );
		}
		
		
		public function get serviceName():String
		{
			return ServicesList.SQL_MANAGER;
		}
		
		
		public function connect(url:String, onComplete:Function, onError:Function):void
		{
			_onCompleteConnect = onComplete;
			_onErrorConnect = onError;
			
			_connection = new SQLConnection();
			_connection.addEventListener(SQLEvent.OPEN, handlerOpen);
			_connection.addEventListener(SQLErrorEvent.ERROR, handlerErrorOpen);
			
			var file:File = File.applicationDirectory;
			file.url += url;
			
			_connection.openAsync(file, SQLMode.UPDATE);
		}
		
		
		public function executeRequest(request:SQLRequest):void
		{
			_quaryList.push(request);
			
			tryExecuteRequest();
		}
				
		
		public function closeConnection():void
		{
			_connection.close();
		}
		
		
		private function tryExecuteRequest():void
		{
			if(_isConnected && !_isProcessed && _quaryList.length)
			{
				_isProcessed = true;
				
				_currentRequest = _quaryList.shift();
				
				_currentStatement = new SQLStatement();
				
				var par:String;
				
				if(_currentRequest.getRawRequest() != null) 
				{
					_currentStatement.text = _currentRequest.getRawRequest();
					trace(_currentStatement.text);
					
					/*if(_currentRequest.requestParams)
					{
						
						for(par in _currentRequest.requestParams) _currentStatement.parameters[par] = _currentRequest.requestParams[par];
					}*/
				}
				else
				{
					_currentStatement.text = _currentRequest.request;
					
					if(_currentRequest.requestParams)
					{
						for(par in _currentRequest.requestParams) _currentStatement.parameters[par] = _currentRequest.requestParams[par];
					}
				}
				
				
				_currentStatement.sqlConnection = _connection;
				
				trace( _currentStatement.text );
				
				_currentStatement.addEventListener(SQLEvent.RESULT, handlerRequestResult);
				_currentStatement.addEventListener(SQLErrorEvent.ERROR, handlerErrorRequest);
				_currentStatement.execute();
				
				if(_connection.inTransaction) _connection.commit();
			}
		}
		
		private function handlerErrorOpen(e:SQLErrorEvent):void
		{
			_connection.removeEventListener(SQLEvent.OPEN, handlerOpen);
			_connection.removeEventListener(SQLErrorEvent.ERROR, handlerErrorOpen);
			
			_onCompleteConnect = null;
			if(_onErrorConnect != null) _onErrorConnect();
			_onErrorConnect = null;
		}
		
		
		private function handlerOpen(e:SQLEvent):void
		{
			_connection.removeEventListener(SQLEvent.OPEN, handlerOpen);
			
			_connection.addEventListener(SQLEvent.BEGIN, handlerSQLBegin);
			_connection.begin();
		}
		
		
		private function handlerSQLBegin(e:SQLEvent):void
		{
			_connection.removeEventListener(SQLEvent.BEGIN, handlerSQLBegin);
			
			_isConnected = true;
			_isProcessed = false;
			
			_onErrorConnect = null;
			if(_onCompleteConnect != null) _onCompleteConnect();
			_onCompleteConnect = null;
			
			tryExecuteRequest();
		}
		
		
		
		
		private function handlerRequestResult(e:SQLEvent):void
		{
			_currentStatement.removeEventListener(SQLEvent.RESULT, handlerRequestResult);
			_currentStatement.removeEventListener(SQLErrorEvent.ERROR, handlerErrorRequest);
			
			var sqlResult:SQLResult = (e.currentTarget as SQLStatement).getResult();
			
			//_currentRequest.onResult( sqlResult.data );
			_currentRequest.setRequestResult(sqlResult);
			
			_isProcessed = false;
			tryExecuteRequest();
		}
		
		
		private function handlerErrorRequest(e:SQLErrorEvent):void
		{
			_currentStatement.removeEventListener(SQLEvent.RESULT, handlerRequestResult);
			_currentStatement.removeEventListener(SQLErrorEvent.ERROR, handlerErrorRequest);
			trace(e.toString())
			//_currentRequest.onErrorResult(e.toString());
			
			_currentRequest.setRequstError(e);
			
			_isProcessed = false;
			tryExecuteRequest();
		}
		
		
		private function traceDirrectoryList(file:File):void
		{
			if(file.isDirectory)
			{
				trace("folder: " + file.url);
				
				var arr:Array = file.getDirectoryListing();
				var i:int;
				var f:File;
				for(i = 0; i < arr.length; i++)
				{
					f = arr[i];
					if(f.isDirectory) traceDirrectoryList(f);
					else trace("file: " + f.url);
				}
			}
		}
	}
}