package org.systemsbiology.gwap2.event
{
	import flash.events.Event;
	
	import org.systemsbiology.gwap2.domain.User;

	public class LoginEvent extends Event
	{
		public var success:Boolean;
		public var user:User;
		public static const LOGIN_ATTEMPT:String = "login_attempt";
		
		public function LoginEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(LOGIN_ATTEMPT, bubbles, cancelable);
		}
		
	}
}