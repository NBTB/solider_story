package 
{
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import mx.utils.ObjectUtil;
	
	/**
	 * The document class for the interactive narrative.
	 * @author Robert Cigna
	 */
	public class Main extends Sprite 
	{
		// Application level variables.
		internal var apploader:URLLoader; //Loads the application details.
		internal var numSlides:int;       //The total number of slides.
		internal var counter:int;         //A counter for determining when all slides have completed loading.
		
		internal var entry:String;        //The slide to display first and on reset.
		
		internal var slides:Object;       //All slides in an associative array.
		internal var state:Object;        //Stored key/value pairs for determining branching.
		internal var stack:Array;         //The slide traversal stack, for backwards traversal.
		
		//Main entry point for the application.
		public function Main():void {
			XML.ignoreComments = true; 
			XML.ignoreProcessingInstructions = true;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//Initializes the application by starting to load content.
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//TODO add a loading graphic
			
			// Begin loading app info.
			apploader = new URLLoader();
            apploader.addEventListener(Event.COMPLETE, loadAppInfo);

            var request:URLRequest = new URLRequest("narrativedata.xml");
            apploader.load(request);
			
		}
		
		//Parses the loaded XML and finishes setting up the application.
		private function loadAppInfo(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
			var xmlreader:XML = new XML(loader.data);
			
			slides = new Object();
			state = new Object();
			stack = new Array();
			
			entry = xmlreader.Entry;
			numSlides = xmlreader.Slide.length();
			
			//TODO error handling for slide loading
			for (var i:int = 0; i < numSlides; i++ )
			{
				//Pass the XML definition along to the slide and let it set itself up, then add all the event listeners a slide needs.
				var slide:Slide = new Slide(xmlreader.Slide[i]);
				slide.addEventListener(SlideEvent.LOAD_COMPLETE, countLoad);
				slide.addEventListener(SlideEvent.STORE_KEY, storeKey);
				slide.addEventListener(SlideEvent.CHANGE_SLIDE, changeSlide);
				slide.addEventListener(SlideEvent.CLEAR_STATE, clearState);
				slide.addEventListener(SlideEvent.POP_STATE, popState);
				slide.addEventListener(SlideEvent.PUSH_STATE, pushState);
				slides[slide.SlideName] = slide;
			}
			
        }
		
		//Called when a slide finishes loading. Counts the number and when all are finished, starts the app.
		private function countLoad(e:SlideEvent):void {
			counter++;
				//TODO: remove loading graphic or change it to indicate progress.
			if (counter == numSlides) {
				state.currentSlide = entry;
				state.stacklength = stack.length;
				slides[state.currentSlide].enterSlide(state);
				addChild(slides[state.currentSlide]);
			}
		}
		
		//State mutator. Adds a value to the current state (or potentially overwrites an old one).
		private function storeKey(e:SlideEvent):void {
			state[e.key] = e.value;
		}
		
		//Changes to a new slide given by the event parameter.
		private function changeSlide(e:SlideEvent):void {
			//TODO: slide transition
			removeChild(slides[state.currentSlide]);
			
			state.currentSlide = e.value;
			state.stacklength = stack.length;
			
			slides[state.currentSlide].enterSlide(state);
			addChild(slides[state.currentSlide]);
		}

		//Clears current state and stack and returns to the entry point. Afterwards, it is as if the program was just relaunched.
		private function clearState(e:SlideEvent):void {
			removeChild(slides[state.currentSlide]);
			
			state = new Object();
			stack = new Array();
			state.currentSlide = entry;
			state.stacklength = stack.length;
			
			slides[state.currentSlide].enterSlide(state);
			addChild(slides[state.currentSlide]);
			//e.value = entry;
			//changeSlide(e);
		}
		
		//Backwards traversal, pops and overwrites current state with the last state on the stack.
		private function popState(e:SlideEvent):void {
			//TODO: backwards slide transition
			if (stack.length < 1) return; //fail-safe
			
			removeChild(slides[state.currentSlide]);
			
			state = stack.pop();
			
			slides[state.currentSlide].enterSlide(state);
			addChild(slides[state.currentSlide]);
		}
		
		//Forces the application to push current state to the stack in preparation for mutating it.
		private function pushState(e:SlideEvent):void {
			stack.push(ObjectUtil.copy(state));
		}
	}
	
}