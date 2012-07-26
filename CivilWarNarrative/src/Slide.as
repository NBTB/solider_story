package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.SimpleButton;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import UIComponents.AttributionBox;
	import UIComponents.BackButton;
	import UIComponents.BranchButton;
	import UIComponents.ContentBox;
	import UIComponents.PromptBox;
	import UIComponents.TitleBanner;
	/**
	 * A Slide is the basic unit of the interactive narrative. Each Slide is self-contained, and dispatches a SlideEvent to communicate
	 * when an external action is necessary.
	 * @author Robert Cigna
	 */
	public class Slide extends Sprite {
		
		//Constants
		public static const TITLE_TYPE:String = "title";                //Slide "type" attribute for a title slide.
		public static const BODY_TYPE:String = "body";                  //Slide "type" attribute for a body slide.
		public static const ENDING_TYPE:String = "ending";              //Slide "type" attribute for a ending slide.
		
		public static const DECISION_BRANCH:String = "decision";        //Branch "type" attribute for a decision branch.
		public static const RANDOM_BRANCH:String = "random";            //Branch "type" attribute for a random branch.
		public static const CONDITIONAL_BRANCH:String = "conditional";  //Branch "type" attribute for a conditional branch.
		
		public static const ENDING_TEXT:String = "The End";             //The text in the banner on an ending slide.
		
		public static const NORMAL_GRADIENT:Array = [0x0A1433, 0x0F1F4C, 0x293786];
		public static const SELECTED_GRADIENT:Array = [0x425284, 0x3f60bd, 0x636da5];
		
		//These constants define the color filter. It's not perfect, but to make 
		//it any better I think requires a deeper understanding of color theory,
		//so in the mean time, choose a good color first, then decrease its 
		//saturation and increase its luminance to get a good effect.
		public static const COLOR_FILTER_R_BYTE:int = 184;				//The R component of the color filter.
		public static const COLOR_FILTER_G_BYTE:int = 165;				//The G component of the color filter.
		public static const COLOR_FILTER_B_BYTE:int = 135;				//The B component of the color filter.
		public static const COLOR_FILTER_BRIGHTNESS:int = 0;			//The amount to add to each color channel when filtering.
		                                                                //   In general, should be left at zero, unless a washout effect is desired.
		
		//Constructs a ColorMatrixFilter to transform images into sepia tone.
		public static function GetSepiaFilter():ColorMatrixFilter {
			//TODO optimize matrix instancing
			
			//My unscientific correction algorithm increases saturation of a low luminance color.
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
			
			return new ColorMatrixFilter(matrix);
		}
		
		//The slide definition (the machine)
		private var machine:XML;
		
		//Slide properties.
		public var slideName:String;
		public var type:String;
		
		//Visual elements
		private var background:Loader;
		private var banner:TitleBanner;            // only used in TITLE_TYPE or ENDING_TYPE slides, null otherwise.
		private var contentBox:ContentBox;         // only used in BODY_TYPE or ENDING_TYPE slides, null otherwise.
		private var promptBox:PromptBox;           // only used in BODY_TYPE slides, but may not be visible.
		private var attributionBox:AttributionBox;
		private var backbutton:BackButton;
		
		//buttons have side effects of state, so have to be reset every time this frame is entered.
		private var buttons:Array;
		
		
		//Constructs a new Slide using the given definition.
		public function Slide(xml:XML) {
			
			//read definitions
			machine = xml;
			slideName = machine.@name;
			type = machine.@type;
			
			buttons = new Array();
			
			// The background/attribution is uninfluenced by state or slide type
			background = new Loader();
			addChild(background);
			var filters:Array = background.filters;
			filters.push(GetSepiaFilter());
			background.filters = filters;
			background.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			background.load(new URLRequest(machine.Image));
			
			attributionBox = new AttributionBox(530, 395, 216, 75);
			attributionBox.setText(machine.Attribution);
			addChild(attributionBox);
			
			// Ending and Title slides both have a banner.
			if (type == ENDING_TYPE || type == TITLE_TYPE)
			{
				banner = new TitleBanner(0, 120, 766, 80);
				banner.setText(ENDING_TEXT);
				addChild(banner);
			}
			else {
				// Only Body slides can have a prompt
				
				//When a tag isn't present in the XML, it doesn't seem to have a definite value that can be conditioned on. 
				//Assigning it to a string first makes sure that no tags or empty tags both equate to an empty string.
				var prompt:String = machine.Prompt;
				if (prompt != "")
				//{
				//	promptBox.visible = false;
				//}
				//else
				{
					promptBox = new PromptBox(530, 20, 216, 150);
					promptBox.setText(prompt);
					addChild(promptBox);
				}
			}
			
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
			
			//set up only as many buttons as needed
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
		
		private function goBack(e:Event):void {
			dispatchEvent(new SlideEvent(SlideEvent.POP_STATE));
		}
		
		//A method called upon entering this slide. Determines button text/references.
		public function enterSlide(state:Object):void {
			if (state.stacklength == 0)
				backbutton.visible = false;
			
			//for (var l:int = 0; l < buttons.length; l++) {
			//	BranchButton(buttons[l]).reset();
			//	//BranchButton(buttons[i]).mouseEnabled = false;
			//	//BranchButton(buttons[i]).mouseEnabled = true;
			//}
				
			if (type == ENDING_TYPE)
			{
				BranchButton(buttons[0]).setText(BranchButton.DEFAULT_RETURN_TEXT);
				// reference doesn't matter because an ending slide sends a CLEAR_STATE event instead of a CHANGE_SLIDE event.
				return;
			}
			
			var paths:XMLList = machine.Branch.Path;
			
			//set up buttons
			if (machine.Branch.@type == "decision")
			{
				for (var k:int = 0; k < paths.length(); k++)
				{
					BranchButton(buttons[k]).setText(paths[k].Text);
					BranchButton(buttons[k]).reference = paths[k].Reference;
					if (paths[k].Store.length() > 0) {
						BranchButton(buttons[k]).stores = true;
						BranchButton(buttons[k]).key = paths[k].Store.@key;
						BranchButton(buttons[k]).value = paths[k].Store.@value;
					}
				}
			}
			else if (machine.Branch.@type == "random")
			{
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
			else if (machine.Branch.@type == "conditional")
			{
				var j:int = 0;
				var found:Boolean = false;
				
				while (!found && j < paths.length()) {
					if (state[paths[j].@key] == paths[j].@value)
					{
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
				
				if (!found)
				{
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