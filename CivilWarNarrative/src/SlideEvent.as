package  
{
	import flash.events.Event;
	/**
	 * A type of Event used to communicate all Slide-specific Actions.
	 * @author Robert Cigna
	 */
	public class SlideEvent extends Event
	{
		public static const CHANGE_SLIDE:String = "changeslide";    // Dispatched by a slide in response to a BranchButton being clicked.
		public static const STORE_KEY:String = "storekey";          // Dispatched by a slide in response to a BranchButton being clicked, if the button needs to store a key/value.
		public static const CLEAR_STATE:String = "clearstate";      // Dispatched by an ending slide when the user clicks "return". Signals state should be cleared and returned to the entry slide.
		public static const POP_STATE:String = "popstate";          // Dispatched by a slide when the user clicks the backwards traversal button.
		public static const PUSH_STATE:String = "pushstate";        // Dispatched by a slide just before dispatching state-changing events, so that the curent state can be preserved.
		public static const LOAD_COMPLETE:String = "loadcomplete";  // Dispatched by a slide when it has finished loading content and is ready to be displayed.
		
		public var key:String;   // Key used in a STORE_KEY command. Unused for other types.
		public var value:String; // Value to store under key in STORE_KEY event, or slide to change to for CHANGE_SLIDE event. Not used for other types.
		
		/**
		 * Constructs a new SlideEvent.
		 * @param	type The type of SlideEvent. Use the constants defined in this class.
		 * @param	value For STORE_KEY and CHANGE_SLIDE events, contains extra payload.
		 * @param	key For STORE_KEY events, contains extra payload.
		 */
		public function SlideEvent(type:String, value:String = null, key:String = null) 
		{
			super(type);
			this.value = value;
			this.key = key;
		}
	}

}