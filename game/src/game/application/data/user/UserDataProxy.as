package game.application.data.user
{
	import flash.data.SQLConnection;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	
	import game.application.ApplicationEvents;
	import game.application.interfaces.data.IUserDataProxy;
	import game.services.ServicesList;
	import game.services.interfaces.ISQLManager;
	import game.services.sql.SQLManager;
	import game.services.sql.SQLRequest;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class UserDataProxy extends Proxy implements IUserDataProxy
	{
		private var _sqlManager:			ISQLManager;
		
		private var _userData:				UserData;
		
		public function UserDataProxy(proxyName:String=null)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			_sqlManager = ServicesList.getSearvice(ServicesList.SQL_MANAGER) as ISQLManager;
		}
		
				
		public function connect():void
		{
			tryRetrieveUserData();
		}
		
		
		public function getUserData():UserData
		{
			return _userData;
		}
		
		
		public function commitChanges():void
		{
			if(_userData.isChanged())
			{
				var fieldsArr:Array = _userData.getFields();
				
				var fields:String = "", requestParams:Object;
				var i:int;
				requestParams = new Object();
				
				for(i = 0; i < fieldsArr.length; i++)
				{
					if(i) fields += ","; 
					fields += fieldsArr[i];
					fields += "=";
					fields += ":" + fieldsArr[i];
					requestParams[ ":" + fieldsArr[i] ] = _userData.getValue( fieldsArr[i] );
				}
							
				var requestMessage:String = 'UPDATE "main"."user" SET ' + fields + ' WHERE "rowid"=1';
				
				var sqlRequest:SQLRequest = new SQLRequest();
				sqlRequest.setRequest(requestMessage, null, null);
				sqlRequest.setRequestParame( requestParams );
				
				_sqlManager.executeRequest( sqlRequest );
			}
		}
		
		
		
		
		
		private function tryRetrieveUserData():void
		{
			var requestMessage:String = 'SELECT * FROM "main"."user"';
			
			var request:UserDataProxyRequest = new UserDataProxyRequest();
			request.setData(_sqlManager, requestMessage, onRetrieveUserData, onErrorRetrieveUserData);
		}
		
		
		private function onRetrieveUserData(request:UserDataProxyRequest):void
		{
			if(request)
			{
				if(request.result && request.result.length)
				{
					_userData = new UserData(request.result[0]);
					this.sendNotification( ApplicationEvents.USER_DATA_PROXY_CONNECTED);
				}
				else
				{
					createDefaultUser();
				}
			}
			
			request.destroy();
		}
		
				
		private function onErrorRetrieveUserData(request:UserDataProxyRequest):void
		{
			request.destroy();
		}
		
		
		private function createDefaultUser():void
		{
			var requestMessage:String = 'INSERT INTO "main"."user" ("name","key","exp","deviceID","login","pass") VALUES (null, null, null, null, null, null)';
			
			var request:UserDataProxyRequest = new UserDataProxyRequest();
			request.setData(_sqlManager, requestMessage, handlerCreateDefaultUser, handlerErrorDefaultUser);
		}
		
		
		private function handlerCreateDefaultUser(request:UserDataProxyRequest):void
		{
			tryRetrieveUserData();
			
			request.destroy();
		}
		
				
		private function handlerErrorDefaultUser(request:UserDataProxyRequest):void
		{
			request.destroy();
		}
	}
}