package VisualElements
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * The HideButton hides all the interface elements. 
	 * @author Chris Knepper
	 */
	public class HideButton extends Sprite
	{

		
		//{ region Instance Variables
		
		private var graphic:ButtonGraphic;         //The actual, visible graphic, including visible text.
		private var hovergraphic:ButtonGraphic;    //A copy of the graphic, but a different color, to be shown when the user hovers over the button.
		
		//} endregion
		
		/**
		 * Constructs a new HideButton with the given position and size.
		 * @param	x The x coordinate of the BranchButton.
		 * @param	y The y coordinate of the BranchButton.
		 * @param	width The width of the BranchButton.
		 * @param	height The height of the BranchButton. It should be greater than or equal to 6.
		 */
		public function HideButton(x:int, y:int, width:int, height:int) {
			this.x = x;
			this.y = y;
			this.buttonMode = true;
			
			graphic = new ButtonGraphic(width, height, Slide.NORMAL_GRADIENT);
			graphic.mouseEnabled = false;
			graphic.mouseChildren = false;
			addChild(graphic);
			this.mouseChildren = false;
			hovergraphic = new ButtonGraphic(width, height, Slide.SELECTED_GRADIENT);
			hovergraphic.mouseEnabled = false;
			hovergraphic.mouseChildren = false;
			this.setText("Hide Interface");
			addEventListener(MouseEvent.MOUSE_OVER, highlight);
			addEventListener(MouseEvent.MOUSE_OUT, reset);
		}
		
		/**
		 * An event listener for mouse over events. Swaps the current graphic with the highlighted one.
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
		
		/**
		 * Sets the text that appears on the button.
		 * @param	text The text to label this button. HTML tags allowed.
		 */
		public function setText(text:String):void {
			graphic.setText(text);
			hovergraphic.setText(text);
		}
	}

}