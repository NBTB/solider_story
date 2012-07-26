package UIComponents 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class BackGraphic extends Sprite 
	{
		//public static const filletradius:int = 3;
		
		public function BackGraphic(width:int, height:int, gradient:Array) {
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(width, height, Math.PI / 2, 0, 0);
			//graphics.beginGradientFill(GradientType.LINEAR, [0x0A1433, 0x0F1F4C, 0x142966], [.55, .55, .55], [0, 50, 255], mat);
			graphics.beginGradientFill(GradientType.LINEAR, gradient, [.65, .85, .45], [0, 6*255/height, 255], mat);
			
			graphics.moveTo(0, height / 2);
			graphics.lineTo(width, 0);
			graphics.lineTo(width, height);
			graphics.lineTo(0, height / 2);
			graphics.endFill();
			
			// graphics.moveTo(filletradius*(1-Math.cos(Math.PI/2)), height/2 + filletradius*Math.sin(Math.PI/2));
			//graphics.lineTo(width - height / 2, 0);
			//graphics.lineTo(width, height / 2);
			//graphics.lineTo(width - height / 2, height);
			//graphics.lineTo(3, height);
			//graphics.curveTo(0, height, 0, height - 3);
			//graphics.lineTo(0, 3);
			//graphics.curveTo(0, 0, 3, 0);
			//graphics.endFill();
		}
		
	}

}