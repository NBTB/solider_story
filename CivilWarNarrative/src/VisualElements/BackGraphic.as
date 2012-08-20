package VisualElements 
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * BackGraphic is the visible part of a BackButton (ie, the drawing).
	 * @author Robert Cigna
	 */
	public class BackGraphic extends Sprite 
	{
		/**
		 * Constructs the graphic with the given size and color scheme. The registration point is the upper left corner.
		 * @param	width The width of the graphic.
		 * @param	height The height of the graphic. It should be greater than or equal to 6.
		 * @param	gradient The array of colors to use as a gradient fill. Must be three elements long.
		 */
		public function BackGraphic(width:int, height:int, gradient:Array) {
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(width, height, Math.PI / 2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, gradient, [.65, .85, .45], [0, 6*255/height, 255], mat);
			
			graphics.moveTo(0, height / 2);
			graphics.lineTo(width, 0);
			graphics.lineTo(width, height);
			graphics.lineTo(0, height / 2);
			graphics.endFill();
		}
		
	}

}