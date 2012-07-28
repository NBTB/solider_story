package VisualElements 
{
	import flash.display.SimpleButton;
	/**
	 * BackButtons are buttons that appear along the top of the stage and allow the user to traverse backwards through the slides.
	 * @author Robert Cigna
	 */
	public class BackButton extends SimpleButton
	{
		//Constructs a BackButton with the given position and size.
		public function BackButton(x:int, y:int, width:int, height:int) {
			this.x = x;
			this.y = y;
			
			var graphic:BackGraphic = new BackGraphic(width, height, Slide.NORMAL_GRADIENT);
			var hovergraphic:BackGraphic = new BackGraphic(width, height, Slide.SELECTED_GRADIENT);
			super(graphic, hovergraphic, graphic, graphic);
		}
		
	}

}