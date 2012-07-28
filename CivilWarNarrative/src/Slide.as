package  
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.net.URLRequest;
	import VisualElements.AttributionBox;
	import VisualElements.BackButton;
	import VisualElements.BranchButton;
	import VisualElements.ContentBox;
	import VisualElements.PromptBox;
	import VisualElements.TitleBanner;
	/**
	 * A Slide is the basic unit of the interactive narrative. Each Slide is self-contained, and dispatches a SlideEvent to communicate
	 * when an external action is necessary.
	 * @author Robert Cigna
	 */
	public class Slide extends Sprite {
		
		//{ region Constants
		public static const TITLE_TYPE:String = "title";                //Slide "type" attribute for a title slide.
		public static const BODY_TYPE:String = "body";                  //Slide "type" attribute for a body slide.
		public static const ENDING_TYPE:String = "ending";              //Slide "type" attribute for a ending slide.
		
		public static const DECISION_BRANCH:String = "decision";        //Branch "type" attribute for a decision branch.
		public static const RANDOM_BRANCH:String = "random";            //Branch "type" attribute for a random branch.
		public static const CONDITIONAL_BRANCH:String = "conditional";  //Branch "type" attribute for a conditional branch.
		
		public static const ENDING_TEXT:String = "The End";             //The text in the banner on an ending slide.
		
		//These constants define the colors used in the normal and mouse-over color schemes.
		public static const NORMAL_GRADIENT:Array = [0x0A1433, 0x0F1F4C, 0x293786];
		public static const SELECTED_GRADIENT:Array = [0x425284, 0x3f60bd, 0x636da5];
		
		//} endregion
		
		//{ region Color Filter
		
		//These constants define the color filter. It's not perfect, but to make 
		//it any better I think requires a deeper understanding of color theory,
		//so in the mean time, choose a good color first, then decrease its 
		//saturation and increase its luminance to get a good effect.
		public static const COLOR_FILTER_R_BYTE:int = 184;				//The R component of the color filter.
		public static const COLOR_FILTER_G_BYTE:int = 165;				//The G component of the color filter.
		public static const COLOR_FILTER_B_BYTE:int = 135;				//The B component of the color filter.
		public static const COLOR_FILTER_BRIGHTNESS:int = 0;			//The amount to add to each color channel when filtering. In general, should be left at zero, unless a washout effect is desired.
		
		//Cache of the sepia filter to reduce redundancy.
		private static var filter:ColorMatrixFilter = null;
		
		//Constructs a ColorMatrixFilter to transform images into sepia tone.
		public static function GetSepiaFilter():ColorMatrixFilter {
			//TODO verify optimized matrix instancing
			
			if (filter) return filter;
			
			//My unscientific correction equation increases saturation of a low luminance color as a side effect, I think.
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
		private var promptBox:PromptBox;           // only used in BODY_TYPE slides, but not always. null if not in use.
		private var attributionBox:AttributionBox;
		private var backbutton:BackButton;
		
		//Buttons have side effects of state, so have to be reset every time this frame is entered.
		private var buttons:Array;
		
		//} endregion
		
		//Constructs a new Slide using the given definition.
		public function Slide(xml:XML) {
			
			//Read definitions
			machine = xml;
			slideName = machine.@name;
			type = machine.@type;
			
			
			//Set up graphic elements
			
			//Background.
			background = new Loader();
			addChild(background);
			var filters:Array = background.filters;
			filters.push(GetSepiaFilter());
			background.filters = filters;
			background.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			background.load(new URLRequest(machine.Image));
			
			//Attribution Box.
			attributionBox = new AttributionBox(530, 395, 216, 75);
			attributionBox.setText(machine.Attribution);
			addChild(attributionBox);
			
			//Banner. Only used by Title and Ending slides.
			if (type == ENDING_TYPE || type == TITLE_TYPE) {
				banner = new TitleBanner(0, 120, 766, 80);
				banner.setText(ENDING_TEXT);
				addChild(banner);
			}
			
			//Prompt Box. Conversely, only used (when necessary) by Boy slides.
			else {
				//When a tag isn't present in the XML, it doesn't seem to have a definite value that can be conditioned on. 
				//Assigning it to a string first makes sure that no tags or empty tags both equate to an empty string.
				var prompt:String = machine.Prompt;
				if (prompt != "") {
					promptBox = new PromptBox(530, 20, 216, 150);
					promptBox.setText(prompt);
					addChild(promptBox);
				}
			}
			
			//Set Content.
			if (type == TITLE_TYPE) {
				banner.setText(machine.Content);
			}
			else {
				if (type == BODY_TYPE) {
					contentBox = new ContentBox(35, 20, 475, 450);5
				}
				else {
					contentBox = new ContentBox(35, 300, 475, 170);
				}
				contentBox.setText(machine.Content);
				addChild(contentBox);
				
			}
			
			//Buttons (only as many as needed).
			buttons = new Array();
			if (machine.Branch.@type == DECISION_BRANCH) {
				for (var i:int = 0; i < machine.Branch.Path.length(); i++)
				{
					buttons.push(new BranchButton(530, 395 - 50 * (machine.Branch.Path.length() - i), 216, 30));
					BranchButton(buttons[i]).addEventListener(MouseEvent.CLICK, passAlong);
					addChild(buttons[i]);
				}
			}
			else {
				buttons.push(new BranchButton(530, 345, 216, 30));
				BranchButton(buttons[0]).addEventListener(MouseEvent.CLICK, passAlong);
				addChild(buttons[0]);
			}
			
			//Back Button.
			backbutton = new BackButton(10, 20, 15, 30);
			backbutton.addEventListener(MouseEvent.CLICK, goBack);
			addChild(backbutton);
		}
		
		//For whatever reason, these must be set after loading is complete.
		private function loadComplete(event:Event):void {
			//TODO: determine final stage size
			background.x = 0;
			background.y = 0;
			background.width = 766;
			background.height = 450;
			background.cacheAsBitmap = true;
			dispatchEvent(new SlideEvent(SlideEvent.LOAD_COMPLETE));
		}
		
		//An event listener for branch button clicks. Responsible for dispatching CLEAR_STATE, STORE_KEY, and CHANGE_SLIDE as necessary.
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
		
		//Event listener for back button clicks.
		private function goBack(e:Event):void {
			dispatchEvent(new SlideEvent(SlideEvent.POP_STATE));
		}
		
		//Because the ultimate appearance of a slide includes side-effects of state, this must be 
		//called to make sure the current appearace of a slide reflects the current state.
		public function enterSlide(state:Object):void {
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
			
			var paths:XMLList = machine.Branch.Path;
			
			//Set up a decision branch
			if (machine.Branch.@type == DECISION_BRANCH) {
				for (var k:int = 0; k < paths.length(); k++) {
					BranchButton(buttons[k]).setText(paths[k].Text);
					BranchButton(buttons[k]).reference = paths[k].Reference;
					if (paths[k].Store.length() > 0) {
						BranchButton(buttons[k]).stores = true;
						BranchButton(buttons[k]).key = paths[k].Store.@key;
						BranchButton(buttons[k]).value = paths[k].Store.@value;
					}
				}
			}
			
			//Set up a random branch
			else if (machine.Branch.@type == RANDOM_BRANCH) {
				var sum:Number = 0;
				var i:int = 0;
				for (; i < paths.length(); i++) {
					//trace(paths[i].Weight);
					sum += Number(paths[i].Weight); 
				}
				
				var num:Number = Math.random() * sum;
				sum = 0; i = -1;
				
				while (sum < num && i < paths.length() - 1) {
					i++;
					sum += Number(paths[i].Weight);
				}
				
				BranchButton(buttons[0]).setText(BranchButton.DEFAULT_TEXT);
				BranchButton(buttons[0]).reference = paths[i].Reference;
				
				if (paths[i].Store.length() > 0)
				{
					BranchButton(buttons[0]).stores = true;
					BranchButton(buttons[0]).key = paths[i].Store.@key;
					BranchButton(buttons[0]).value = paths[i].Store.@value;
				}
			}
			
			//Set up a conditional branch
			else if (machine.Branch.@type == CONDITIONAL_BRANCH) {
				var j:int = 0;
				var found:Boolean = false;
				
				while (!found && j < paths.length()) {
					if (state[paths[j].@key] == paths[j].@value) {
						found = true;
						
						BranchButton(buttons[0]).setText(BranchButton.DEFAULT_TEXT);
						BranchButton(buttons[0]).reference = paths[j].Reference;
						
						//theoretically useless, but whatever. I guess in very certain circumstances it could add something.
						if (paths[j].Store.length() > 0)
						{
							BranchButton(buttons[0]).stores = true;
							BranchButton(buttons[0]).key = paths[j].Store.@key;
							BranchButton(buttons[0]).value = paths[j].Store.@value;
						}
					}
					j++;
				}
				
				//fall back onto the "Default" tags.
				if (!found) {
					BranchButton(buttons[0]).setText(BranchButton.DEFAULT_TEXT);
					BranchButton(buttons[0]).reference = machine.Branch.Default.Reference;
					if (machine.Branch.Default.Store.length() > 0)
					{
						BranchButton(buttons[0]).stores = true;
						BranchButton(buttons[0]).key = machine.Branch.Default.Store.@key;
						BranchButton(buttons[0]).value = machine.Branch.Default.Store.@value;
					}
				}
			}
			//TODO: implement error fall-through
		}
	}

}