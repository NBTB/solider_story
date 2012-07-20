package UIComponents 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class PromptBox extends Sprite
	{
		private var fieldFormat:TextFormat;
		private var field:TextField;
		
		public function PromptBox(x:int, y:int, width:int, height: int) 
		{
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(width, height, Math.PI / 2, 0, 0);
			//graphics.beginGradientFill(GradientType.LINEAR, [0x0A1433, 0x0F1F4C, 0x142966], [.55, .55, .55], [0, 50, 255], mat);
			graphics.beginGradientFill(GradientType.LINEAR, [0x0A1433, 0x0F1F4C, 0x293786], [.65, .85, .35], [0, 10*255/height, 255], mat);
			graphics.moveTo(3, 0);
			graphics.lineTo(width - 3, 0);
			graphics.curveTo(width, 0, width, 3);
			graphics.lineTo(width, height - 3);
			graphics.curveTo(width, height, width - 3, height);
			graphics.lineTo(3, height);
			graphics.curveTo(0, height, 0, height - 3);
			graphics.lineTo(0, 3);
			graphics.curveTo(0, 0, 3, 0);
			graphics.endFill();
			
			
			fieldFormat = new TextFormat();
			fieldFormat.font = "Arial";
			fieldFormat.color = 0xFFFFFF;
			fieldFormat.size = 12;
			
			field = new TextField();
			field.defaultTextFormat = fieldFormat;
			this.x = x;
			this.y = y;
			field.width = width - 2;
			field.height = height - 2;
			field.x = 1;
			field.y = 1;
			field.wordWrap = true;
			
			addChild(field);
		}
		
		public function setText(text:String):void {
			field.text = text;
		}
	}

}