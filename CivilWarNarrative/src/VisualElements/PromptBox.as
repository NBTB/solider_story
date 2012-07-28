package VisualElements 
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class PromptBox extends Sprite
	{
		//TODO decide if the app cant use ContentBox in all cases where it now uses PromptBox
		private var fieldFormat:TextFormat;
		private var field:TextField;
		
		public function PromptBox(x:int, y:int, width:int, height: int) 
		{
			this.x = x;
			this.y = y;
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(width, height, Math.PI / 2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, Slide.NORMAL_GRADIENT, [.65, .85, .35], [0, 10*255/height, 255], mat);
			graphics.moveTo(3, 0);
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
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
			field.width = width - 2;
			field.height = height - 2;
			field.x = 1;
			field.y = 1;
			field.wordWrap = true;
			field.multiline = true;
			
			addChild(field);
		}
		
		public function setText(text:String):void {
			field.htmlText = text;
		}
	}

}