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
		public static const TITLE_TYPE:String = "title";          //"type" attribute for a title slide.
		public static const BODY_TYPE:String = "body";            //"type" attribute for a body slide.
		public static const ENDING_TYPE:String = "ending";        //"type" attribute for a ending slide.
		
		public static const DECISION_BRANCH:String = "decision";        //"type" attribute for a decision branch.
		public static const RANDOM_BRANCH:String = "random";            //"type" attribute for a random branch.
		public static const CONDITIONAL_BRANCH:String = "conditional";  //"type" attribute for a conditional branch.
		
		
		// The slide definition (the machine)
		private var machine:XML;
		
		public var slideName:String;
		public var type:String;
		
		private var background:Loader;
		
		//placeholders
		private var mainText:TextField;
		private var mainFormat:TextFormat;
		
		private var promptText:TextField;
		private var promptFormat:TextFormat;
		
		private var attribution:TextField;
		private var attrFormat:TextFormat;
		
		private var button1:BranchButton;
		private var button2:BranchButton;
		private var button3:BranchButton;
		
		//Constructs a new Slide using the given definition.
		public function Slide(xml:XML) {
			
			//read definitions
			machine = xml;
			slideName = machine.@name;
			type = machine.@type;
			
			//the background is uninfluenced by state
			background = new Loader();
			addChild(background);
			background.contentLoaderInfo.addEventListener(Event.COMPLETE, showBackground);
			background.load(new URLRequest(machine.Image));
			
			
			//set up placeholder graphics
			mainFormat = new TextFormat();
			mainFormat.size = 12;
			mainFormat.color = 0xFFFFFF;
			mainFormat.font = "Arial";
			
			mainText = new TextField();
			mainText.defaultTextFormat = mainFormat;
			mainText.x = 20;
			mainText.y = 20;
			mainText.width = 490;
			mainText.height = 450;
			mainText.border = true;
			mainText.wordWrap = true;
			mainText.cacheAsBitmap = true;
			mainText.text = "Your text here!\nNewline?\nWhy, yes, it is. It is single-spaced, however.";
			addChild(mainText);
			
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
			promptText.text = "Placeholding text";
			addChild(promptText);
			
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
			attribution.text = "Attribution";
			addChild(attribution);
			
			button1 = new BranchButton();
			button1.visible = false;
			button1.addEventListener(MouseEvent.CLICK, passAlong);
			addChild(button1);
			
			button2 = new BranchButton();
			button2.visible = false;
			button2.addEventListener(MouseEvent.CLICK, passAlong);
			addChild(button2);
			
			button3 = new BranchButton();
			button3.visible = false;
			button3.addEventListener(MouseEvent.CLICK, passAlong);
			addChild(button3);
			
			attribution.text = machine.Attribution;
			
			mainText.text = xml.Content;
			
			//prompt box
			if (xml.Prompt == "")
			{
				promptText.visible = false;
			}
			else
			{
				promptText.text = xml.Prompt;
			}
			
			
		}
		
		//For whatever reason, these must be set after loading is complete.
		private function showBackground(event:Event):void {
			background.x = 0;
			background.y = 0;
			background.width = 766;
			background.height = 450;
		}
		
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
		
		public function enterSlide(state:Object):void {
			
			if (type == ENDING_TYPE)
			{
				button1.setText(BranchButton.DEFAULT_TEXT);
				button1.x = 530;
				button1.y = 345;
				button1.visible = true;
				
				button2.visible = false;
				button3.visible = false;
				return;
			}
			
			var paths:XMLList = machine.Branch.Path;
			
			//set up buttons
			if (machine.Branch.@type == "decision")
			{
				if (paths.length() >= 1 )
				{
					button1.setText(paths[0].Text);
					button1.reference = paths[0].Reference;
					button1.x = 530;
					button1.y = 345;
					if (paths[0].Store.length() > 0)
					{
						button1.stores = true;
						button1.key = paths[0].Store.@key;
						button1.value = paths[0].Store.@value;
					}
					button1.visible = true;
				}
				else
					button1.visible = false;
					
				if (paths.length() >= 2 )
				{
					button2.setText(paths[1].Text);
					button2.reference = paths[1].Reference;
					button2.x = 530;
					button2.y = 295;
					if (paths[1].Store.length() > 0)
					{
						button2.stores = true;
						button2.key = paths[1].Store.@key;
						button2.value = paths[1].Store.@value;
					}
					button2.visible = true;
				}
				else
					button2.visible = false;
					
				if (paths.length() >= 3 )
				{
					button3.setText(paths[2].Text);
					button3.reference = paths[2].Reference;
					button3.x = 530;
					button3.y = 245;
					if (paths[2].Store.length() > 0)
					{
						button3.stores = true;
						button3.key = paths[2].Store.@key;
						button3.value = paths[2].Store.@value;
					}
					button3.visible = true;
				}
				else
					button3.visible = false;
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
				
				button1.setText(BranchButton.DEFAULT_TEXT);
				button1.reference = paths[i].Reference;
				button1.x = 530;
				button1.y = 345;
				
				if (paths[i].Store.length() > 0)
				{
					button1.stores = true;
					button1.key = paths[i].Store.@key;
					button1.value = paths[i].Store.@value;
				}
				
				button1.visible = true;
				
				button2.visible = false;
				button3.visible = false;
			}
			else if (machine.Branch.@type == "conditional")
			{
				var j:int = 0;
				var found:Boolean = false;
				
				while (!found && j < paths.length()) {
					if (state[paths[j].@key] == paths[j].@value)
					{
						found = true;
						
						button1.setText(BranchButton.DEFAULT_TEXT);
						button1.reference = paths[j].Reference;
						button1.x = 530;
						button1.y = 345;
						
						if (paths[j].Store.length() > 0)
						{
							button1.stores = true;
							button1.key = paths[j].Store.@key;
							button1.value = paths[j].Store.@value;
						}
						
						button1.visible = true;
						
						button2.visible = false;
						button3.visible = false;
					}
					j++;
				}
				
				//TODO: implement default behavior.
				if (!found)
				{
					button1.visible = false;
					button2.visible = false;
					button3.visible = false;
				}
			}
		}
	}

}