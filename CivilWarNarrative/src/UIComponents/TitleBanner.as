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
	public class TitleBanner extends Sprite
	{
		private var fieldFormat:TextFormat;
		private var field:TextField;
		
		public function TitleBanner(x:int, y:int, width:int, height:int) 
		{
			var fontsize:int = 48;
			//var width:int = 766;
			
			this.x = x;
			this.y = y;
			
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(width, height, 0, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [0x334C80, 0x0F1F4C, 0x0F1F4C, 0x334C80], [.35, .75, .75, .35], [0, 85,171, 255], mat);
			graphics.moveTo(0, 0);
			graphics.lineTo(width, 0);
			graphics.lineStyle(0,0,0);
			graphics.lineTo(width, height);
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			graphics.lineTo(0, height);
			graphics.lineStyle(0,0,0);
			graphics.lineTo(0, 0);
			graphics.endFill();
			
			
			fieldFormat = new TextFormat();
			fieldFormat.size = fontsize;
			fieldFormat.color = 0xFFFFFF;
			fieldFormat.font = "Times New Roman";
			fieldFormat.align = TextFormatAlign.CENTER;
			
			field = new TextField();
			field.defaultTextFormat = fieldFormat;
			//field.x = 530;
			//field.y = 20;
			field.width = width-2;
			field.height = height-2;
			field.x = 1;
			field.y = (height - 1.2 * fontsize) / 2;
			
			addChild(field);
		}
		
		public function setText(text:String):void {
			field.text = text;
		}
		
	}

}