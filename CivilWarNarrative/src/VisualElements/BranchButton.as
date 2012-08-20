package VisualElements
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * BranchButtons are the buttons on the right that lead the user further into the story.
	 * @author Robert Cigna
	 */
	public class BranchButton extends Sprite
	{
		//{ region Constants
		public static const DEFAULT_TEXT:String = "Continue";        //The default text that appears on a button for a random or conditional branch.
		public static const DEFAULT_RETURN_TEXT:String = "Return";   //The default text for a button on an ending slide that takes the user back to the initial state.
		//} endregion
		
		//{ region Instance Variables
		
		private var graphic:ButtonGraphic;         //The actual, visible graphic, including visible text.
		private var hovergraphic:ButtonGraphic;    //A copy of the graphic, but a different color, to be shown when the user hovers over the button.
		public var reference:String;               //The name of the slide to change to when this button is clicked. In an Ending slide, may be null.
		
		public var stores:Boolean;                 //A flag signallaing true if the application should store a new key/value when this button is clicked.
		public var key:String;                     //If this is a storing button, this is the key to store the value under.
		public var value:String;                   //If this is a storing button, this is the value to store under the key.
		
		//} endregion
		
		/**
		 * Constructs a new BranchButton with the given position and size.
		 * @param	x The x coordinate of the BranchButton.
		 * @param	y The y coordinate of the BranchButton.
		 * @param	width The width of the BranchButton.
		 * @param	height The height of the BranchButton. It should be greater than or equal to 6.
		 */
		public function BranchButton(x:int, y:int, width:int, height:int) {
			this.x = x;
			this.y = y;
			
			graphic = new ButtonGraphic(width, height, Slide.NORMAL_GRADIENT);
			graphic.mouseEnabled = false;
			graphic.mouseChildren = false;
			addChild(graphic);
			
			hovergraphic = new ButtonGraphic(width, height, Slide.SELECTED_GRADIENT);
			hovergraphic.mouseEnabled = false;
			hovergraphic.mouseChildren = false;
			
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