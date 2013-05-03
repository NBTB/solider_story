package VisualElements 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * BackButtons are buttons that appear along the top of the stage and allow the user to traverse backwards through the slides.
	 * @author Robert Cigna
	 */
	public class BackButton extends Sprite
	{
		private var graphic:BackGraphic;
		private var hovergraphic:BackGraphic;
		
		/**
		 * Constructs a BackButton with the given position and size.
		 * @param	x The x coordinate of the BackButton.
		 * @param	y The y coordinate of the BackButton.
		 * @param	width The width of the BackButton.
		 * @param	height The height of the BackButton. It should be greater than or equal to 6.
		 */
		public function BackButton(x:int, y:int, width:int, height:int) {
			this.x = x;
			this.y = y;
			this.buttonMode = true;
			
			graphic = new BackGraphic(width, height, Slide.NORMAL_GRADIENT);
			hovergraphic = new BackGraphic(width, height, Slide.SELECTED_GRADIENT);
			addChild(graphic);
			addEventListener(MouseEvent.MOUSE_OVER, highlight);
			addEventListener(MouseEvent.MOUSE_OUT, reset);
		}
		
		/**
		 * An event listener for mouse over events. Replaces the normal graphic with a highlighted one.
		 * @param	e
		 */
		private function highlight(e:Event = null):void {
			removeChildAt(0);
			addChild(hovergraphic);
		}
		
		/**
		 * Resets the button back to the normal graphic.
		 * @param	e
		 */
		public function reset(e:Event = null):void {
			removeChildAt(0);
			addChild(graphic);
		}
	}

}