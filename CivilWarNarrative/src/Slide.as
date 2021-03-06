package  
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import VisualElements.AttributionBox;
	import VisualElements.BackButton;
	import VisualElements.BranchButton;
	import VisualElements.ContentBox;
	import VisualElements.HideButton;
	import VisualElements.TitleBanner;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	/**
	 * A Slide is the basic unit of the interactive narrative. Each Slide is self-contained, and dispatches a SlideEvent to communicate
	 * when an external action is necessary.
	 * @author Robert Cigna
	 */
	public class Slide extends Sprite {
		
		//{ region Constants
		/**
		 * Slide "type" attribute for a title slide.
		 */
		public static const TITLE_TYPE:String = "title";
		/**
		 * Slide "type" attribute for a body slide.
		 */
		public static const BODY_TYPE:String = "body";
		/**
		 * Slide "type" attribute for a ending slide.
		 */
		public static const ENDING_TYPE:String = "ending";
		
		/**
		 * Branch "type" attribute for a decision branch.
		 */
		public static const DECISION_BRANCH:String = "decision";
		/**
		 * Branch "type" attribute for a random branch.
		 */
		public static const RANDOM_BRANCH:String = "random"; 
		/**
		 * Branch "type" attribute for a conditional branch.
		 */
		public static const CONDITIONAL_BRANCH:String = "conditional";
		
		/**
		 * The text in the banner on an ending slide.
		 */
		public static const ENDING_TEXT:String = "The End";
		
		/**
		 * The normal color gradient, from top to bottom.
		 */
		public static const NORMAL_GRADIENT:Array = [0x0A1433, 0x0F1F4C, 0x293786];
		/**
		 * The color gradient, from top to bottom, of selected or highlighted elements.
		 */
		public static const SELECTED_GRADIENT:Array = [0x425284, 0x3f60bd, 0x636da5];
		
		//} endregion
		
		//{ region Color Filter
		
		//These constants define the color filter. It's not perfect, but to make 
		//it any better I think requires a deeper understanding of color theory,
		//so in the mean time, choose a good color first, then decrease its 
		//saturation and increase its luminance to get a good effect.
		
		/**
		 * The R component of the color filter.
		 */
		public static const COLOR_FILTER_R_BYTE:int = 184;
		/**
		 * The G component of the color filter.
		 */
		public static const COLOR_FILTER_G_BYTE:int = 165;
		/**
		 * The B component of the color filter.
		 */
		public static const COLOR_FILTER_B_BYTE:int = 135;
		/**
		 * The amount to add to each color channel when filtering. 
		 * In general, this is best left at zero, unless a washout effect is desired.
		 */
		public static const COLOR_FILTER_BRIGHTNESS:int = 0;	
		
		/**
		 * Cache of the sepia filter to reduce redundancy.
		 */
		private static var filter:ColorMatrixFilter = null;
		
		/**
		 * Whether the interface elements are currently hidden or visible
		 */		
		private static var elements_visible:Boolean = true;
		
		/**
		 * Constructs a ColorMatrixFilter to transform images into sepia tone.
		 * @return A sepia ColorMatrixFilter.
		 */
		public static function GetSepiaFilter():ColorMatrixFilter {
			if (filter) return filter;
			
			//My unscientific correction equation increases saturation of a low luminance color as a side effect, I think...
			var correction:Number = 765 / (COLOR_FILTER_B_BYTE + COLOR_FILTER_G_BYTE + COLOR_FILTER_R_BYTE);
			
			//original I found online -- kind of a creamy salmon color.
			//var matrix:Array = [ .393, .769, .189, 0, 0,
			//					 .349, .686, .131, 0, 0,
			//					 .272, .534, .168, 0, 0,
			//					 0, 0, 0, 1, 0];
			
			//my first try -- dark brown. Good constrast, but makes images dull. Quite close to the paper prototype, though.
			//var matrix:Array = [ .234, .468, .074, 0, 0,
			//					 .222, .444, .074, 0, 0,
			//					 .214, .428, .071, 0, 0,
			//					 0,    0,    0,    1, 0];
			
			//my second try -- increased saturation, acceptable contrast. Brighter than Word's sepia filter to boot.
			//var matrix:Array = [ .351, .702, .111, 0, 0,
			//					 .334, .667, .111, 0, 0,
			//					 .321, .642, .107, 0, 0,
			//					 0,    0,    0,    1, 0];
			
			var matrix:Array = [ correction * .25 * COLOR_FILTER_R_BYTE / 255, correction * .7 * COLOR_FILTER_R_BYTE / 255, correction * .05 * COLOR_FILTER_R_BYTE / 255, 0, COLOR_FILTER_BRIGHTNESS,
								 correction * .25 * COLOR_FILTER_G_BYTE / 255, correction * .7 * COLOR_FILTER_G_BYTE / 255, correction * .05 * COLOR_FILTER_G_BYTE / 255, 0, COLOR_FILTER_BRIGHTNESS,
								 correction * .25 * COLOR_FILTER_B_BYTE / 255, correction * .7 * COLOR_FILTER_B_BYTE / 255, correction * .05 * COLOR_FILTER_B_BYTE / 255, 0, COLOR_FILTER_BRIGHTNESS,
								 0,    0,    0,    1, 0];
			
			filter = new ColorMatrixFilter(matrix);
			return filter;
		}
		
		//} endregion
		
		//{ region Instance Variables
		
		//The slide definition (the machine)
		private var machine:XML;
		
		//Slide properties.
		private var slideName:String;
		public function get SlideName():String { return slideName; }
		private var type:String;
		public function get Type():String { return type; }
		
		//Visual elements
		private var background:Loader;
		private var banner:TitleBanner;            // only used in TITLE_TYPE or ENDING_TYPE slides, null otherwise.
		private var contentBox:ContentBox;         // only used in BODY_TYPE or ENDING_TYPE slides, null otherwise.
		private var promptBox:ContentBox;           // only used in BODY_TYPE slides, but not always. null if not in use.
		private var attributionBox:AttributionBox;
		private var backbutton:BackButton;
		private var hidebutton:Sprite;
		
		//Buttons have side effects of state, so have to be reset every time this frame is entered.
		private var buttons:Array;
		
		//Create an array of visual elements we want to be able to hide
		private var elements:Array;
		
		//} endregion
		
		/**
		 * Constructs a new Slide using the given definition.
		 * @param	xml The XML defining the slide.
		 * @param	images An associative array of images, with filename being the key.
		 */
		public function Slide(xml:XML, images:Object) {
			//Read definitions
			machine = xml;
			slideName = machine.@name;
			type = machine.@type;
			
			trace("Constructing slide \"" + slideName + "\"...");
			
			
			//Set up graphic elements
			
			//Background.
			background = new Loader(); 
			background.contentLoaderInfo.addEventListener(Event.COMPLETE, setBkgSize);
			background.loadBytes(Loader(images[machine.Image]).contentLoaderInfo.bytes);
			addChild(background);
			var filters:Array = background.filters;
			filters.push(GetSepiaFilter());
			background.filters = filters;
			
			//Initialize elements array
			elements = new Array();
			
			//Attribution Box.
			attributionBox = new AttributionBox(554, 480, 250, 100);
			attributionBox.setText(machine.Attribution, handleTextSize(machine.Attribution));
			elements.push(attributionBox);
			addChild(attributionBox);
			
			//Banner. Only used by Title and Ending slides.
			if (type == ENDING_TYPE || type == TITLE_TYPE) {
				banner = new TitleBanner(0, 160, 800, 80);
				banner.setText(ENDING_TEXT);
				elements.push(banner);
				addChild(banner);
			}
			
			//Prompt Box. Conversely, only used (when necessary) by Body slides.
			else {
				//When a tag isn't present in the XML, it doesn't seem to have a definite value that can be conditioned on. 
				//Assigning it to a string first makes sure that no tags or empty tags both equate to an empty string.
				var prompt:String = machine.Prompt;
				if (prompt != "") {
					promptBox = new ContentBox(554, 20, 216, 150);
					promptBox.setText(prompt);
					elements.push(promptBox);
					addChild(promptBox);
				}
			}
			
			//Set Content.
			if (type == TITLE_TYPE) {
				banner.setText(machine.Content);
			}
			else {
				if (type == BODY_TYPE) {
					contentBox = new ContentBox(35, 20, 475, 535);
				}
				else {
					contentBox = new ContentBox(35, 360, 475, 170);
				}
				contentBox.setText(machine.Content);
				elements.push(contentBox);
				addChild(contentBox);
				
			}
			
			//Buttons (only as many as needed).
			buttons = new Array();
			
			if (machine.Branch.@type == DECISION_BRANCH && type != ENDING_TYPE) {
				//Number of paths limited to 4; defined as Path1, Path2, etc.
				var num:int = 0;
				if (exists(machine.Branch.Path1)) num++;
				if (exists(machine.Branch.Path2)) num++;
				if (exists(machine.Branch.Path3)) num++;
				if (exists(machine.Branch.Path4)) num++;
				
				for (var i:int = 0; i < num; i++)
				{
					buttons.push(new BranchButton(554, 465 - 50 * (num - i), 216, 30));
					BranchButton(buttons[i]).addEventListener(MouseEvent.CLICK, passAlong);
					elements.push(buttons[i]);
					addChild(buttons[i]);
				}
			}
			else {
				buttons.push(new BranchButton(554, 415, 216, 30));
				BranchButton(buttons[0]).addEventListener(MouseEvent.CLICK, passAlong);
				elements.push(buttons[0]);
				addChild(buttons[0]);
			}
			
			//Back Button.
			backbutton = new BackButton(10, 20, 15, 30);
			backbutton.addEventListener(MouseEvent.CLICK, goBack);
			elements.push(backbutton);
			addChild(backbutton);
			
			//"Hide Button", hover to hide screen elements
			hidebutton = new HideButton(0, 524, 150, 50);
			hidebutton.addEventListener(MouseEvent.CLICK, hideShowElements);
			addChild(hidebutton);
		}
		
		private function hideShowElements(e:MouseEvent):void {
			var targetAlpha:int;
			if (Slide.elements_visible) {
				targetAlpha = 0;
				e.target.setText("Show Interface");
				Slide.elements_visible = false;
			}
			else {
				targetAlpha = 1;
				e.target.setText("Hide Interface");
				Slide.elements_visible = true;
			}
			for (var i:int = 0; i < elements.length ; i++) {
				TweenLite.to(elements[i], 0.5, { alpha:targetAlpha, ease:Sine.easeInOut } );
			}
		}
		
		private function setBkgSize(event:Event):void {
			background.width = 800;
			background.height = 575;
		}
		
		/**
		 * An event listener for branch button clicks. Responsible for dispatching CLEAR_STATE, STORE_KEY, and CHANGE_SLIDE as necessary.
		 * @param	event
		 */
		private function passAlong(event:Event):void {
			if (type == ENDING_TYPE) {
				dispatchEvent(new SlideEvent(SlideEvent.CLEAR_STATE));
				return;
			}
			
			dispatchEvent(new SlideEvent(SlideEvent.PUSH_STATE));
			
			if (BranchButton(event.target).stores) {
				var store:SlideEvent = new SlideEvent(SlideEvent.STORE_KEY, BranchButton(event.target).value, BranchButton(event.target).key);
				dispatchEvent(store);
			}
			
			var change:SlideEvent = new SlideEvent(SlideEvent.CHANGE_SLIDE, BranchButton(event.target).reference);
			dispatchEvent(change);
		}
		
		/**
		 * Event listener for back button clicks.
		 * @param	e
		 */
		private function goBack(e:Event):void {
			dispatchEvent(new SlideEvent(SlideEvent.POP_STATE));
		}
		
		/**
		 * Because the ultimate appearance of a slide includes side-effects of state, this must be 
		 * called to make sure the current appearace of a slide reflects the current state.
		 * @param	state The current state object.
		 */
		public function enterSlide(state:Object):void {
			trace("Setting up buttons for \"" + slideName +"\"...");
			
			//This slide may have been visible at some point -- if so, 
			//the buttons may have retained an "over" state and need to be reset
			backbutton.reset();
			for (var b:int = 0; b < buttons.length; b++) {
				BranchButton(buttons[b]).reset();
			}
			
			//Make back button invisible if the user cannot go back.
			if (state.stacklength == 0) {
				backbutton.visible = false;
			}
			
			//Decide on and set button text and references.
			
			//Ending slides have special rules and a single button with default text on it.
			if (type == ENDING_TYPE) {
				BranchButton(buttons[0]).setText(BranchButton.DEFAULT_RETURN_TEXT);
				//reference doesn't matter because an ending slide sends a CLEAR_STATE event instead of a CHANGE_SLIDE event.
				return;
			}
			
			//Set up a decision branch
			if (machine.Branch.@type == DECISION_BRANCH) {
				var index:int = 0;
				if (exists(machine.Branch.Path1)) {
					setPath(BranchButton(buttons[index]), machine.Branch.Path1);
					index++;
				}
				if (exists(machine.Branch.Path2)) {
					setPath(BranchButton(buttons[index]), machine.Branch.Path2);
					index++;
				}
				if (exists(machine.Branch.Path3)) {
					setPath(BranchButton(buttons[index]), machine.Branch.Path3);
					index++;
				}
				if (exists(machine.Branch.Path4)) {
					setPath(BranchButton(buttons[index]), machine.Branch.Path4);
					index++;
				}
			}
			
			//Set up a random branch
			else if (machine.Branch.@type == RANDOM_BRANCH) {
				var sum:Number = 0;
				if (exists(machine.Branch.Path1)) {
					sum += Number(machine.Branch.Path1.@weight);
				}
				if (exists(machine.Branch.Path2)) {
					sum += Number(machine.Branch.Path2.@weight);
				}
				if (exists(machine.Branch.Path3)) {
					sum += Number(machine.Branch.Path3.@weight);
				}
				if (exists(machine.Branch.Path4)) {
					sum += Number(machine.Branch.Path4.@weight);
				}
				
				var pick:Number = Math.random() * sum;
				sum = 0;
				var done:Boolean = false;
				
				if (!done && exists(machine.Branch.Path1)) {
					sum += Number(machine.Branch.Path1.@weight);
					if (sum >= pick) {
						setPath(BranchButton(buttons[0]), machine.Branch.Path1, true);
						done = true;
					}
				}
				if (!done && exists(machine.Branch.Path2)) {
					sum += Number(machine.Branch.Path2.@weight);
					if (sum >= pick) {
						setPath(BranchButton(buttons[0]), machine.Branch.Path2, true);
						done = true;
					}
				}
				if (!done && exists(machine.Branch.Path3)) {
					sum += Number(machine.Branch.Path3.@weight);
					if (sum >= pick) {
						setPath(BranchButton(buttons[0]), machine.Branch.Path3, true);
						done = true;
					}
				}
				if (!done && exists(machine.Branch.Path4)) {
					sum += Number(machine.Branch.Path4.@weight);
					if (sum >= pick) {
						setPath(BranchButton(buttons[0]), machine.Branch.Path4, true);
						done = true;
					}
				}
				
				
			}
			
			//Set up a conditional branch
			else if (machine.Branch.@type == CONDITIONAL_BRANCH) {
				if (exists(machine.Branch.Path1) && matchesCondition(machine.Branch.Path1, state)) {
					setPath(BranchButton(buttons[0]), machine.Branch.Path1, true);
				}
				else if (exists(machine.Branch.Path2) && matchesCondition(machine.Branch.Path2, state)) {
					setPath(BranchButton(buttons[0]), machine.Branch.Path2, true);
				}
				else if (exists(machine.Branch.Path3) && matchesCondition(machine.Branch.Path3, state)) {
					setPath(BranchButton(buttons[0]), machine.Branch.Path3, true);
				}
				else if (exists(machine.Branch.Path4) && matchesCondition(machine.Branch.Path4, state)) {
					setPath(BranchButton(buttons[0]), machine.Branch.Path4, true);
				}
				else {
					setPath(BranchButton(buttons[0]), machine.Branch.Default, true);
				}
			}
			
			//TODO: implement error fall-through
		}
		
		/**
		 * A helper function for determining if a path tag is defined.
		 * @param	path The XML containing of the path.
		 * @return  true if the path is defined, false otherwise.
		 */
		private function exists(path:XMLList):Boolean {
			return path.Reference != "";
		}
		
		/**
		 * A helper function for setting up the appropriate fields to make a button useful.
		 * @param	button A reference to the button.
		 * @param	path The XML containing the path.
		 * @param	useDefaultText If true, uses the BranchButton.DEFAULT_TEXT as the label on the button.
		 */
		private function setPath(button:BranchButton, path:XMLList, useDefaultText:Boolean = false):void {
			if (useDefaultText) {
				button.setText(BranchButton.DEFAULT_TEXT);
			}
			else {
				button.setText(path.Text);
			}
			button.reference = path.Reference;
			
			if (path.Store.@*.length() > 0)
			{
				button.stores = true;
				button.key = path.Store.@key;
				button.value = path.Store.@value;
			}
		}
		
		/**
		 * A helper function for determining if a path's condition is valid for conditional branching.
		 * @param	path The XML defining the path.
		 * @param	state The current state object.
		 * @return true if the conditions are met, false otherwise.
		 */
		private function matchesCondition(path:XMLList, state:Object):Boolean {
			return state[path.@key] == path.@value;
		}
		
		private function handleTextSize(text:String):int {
			var chars:int = text.length;
			switch(true) {
				case(chars > 200):
					return 12;
				case(chars > 100 && chars <= 200):
					return 14;
				default:
					return 20;
			}
			return 12;
		}
	}
}