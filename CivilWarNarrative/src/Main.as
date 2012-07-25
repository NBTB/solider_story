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
	 * ...
	 * @author Robert Cigna
	 */
	public class Main extends Sprite 
	{
		// Application level variables
		internal var apploader:URLLoader; // Loads the application details.
		internal var numSlides:int; // The total number of slides.
		internal var counter:int; // A counter for determining when all slides have completed loading.
		
		internal var entry:String; // The slide to display first and on reset.
		//internal var currentSlide:String; // The name of the current slide. now wrapped into "state"
		
		internal var slides:Object; // All slides in an associative array.
		internal var state:Object;  // Stored key/value pairs for determining branching.
		internal var stack:Array;  // The slide traversal stack, for backwards traversal.
		
		public function Main():void 
		{
			XML.ignoreComments = true; 
			XML.ignoreProcessingInstructions = true;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//TODO add a loading graphic
			
			// Begin loading app info.
			apploader = new URLLoader();
            apploader.addEventListener(Event.COMPLETE, loadAppInfo);

            var request:URLRequest = new URLRequest("narrativedata.xml");
            apploader.load(request);
			
		}
		
		private function loadAppInfo(event:Event):void 
		{
            var loader:URLLoader = URLLoader(event.target);
            //trace("Appinfo loaded: " + loader.data);
			var xmlreader:XML = new XML(loader.data);
			//trace(xmlreader.Entry);
			
			//var slideloader:URLLoader = new URLLoader();
			//slideloader.addEventListener(Event.COMPLETE, loadSlide);
			//slideloader.load(new URLRequest(xmlreader.Entry));
			
			slides = new Object();
			state = new Object();
			stack = new Array();
			
			entry = xmlreader.Entry;
			numSlides = xmlreader.Slide.length();
			
			for (var i:int = 0; i < numSlides; i++ )
			{
				var slide:Slide = new Slide(xmlreader.Slide[i]);
				slide.addEventListener(SlideEvent.STORE_KEY, storeKey);
				slide.addEventListener(SlideEvent.CHANGE_SLIDE, changeSlide);
				slide.addEventListener(SlideEvent.CLEAR_STATE, clearState);
				slide.addEventListener(SlideEvent.LOAD_COMPLETE, countLoad);
				slide.addEventListener(SlideEvent.GO_BACK, goBack);
				slides[slide.slideName] = slide;
			}
			
        }
		
		private function countLoad(e:SlideEvent):void {
			counter++;
				//TODO: remove loading graphic or change it to indicate progress.
			if (counter == numSlides) {
				state.currentSlide = entry;
				//currentSlide = entry;
				slides[state.currentSlide].enterSlide(state);
				addChild(slides[state.currentSlide]);
			}
		}
		
		private function storeKey(e:SlideEvent):void {
			state[e.key] = e.value;
		}
		
		private function changeSlide(e:SlideEvent):void {
			//TODO: slide transition
			removeChild(slides[state.currentSlide]);
			
			stack.push(ObjectUtil.copy(state));
			state.currentSlide = e.value;
			state.stacklength = stack.length;
			
			slides[state.currentSlide].enterSlide(state);
			addChild(slides[state.currentSlide]);
		}

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
		
		private function goBack(e:SlideEvent):void {
			//TODO: backwards slide transition
			if (stack.length < 1) return; //fail-safe
			
			removeChild(slides[state.currentSlide]);
			
			state = stack.pop();
			
			slides[state.currentSlide].enterSlide(state);
			addChild(slides[state.currentSlide]);
		}
		
        private function progressHandler(event:ProgressEvent):void
		{
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }
	}
	
}