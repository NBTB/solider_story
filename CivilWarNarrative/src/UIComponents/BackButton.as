package UIComponents 
{
	import flash.display.SimpleButton;
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class BackButton extends SimpleButton
	{
		
		public function BackButton(x:int, y:int, width:int, height:int) {
			this.x = x;
			this.y = y;
			var graphic:BackGraphic = new BackGraphic(width, height, Slide.NORMAL_GRADIENT);
			var hovergraphic:BackGraphic = new BackGraphic(width, height, Slide.SELECTED_GRADIENT);
			super(graphic, hovergraphic, graphic, graphic);
		}
		
	}

}