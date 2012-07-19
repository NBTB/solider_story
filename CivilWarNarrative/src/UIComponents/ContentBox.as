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
	public class ContentBox extends Sprite
	{
		private var fieldFormat:TextFormat;
		private var field:TextField;
		
		public function ContentBox(type:String) 
		{
			var height:int = 450;
			if (type == Slide.ENDING_TYPE) height = 170;
			
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(490, height, Math.PI / 2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [0x0A1433, 0x0F1F4C, 0x142966], [.55, .55, .55], [0, 4, 255], mat);
			graphics.moveTo(3, 0);
			graphics.lineTo(487, 0);
			graphics.curveTo(490, 0, 490, 3);
			graphics.lineTo(490, height - 3);
			graphics.curveTo(490, height, 487, height);
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
			//field.x = 530;
			//field.y = 20;
			field.width = 488;
			field.height = height-2;
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