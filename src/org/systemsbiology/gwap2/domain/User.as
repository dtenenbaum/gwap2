package org.systemsbiology.gwap2.domain
{
	import flash.events.EventDispatcher;
	
	public class User extends EventDispatcher
	{
		public static var USERNAME_CHANGE:String = "userNameChange";
		private var _userName:String;
		
		public static const GUEST_USERNAME:String = 'guest';
		public static const GUEST_USER_ID:int = 0;
		
		public var id:int;
		public var password:String;
		public var needNewPassword:Boolean = false;
		
		[Bindable]
		public var userName:String;
		
		/*
		[Bindable(event=USERNAME_CHANGE)]
		public function get userName():String {
			return _userName;
		}
		
		
		public function set userName(value:String):void {
			_userName = value;
			trace("setter for User.userName is being called with new value: " + value);
			dispatchEvent(new Event(USERNAME_CHANGE));
		}
		*/
		
	}
}