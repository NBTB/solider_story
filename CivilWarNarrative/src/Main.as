package 
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import mx.utils.ObjectUtil;
	import VisualElements.ProgressBar;
	
	/**
	 * The document class for the interactive narrative.
	 * @author Robert Cigna
	 */
	public class Main extends Sprite 
	{
		public static const DEFINITION_FILE:String = "narrativedata.xml"; //The name and relative path to the definition XML file.
		
		// Application level variables.
		internal var apploader:URLLoader; //Loads the application details.
		internal var numSlides:int;       //The total number of slides.
		internal var index:int;           //A counter for determining when all images have completed loading.
		internal var list:XMLList;        //An array used to load all the images the app needs in sequence.
		
		internal var loady1:ProgressBar;  //placeholder loading graphics.
		internal var loady2:ProgressBar;  //placeholder loading graphics.
		
		internal var wipe:WipeTransition; //Performs animated transitions.
		
		internal var entry:String;        //The slide to display first and on reset.
		
		internal var images:Object;       //All images used by the app in an associative array.
		internal var slides:Object;       //All slides in an associative array.
		internal var state:Object;        //Stored key/value pairs for determining branching.
		internal var stack:Array;         //The slide traversal stack, for backwards traversal.
		
		/**
		 * Main entry point for the application.
		 */
		public function Main():void {
			XML.ignoreComments = true; 
			XML.ignoreProcessingInstructions = true;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Initializes the application by starting to load content.
		 * @param	e
		 */
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//TODO better loading graphic
			loady1 = new ProgressBar(300,50);
			loady1.x = 150;
			loady1.y = 120;
			loady1.draw(0);
			addChild(loady1);
			loady2 = new ProgressBar(300,50);
			loady2.x = 150;
			loady2.y = 200;
			loady2.draw(0);
			addChild(loady2);
			
			
			images = new Object();
			index = 0;
			wipe = new WipeTransition();
			addChild(wipe);
			
			slides = new Object();
			state = new Object();
			stack = new Array();
			
			// Begin loading app info.
			apploader = new URLLoader();
            apploader.addEventListener(Event.COMPLETE, loadAppInfo);
			apploader.addEventListener(ProgressEvent.PROGRESS, showProgress);

            var request:URLRequest = new URLRequest(DEFINITION_FILE);
            apploader.load(request);
			trace("Downloading app data...");
		}
		
		private function showProgress(e:ProgressEvent):void {
			loady1.draw(e.bytesLoaded/e.bytesTotal);
		}
		
		/**
		 * Receives the downloaded data and parses it.
		 * @param	event An event signaling that downloading of the XML data is complete.
		 */
		private function loadAppInfo(event:Event):void {
			trace("Now parsing app data...");
            var loader:URLLoader = URLLoader(event.target);
			var xmlreader:XML = new XML(loader.data);
			
			entry = xmlreader.Entry;
			numSlides = xmlreader.Slide.length();
			
			list = xmlreader..Image;
			loadNextImage();
        }
		
		/**
		 * Serializes the loading of images. Called to load the next appropriate image, ignoring duplicates.
		 * @param	e The event signalling the last load was completed, or null if no images have been loaded yet.
		 */
		private function loadNextImage(e:Event = null):void {
			var loader:Loader;
			
			//e is null if this is the first time, but otherwise we need to cache the result.
			if (e != null) {
				images[list[index]] = LoaderInfo(e.target).loader;
				while (images[list[index]] != null ) { index++; } //gets the next non-duplicate entry
			}
			
			loady2.draw(index/list.length());
			
			//if not finished, load the next one, otherwise move on.
			if (index < list.length()) {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadNextImage);
				trace("Fetching \"" + list[index] + "\"...");
				loader.load(new URLRequest(list[index]));
			}
			else {
				createSlides();
			}
		}
		
		/**
		 * Helper method that handles construction of the slides.
		 */
		private function createSlides():void {
			var xmlreader:XML = new XML(apploader.data);
			
			//TODO error handling for slide loading
			for (var i:int = 0; i < numSlides; i++ )
			{
				//Pass the XML definition along to the slide and let it set itself up, then add all the event listeners a slide needs.
				var slide:Slide = new Slide(xmlreader.Slide[i], images);
				slide.addEventListener(SlideEvent.STORE_KEY, storeKey);
				slide.addEventListener(SlideEvent.CHANGE_SLIDE, changeSlide);
				slide.addEventListener(SlideEvent.CLEAR_STATE, clearState);
				slide.addEventListener(SlideEvent.POP_STATE, popState);
				slide.addEventListener(SlideEvent.PUSH_STATE, pushState);
				slides[slide.SlideName] = slide;
				addChild(slide);
				slide.x = stage.stageWidth * 2;
			}
			
			//TODO: remove loading graphic or change it to indicate progress.
			removeChild(loady1);
			removeChild(loady2);
			
			//Throw the first slide up on the screen.
			state.currentSlide = entry;
			state.stacklength = stack.length;
			slides[state.currentSlide].enterSlide(state);
			wipe.start(null, slides[state.currentSlide]);
		}
		
		/**
		 * State mutator. Adds a value to the current state (or potentially overwrites an old one).
		 * @param	e The STORE_KEY event containing the key and value to store.
		 */
		private function storeKey(e:SlideEvent):void {
			state[e.key] = e.value;
		}
		
		/**
		 * Changes to a new slide given by the event parameter.
		 * @param	e The CHANGE_SLIDE event.
		 */
		private function changeSlide(e:SlideEvent):void {
			//TODO: slide transition
			wipe.start(slides[state.currentSlide], slides[e.value]);
			
			state.currentSlide = e.value;
			
			slides[state.currentSlide].enterSlide(state);
			slides[state.currentSlide].x = stage.stageWidth * 2;
			addChild(slides[state.currentSlide]);
		}

		/**
		 * Clears current state and stack and returns to the entry point. Afterwards, it is as if the program was just relaunched.
		 * @param	e The CLEAR_STATE event.
		 */
		private function clearState(e:SlideEvent):void {
			wipe.start(slides[state.currentSlide], slides[entry]);
			
			state = new Object();
			stack = new Array();
			state.currentSlide = entry;
			
			slides[state.currentSlide].enterSlide(state);
			addChild(slides[state.currentSlide]);
		}
		
		/**
		 * Backwards traversal, pops and overwrites current state with the last state on the stack.
		 * @param	e The POP_STATE event.
		 */
		private function popState(e:SlideEvent):void {
			//TODO: backwards slide transition
			
			if (stack.length < 1) return; //fail-safe
			
			var lastSlide:String = state.currentSlide;
			state = stack.pop();
			
			wipe.start(slides[lastSlide], slides[state.currentSlide], true);
			
			slides[state.currentSlide].enterSlide(state);
			addChild(slides[state.currentSlide]);
		}
		
		/**
		 * Forces the application to push current state to the stack in preparation for mutating it.
		 * @param	e The PUSH_STATE event.
		 */
		private function pushState(e:SlideEvent):void {
			stack.push(ObjectUtil.copy(state));
			state.stacklength = stack.length;
		}
	}
	
}