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
		
		public function PromptBox() 
		{
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(216, 30, Math.PI / 2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [0x0A1433, 0x0F1F4C, 0x142966], [.55, .55, .55], [0, 50, 255], mat);
			graphics.moveTo(3, 0);
			graphics.lineTo(213, 0);
			graphics.curveTo(216, 0, 216, 3);
			graphics.lineTo(216, 147);
			graphics.curveTo(216, 150, 213, 150);
			graphics.lineTo(3, 150);
			graphics.curveTo(0, 150, 0, 147);
			graphics.lineTo(0, 3);
			graphics.curveTo(0, 0, 3, 0);
			graphics.endFill();
			
			
			fieldFormat = new TextFormat();
			fieldFormat.font = "Arial";
			fieldFormat.color = 0xFFFFFF;
			fieldFormat.size = 12;
			
			field = new TextField();
			field.defaultTextFormat = fieldFormat;
			//field.x = 530;
			//field.y = 20;
			field.width = 214;
			field.height = 148;
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