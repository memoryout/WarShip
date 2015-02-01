package game.application.data.user
{
	import flash.data.SQLConnection;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	
	import game.AppGlobalVariables;
	import game.application.ApplicationEvents;
	import game.application.interfaces.data.IUserDataProxy;
	import game.library.BaseProxy;
	import game.library.LocalDispactherProxy;
	import game.services.ServicesList;
	import game.services.interfaces.ISQLManager;
	import game.services.sqllite.SQLManager;
	import game.services.sqllite.SQLRequest;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class UserDataProxy extends LocalDispactherProxy implements IUserDataProxy
	{
		private var _sqlManager:			ISQLManager;
		
		private var _userData:				UserData;
		
		private var _currentUser:			UserData;
		
		private const _usersList:			Vector.<UserData> = new Vector.<UserData>;
		
		public function UserDataProxy(proxyName:String=null)
		{
			super(proxyName);
		}
		
		
		override public function onRegister():void
		{
			_sqlManager = ServicesList.getSearvice(ServicesList.SQL_MANAGER) as ISQLManager;
		}
		
		
		
		//--------- CONNECT TO DB ----------
		public function connect():void
		{
			var sql:ISQLManager = ServicesList.getSearvice( ServicesList.SQL_MANAGER ) as ISQLManager;
			//sql.connect(AppGlobalVariables.SQL_FILE_URL, onConnect, onErrorConnect);
			onConnect();
		}
		
		
		private function onConnect():void
		{
			this.sendNotification( ApplicationEvents.USER_DATA_PROXY_CONNECTED);
		}
		
		private function onErrorConnect():void
		{
			trace("onErrorConnect to data base");
		}
		//--------- --------- ----------
		
		
		
		//--------- RETRIEVE USERS LIST FROM DB ----------
		public function retrieveUsersList():void
		{
			var requestMessage:String = 'SELECT * FROM "main"."user"';
			
			var request:UserDataProxyRequest = new UserDataProxyRequest();
			request.setData(_sqlManager, requestMessage, onRetrieveUsersList, onErrorRetrieveUsersList);
		}
		
		
		private function onRetrieveUsersList(request:UserDataProxyRequest):void
		{
			if(request)
			{
				if(request.result && request.result.length) createUsersList(request.result);
				else _usersList.length = 0;
			}
			else
			{
				_usersList.length = 0;
			}
			
			request.destroy();
			
			this.sendNotification( ApplicationEvents.USER_DATA_RECEIVE_USERS_LIST );
		}
		
		private function onErrorRetrieveUsersList():void
		{
			this.sendNotification( ApplicationEvents.USER_DATA_RECEIVE_USERS_LIST );
		}
		//--------- ------------------------- ----------
		
		
		//--------- CREATE NEW USER ----------
		public function createNewUser(name:String, login:String, pass:String):void
		{
			var requestMessage:String = 'INSERT INTO "main"."user" ("name","deviceID","login","pass","exp") VALUES ("' + name + '", null, "' + login + '", "' + pass + '", null)';
			
			var request:UserDataProxyRequest = new UserDataProxyRequest();
			request.setData(_sqlManager, requestMessage, handlerUserCreated, handlerErrorCreateUser);
		}
		
		
		private function handlerUserCreated(request:UserDataProxyRequest):void
		{
			var requestMessage:String = 'SELECT * FROM "main"."user"';
			
			var request:UserDataProxyRequest = new UserDataProxyRequest();
			request.setData(_sqlManager, requestMessage, onRetrieveNewUser, onErrorRetrieveUsersList);
		}
		
		private function onRetrieveNewUser(request:UserDataProxyRequest):void
		{
			if(request)
			{
				if(request.result && request.result.length) 
				{
					createUsersList(request.result);
					_userData = _usersList[_usersList.length - 1];
					
					this.sendNotification( ApplicationEvents.USER_DATA_USER_CREATED);
				}
			}
		}
		
		private function handlerErrorCreateUser(request:UserDataProxyRequest):void
		{
			
		}
		//--------- ----------------- ----------
		
		
		//--------- DELETE USER ----------
		public function deleteUser(userId:uint):void
		{
			var requestMessage:String = 'DELETE FROM "main"."user" WHERE "rowid"=' + _userData.id;
			
			var request:UserDataProxyRequest = new UserDataProxyRequest();
			request.setData(_sqlManager, requestMessage, handlerDeleteComplete, handlerDeleteError);
		}
		
		
		private function handlerDeleteComplete(request:UserDataProxyRequest):void
		{
			this.dispactherLocalEvent( UserDataProxyEvent.USER_DELETE_COMPLETE);
		}
		
		private function handlerDeleteError(request:UserDataProxyRequest):void
		{
			
		}
		//--------- ----------------- ----------
		
		
		
		public function getUserData():UserData
		{
			return _userData;
		}
		
		public function getUsersList():Vector.<UserData>
		{
			return _usersList;
		}
		
		
		public function selectCurrentUser(id:uint):void
		{
			var i:int;
			for(i = 0; i < _usersList.length; i++)
			{
				if(_usersList[i].id == id)
				{
					_userData = _usersList[i];
					break;
				}
			}
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
							
				var requestMessage:String = 'UPDATE "main"."user" SET ' + fields + ' WHERE "rowid"=' + _userData.id;
				
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
					createUsersList(request.result);		
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
			var requestMessage:String = 'INSERT INTO "main"."user" ("name","deviceID","login","pass","exp") VALUES (null, null, null, null, null)';
			
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
		
		
		private function createUsersList(arr:Array):void
		{
			_usersList.length = 0;
			
			var i:int, user:UserData;
			for(i = 0; i < arr.length; i++)
			{
				user = new UserData(arr[i]);
				_usersList.push(user);
			}
		}
	}
}