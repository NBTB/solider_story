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
		
		public function ButtonGraphic(text:String) 
		{
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(216, 30, Math.PI / 2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [0x0A1433, 0x0F1F4C, 0x142966], [.55, .55, .55], [0, 50, 255], mat);
			graphics.moveTo(3, 0);
			graphics.lineTo(201, 0);
			graphics.lineTo(216, 15);
			graphics.lineTo(201, 30);
			graphics.lineTo(3, 30);
			graphics.curveTo(0, 30, 0, 27);
			graphics.lineTo(0, 3);
			graphics.curveTo(0, 0, 3, 0);
			graphics.endFill();
			
			var fieldFormat:TextFormat = new TextFormat();
			fieldFormat.font = "Arial";
			fieldFormat.align = TextFormatAlign.CENTER;
			fieldFormat.size = 14;
			field = new TextField();
			field.width = 201;
			field.height = 30;
			field.x = 0;
			field.y = 4;
			field.textColor = 0xFFFFFF;
			field.defaultTextFormat = fieldFormat;
			field.text = text;
			addChild(field);
		}
		
		public function setText(text:String):void {
			field.text = text;
		}
	}

}