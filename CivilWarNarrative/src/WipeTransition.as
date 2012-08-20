package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * Quick and dirty animation for transitioning slides.
	 * @author Robert Cigna
	 */
	public class WipeTransition extends Sprite
	{
		public static const MOVE_RATE:int = 18; //num frames before done
		
		private var oldSlide:Slide;
		public function get OldSlide():Slide { return oldSlide; }
		
		private var newSlide:Slide;
		public function get NewSlide():Slide { return newSlide; }
		
		private var reverse:Boolean;
		
		/**
		 * Essentially a manager for transitions. Instantiate once. Must be added to the display list (it has no visible elements) to work properly.
		 * Then, call start() with the slides to animate.
		 */
		public function WipeTransition() 
		{
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		/**
		 * Starts transitioning from old slide to new.
		 * @param	olds The old slide. Must already be added to the display list. Will be removed from the display list automatically.
		 * @param	news The new slide. Must already be added to the display list.
		 * @param	reverse True if this is a reverse transition (for backwards traversal), false otherwise.
		 */
		public function start(olds:Slide, news:Slide, reverse:Boolean = false):void {
			oldSlide = olds;
			newSlide = news;
			this.reverse = reverse;
			
			if (reverse) {
				if(oldSlide != null) oldSlide.x = 0;
				if(newSlide != null) newSlide.x = -stage.stageWidth * 2
			}
			else {
				if(oldSlide != null) oldSlide.x = 0;
				if(newSlide != null) newSlide.x = stage.stageWidth * 2;
			}
		}
		
		/**
		 * This function just runs every frame. If it has a reference, it'll move the slide. 
		 * If it finishes moving a slide, it drops the reference. Otherwise it just waits.
		 * @param	e
		 */
		private function onFrame(e:Event):void {
			if (newSlide != null) {
				if (reverse) {
					newSlide.x += newSlide.width / MOVE_RATE;
					newSlide.alpha = Math.max(0,(stage.stageWidth + newSlide.x) / stage.stageWidth);
					if(newSlide.x >= 0) {
						newSlide.x = 0;
						newSlide.alpha = 1;
						newSlide = null;
					}
				}
				else {
					newSlide.x -= newSlide.width / MOVE_RATE;
					newSlide.alpha = Math.max(0,(stage.stageWidth - newSlide.x) / stage.stageWidth);
					if(newSlide.x <= 0) {
						newSlide.x = 0;
						newSlide.alpha = 1;
						newSlide = null;
					}
				}
				
				
			}
			
			if (oldSlide != null) {
				if (reverse) {
					oldSlide.x += oldSlide.width / MOVE_RATE;
					oldSlide.alpha = Math.max(0,(stage.stageWidth - oldSlide.x) / stage.stageWidth);
					if (oldSlide.x > stage.stageWidth) {
						oldSlide.parent.removeChild(oldSlide);
						oldSlide = null;
					}
				}
				else {
					oldSlide.x -= oldSlide.width / MOVE_RATE;
					oldSlide.alpha = Math.max(0,(stage.stageWidth + oldSlide.x) / stage.stageWidth);
					if (oldSlide.x < -stage.stageWidth) {
						oldSlide.parent.removeChild(oldSlide);
						oldSlide = null;
					}
				}
			}
		}
	}

}