package VisualElements 
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ButtonGraphic is the visible part of a BranchButton (ie, the drawing and text).
	 * @author Robert Cigna
	 */
	public class ButtonGraphic extends Sprite
	{
		private var field:TextField;
		
		//Constructs the graphic using the given size and color scheme.
		public function ButtonGraphic(width:int, height:int, gradient:Array) 
		{
			var fontsize:int = 14;
			
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(width, height, Math.PI / 2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, gradient, [.65, .85, .45], [0, 6*255/height, 255], mat);
			graphics.moveTo(3, 0);
			graphics.lineTo(width - height / 2, 0);
			graphics.lineTo(width, height / 2);
			graphics.lineTo(width - height / 2, height);
			graphics.lineTo(3, height);
			graphics.curveTo(0, height, 0, height - 3);
			graphics.lineTo(0, 3);
			graphics.curveTo(0, 0, 3, 0);
			graphics.endFill();
			
			var fieldFormat:TextFormat = new TextFormat();
			fieldFormat.font = "Arial";
			fieldFormat.align = TextFormatAlign.CENTER;
			fieldFormat.size = fontsize;
			field = new TextField();
			field.width = width - height / 2 - 1;
			field.height = height - 5;
			field.x = 1;
			field.y = (height - fontsize - 6) / 2;
			field.textColor = 0xFFFFFF;
			field.defaultTextFormat = fieldFormat;
			addChild(field);
		}
		
		//Sets the text that appears on the graphic. HTML tags allowed.
		public function setText(text:String):void {
			field.htmlText = text;
		}
	}

}