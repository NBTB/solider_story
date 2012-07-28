package VisualElements
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	/**
	 * BranchButtons are the buttons on the right that lead the user further into the story.
	 * @author Robert Cigna
	 */
	public class BranchButton extends SimpleButton
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
		
		//Constructs a new BranchButton with the given position and size.
		public function BranchButton(x:int, y:int, width:int, height:int) {
			this.x = x;
			this.y = y;
			
			graphic = new ButtonGraphic(width, height, Slide.NORMAL_GRADIENT);
			hovergraphic = new ButtonGraphic(width, height, Slide.SELECTED_GRADIENT);
			super(graphic, hovergraphic, graphic, graphic);
		}
		
		//Sets the text that appears on the button. HTML tags allowed.
		public function setText(text:String):void {
			graphic.setText(text);
			hovergraphic.setText(text);
		}
		
		//BUG button state retained if previsouly onstage (button is removed from stage before receiving mouse_out event).
		public function reset():void {
			dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, 0, 0, super, false, false, false, false, 0));
			dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT, true, false, 0, 0, super, false, false, false, false, 0));
		}
	}

}