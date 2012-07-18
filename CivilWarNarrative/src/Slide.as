package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.SimpleButton;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	/**
	 * ...
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
		
		
		// The slide definition (the machine)
		private var machine:XML;
		
		public var slideName:String;
		public var type:String;
		
		private var background:Loader;
		
		private var buttons:Array;
		
		//placeholders
		private var banner:TextField;
		private var bannerFormat:TextFormat;
		
		private var mainText:TextField;
		private var mainFormat:TextFormat;
		
		private var promptText:TextField;
		private var promptFormat:TextFormat;
		
		private var attribution:TextField;
		private var attrFormat:TextFormat;
		
		//Constructs a new Slide using the given definition.
		public function Slide(xml:XML) {
			
			//read definitions
			machine = xml;
			slideName = machine.@name;
			type = machine.@type;
			buttons = new Array();
			
			//the background/attribution is uninfluenced by state or slide type
			background = new Loader();
			addChild(background);
			background.contentLoaderInfo.addEventListener(Event.COMPLETE, showBackground);
			background.load(new URLRequest(machine.Image));
			
			attrFormat = new TextFormat();
			attrFormat.size = 9;
			attrFormat.font = "Arial";
			attrFormat.color = 0xFFFFFF;
			attrFormat.align = TextFormatAlign.RIGHT;
			
			attribution = new TextField();
			attribution.defaultTextFormat = attrFormat;
			attribution.x = 530;
			attribution.y = 395;
			attribution.width = 216;
			attribution.height = 75;
			attribution.border = true;
			attribution.wordWrap = true;
			attribution.text = machine.Attribution;
			addChild(attribution);
			
			
			if (type == ENDING_TYPE || type == TITLE_TYPE)
			{
				bannerFormat = new TextFormat();
				bannerFormat.size = 48;
				bannerFormat.color = 0xFFFFFF;
				bannerFormat.font = "Arial";
				bannerFormat.align = TextFormatAlign.CENTER;
				
				banner = new TextField();
				banner.defaultTextFormat = bannerFormat;
				banner.x = 0;
				banner.y = 120;
				banner.width = 766;
				banner.height = 80;
				banner.border = true;
				banner.cacheAsBitmap = true;
				banner.text = ENDING_TEXT;
				addChild(banner);
			}
			else {
					
				promptFormat = new TextFormat();
				promptFormat.font = "Arial";
				promptFormat.color = 0xFFFFFF;
				promptFormat.size = 12;
				
				promptText = new TextField();
				promptText.defaultTextFormat = promptFormat;
				promptText.x = 530;
				promptText.y = 20;
				promptText.width = 216;
				promptText.height = 150;
				promptText.border = true;
				promptText.wordWrap = true;
				
				if (machine.Prompt == "" || machine.Prompt == null)
				{
					promptText.visible = false;
				}
				else
				{
					promptText.text = machine.Prompt;
				}
				
				addChild(promptText);
			}
			
			if (type == TITLE_TYPE) {
				banner.text = machine.Content;
			}
			else {
				mainFormat = new TextFormat();
				mainFormat.size = 12;
				mainFormat.color = 0xFFFFFF;
				mainFormat.font = "Arial";
				
				mainText = new TextField();
				mainText.defaultTextFormat = mainFormat;
				if (type == BODY_TYPE)
				{
					mainText.y = 20;
					mainText.height = 450;
				}
				else
				{
					mainText.y = 300;
					mainText.height = 170;
				}
				mainText.x = 20;
				mainText.width = 490;
				mainText.border = true;
				mainText.wordWrap = true;
				mainText.cacheAsBitmap = true;
				mainText.text = machine.Content;
				addChild(mainText);
				
			}
			
			//set up only as many buttons as needed
			if (machine.Branch.@type == DECISION_BRANCH) {
				for (var i:int = 0; i < machine.Branch.Path.length(); i++)
				{
					buttons.push(new BranchButton());
					BranchButton(buttons[i]).x = 530;
					BranchButton(buttons[i]).y = 395 - 50 * (machine.Branch.Path.length() - i);
					BranchButton(buttons[i]).addEventListener(MouseEvent.CLICK, passAlong);
					addChild(buttons[i]);
				}
			}
			else {
				buttons.push(new BranchButton());
				BranchButton(buttons[0]).x = 530;
				BranchButton(buttons[0]).y = 345;
				BranchButton(buttons[0]).addEventListener(MouseEvent.CLICK, passAlong);
				addChild(buttons[0]);
			}
		}
		
		//For whatever reason, these must be set after loading is complete.
		private function showBackground(event:Event):void {
			background.x = 0;
			background.y = 0;
			background.width = 766;
			background.height = 450;
		}
		
		//An event listener for button clicks. Responsible for dispatching CLEAR_STATE, STORE_KEY, and CHANGE_CLIDE as necessary.
		private function passAlong(event:Event):void {
			if (type == ENDING_TYPE) {
				dispatchEvent(new SlideEvent(SlideEvent.CLEAR_STATE));
				return;
			}
			
			if (BranchButton(event.target).stores) {
				var store:SlideEvent = new SlideEvent(SlideEvent.STORE_KEY, BranchButton(event.target).value, BranchButton(event.target).key);
				dispatchEvent(store);
			}
			
			var change:SlideEvent = new SlideEvent(SlideEvent.CHANGE_SLIDE, BranchButton(event.target).reference);
			dispatchEvent(change);
		}
		
		//A method called upon entering this slide. Determines button text/references.
		public function enterSlide(state:Object):void {
			
			if (type == ENDING_TYPE)
			{
				BranchButton(buttons[0]).setText(BranchButton.DEFAULT_RETURN_TEXT);
				//Reference doesn't matter because an ending slide sends a CLEAR_STATE event instead of a CHANGE_SLIDE event.
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
						
						//theoretically useless, but whatever.
						if (paths[j].Store.length() > 0)
						{
							BranchButton(buttons[0]).stores = true;
							BranchButton(buttons[0]).key = paths[j].Store.@key;
							BranchButton(buttons[0]).value = paths[j].Store.@value;
						}
					}
					j++;
				}
				
				//TODO: implement default behavior.
				if (!found)
				{
					
				}
			}
		}
	}

}