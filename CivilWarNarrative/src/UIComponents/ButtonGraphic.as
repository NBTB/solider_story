package UIComponents 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class ButtonGraphic extends Sprite
	{
		private var field:TextField;
		
		public function ButtonGraphic(width:int, height:int, gradient:Array) 
		{
			var fontsize:int = 14;
			
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(width, height, Math.PI / 2, 0, 0);
			//graphics.beginGradientFill(GradientType.LINEAR, [0x0A1433, 0x0F1F4C, 0x142966], [.55, .55, .55], [0, 50, 255], mat);
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
		
		public function setText(text:String):void {
			field.text = text;
		}
	}

}