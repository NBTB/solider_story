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
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class Main extends Sprite 
	{
		// Application level variables
		internal var apploader:URLLoader; // loads the application details
		internal var entry:String; // the entry point for the slides
		internal var currentSlide:String; // The name of the current slide
		
		internal var slides:Object; // All slides in an associative array
		internal var state:Object; // Stored key/value pairs for determining branching.
		
		
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
			
			entry = xmlreader.Entry;
			
			for (var i:int = 0; i < xmlreader.Slide.length(); i++ )
			{
				var slide:Slide = new Slide(xmlreader.Slide[i]);
				slide.addEventListener(SlideEvent.STORE_KEY, storeKey);
				slide.addEventListener(SlideEvent.CHANGE_SLIDE, changeSlide);
				slide.addEventListener(SlideEvent.CLEAR_STATE, clearState);
				slides[slide.slideName] = slide;
			}
			
			currentSlide = entry;
			slides[currentSlide].enterSlide(state);
			addChild(slides[currentSlide]);
        }
		
		private function storeKey(e:SlideEvent):void {
			state[e.key] = e.value;
		}
		
		private function changeSlide(e:SlideEvent):void {
			removeChild(slides[currentSlide]);
			currentSlide = e.value;
			slides[currentSlide].enterSlide(state);
			addChild(slides[currentSlide]);
		}

		private function clearState(e:SlideEvent):void {
			state = new Object();
			e.value = entry;
			changeSlide(e);
		}
		
        private function progressHandler(event:ProgressEvent):void
		{
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }
	}
	
}