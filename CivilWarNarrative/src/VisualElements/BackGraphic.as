package VisualElements 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	/**
	 * BackGraphic is the visible part of a BackButton (ie, the drawing).
	 * @author Robert Cigna
	 */
	public class BackGraphic extends Sprite 
	{
		//Constructs the graphic with the given size and color scheme.
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