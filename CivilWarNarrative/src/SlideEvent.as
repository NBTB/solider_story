package  
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class SlideEvent extends Event
	{
		public static const CHANGE_SLIDE:String = "changeslide";    // Dispatched by a slide in response to a BranchButton being clicked.
		public static const STORE_KEY:String = "storekey";          // Dispatched by a slide in response to a BranchButton being clicked, if the button needs to store a key/value.
		public static const CLEAR_STATE:String = "clearstate";      // Dispatched by an ending slide when the user clicks "return". Signals state should be cleared and returned to the entry slide.
		
		public var key:String;   // Key used in a STORE_KEY command. Unused for CHANGE_SLIDE or CLEAR_STATE.
		public var value:String; // Value to store under key in STORE_KEY event, or slide to change to for CHANGE_SLIDE event
		
		public function SlideEvent(type:String, value:String = null, key:String = null) 
		{
			super(type);
			this.value = value;
			this.key = key;
		}
	}

}