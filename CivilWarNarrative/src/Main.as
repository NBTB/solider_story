package 
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import mx.utils.ObjectUtil;
	import VisualElements.ProgressBar;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
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
		internal var loadingText:TextField;
		
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
			loady1 = new ProgressBar(100,30);
			loady1.x = 150;
			loady1.y = 120;
			loady1.draw(0);
			addChild(loady1);
			loady1.alpha = 0;
			loady2 = new ProgressBar(100,30);
			loady2.x = (stage.stageWidth / 2) + 15;
			loady2.y = stage.stageHeight / 2;
			loady2.draw(0);
			addChild(loady2);
			stage.frameRate = 60;
			
			//create loading text field
			loadingText = new TextField();
			loadingText.wordWrap = true;
			loadingText.selectable = false;
			loadingText.text = "A Soldier's Story Loading...";
			loadingText.x = (stage.stageWidth / 3.5);
			loadingText.y = 210;
			loadingText.height = 168;
			loadingText.width = 300;
			var myTextFormat:TextFormat = new TextFormat();
			myTextFormat.font = "Arial";
			myTextFormat.size = 40;
			myTextFormat.color = 0xFFFFFF;
			myTextFormat.leading = 20;
			loadingText.setTextFormat(myTextFormat);
			addChild(loadingText);
			
			images = new Object();
			index = 0;
			
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
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, printError);
				trace("Fetching \"" + list[index] + "\"...");
				loader.load(new URLRequest(list[index]));
			}
			else {
				createSlides();
			}
		}
		
		private function printError(e:IOErrorEvent):void {
			throw new Error("The file \"" + list[index] + "\" could not be loaded!");
		}
		
		/**
		 * Helper method that handles construction of the slides.
		 */
		private function createSlides():void {
			var xmlreader:XML = new XML(apploader.data);
			
			//var slide:Slide = new Slide(new XML("<Slide name=\"error\" type=\"ending\"><Content>An error has occured, please restart the application. " +
			//									"If you continue to receive this message, contact an administrator and tell them what steps you are taking.</Content>" +
			//									"<Image>titleslide.png</Image><Attribution>An error has occured.</Attribution></Slide>"), images); 
			//slide.addEventListener(SlideEvent.CHANGE_SLIDE, changeSlide);
			//slide.addEventListener(SlideEvent.CLEAR_STATE, clearState);
			//slide.addEventListener(SlideEvent.POP_STATE, popState);
			//slide.addEventListener(SlideEvent.PUSH_STATE, pushState);
			//slide.addEventListener(SlideEvent.STORE_KEY, storeKey);
			//slides[slide.SlideName] = slide;
			
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
			}
			
			//TODO: remove loading graphic or change it to indicate progress.
			removeChild(loady1);
			removeChild(loady2);
			removeChild(loadingText);
			
			//Throw the first slide up on the screen.
			state.currentSlide = entry;
			state.stacklength = stack.length;
			slides[state.currentSlide].enterSlide(state);
			addChild(slides[state.currentSlide]);
			slides[state.currentSlide].alpha = 0;
			TweenLite.to(slides[state.currentSlide], 0.5, { alpha:1, ease:Sine.easeInOut } );
			//wipe.start(null, slides[state.currentSlide]);
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
			TweenLite.to(slides[state.currentSlide], 0.5, { alpha:0, ease:Sine.easeInOut } );
			removeChild(slides[state.currentSlide]); //collect teh garbage
			state.currentSlide = e.value;
			try {
				slides[state.currentSlide].enterSlide(state);
				addChild(slides[state.currentSlide]);
				slides[state.currentSlide].alpha = 0;
				TweenLite.to(slides[state.currentSlide], 0.5, { alpha:1, ease:Sine.easeInOut } );
				
			}
			catch (e:TypeError) {
				throw new Error("The slide \"" + state.currentSlide + "\" could not load!");
			}
		}

		/**
		 * Clears current state and stack and returns to the entry point. Afterwards, it is as if the program was just relaunched.
		 * @param	e The CLEAR_STATE event.
		 */
		private function clearState(e:SlideEvent):void {
			TweenLite.to(slides[state.currentSlide], 0.5, { alpha:0, ease:Sine.easeInOut } );
			removeChild(slides[state.currentSlide]); //collect teh garbage
			
			state = new Object();
			stack = new Array();
			state.currentSlide = entry;
			
			slides[state.currentSlide].enterSlide(state);
			addChild(slides[state.currentSlide]);
			slides[state.currentSlide].alpha = 0;
			TweenLite.to(slides[state.currentSlide], 0.5, { alpha:1, ease:Sine.easeInOut } );
		}
		
		/**
		 * Backwards traversal, pops and overwrites current state with the last state on the stack.
		 * @param	e The POP_STATE event.
		 */
		private function popState(e:SlideEvent):void {
			
			if (stack.length < 1) return; //fail-safe
			
			var lastSlide:String = state.currentSlide;
			state = stack.pop();
			TweenLite.to(slides[lastSlide], 0.5, { alpha:0, ease:Sine.easeInOut } );	
			removeChild(slides[lastSlide]); //collect teh garbage
			slides[state.currentSlide].enterSlide(state);
			addChild(slides[state.currentSlide]);
			TweenLite.to(slides[state.currentSlide], 0.5, { alpha:1, ease:Sine.easeInOut } );
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