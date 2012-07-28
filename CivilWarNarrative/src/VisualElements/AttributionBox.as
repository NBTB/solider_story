package VisualElements 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	
	/**
	 * AttributionBoxes are inconspicuous text boxes that appear in the lower right and show attribution information for the background image.
	 * @author Robert Cigna
	 */
	public class AttributionBox extends Sprite
	{
		//{ region Constants
		public static const bordersize:int = 10;                //The width of the faded edge.
		public static const transparencyfrac:Number = .4;       //The transparency fraction of the box's general background.
		public static const backgroundcolor:uint = 0x7B6748;    //The color of the background of the box.
		//} endregion
		
		private var fieldFormat:TextFormat;
		private var field:TextField;
		
		//Constructs an AttributionBox with the given position and size.
		public function AttributionBox(x:int, y:int, width:int, height:int) 
		{
			this.x = x;
			this.y = y;
			this.cacheAsBitmap = true;
			
			//create a pale, transparent background to ensure readable contrast
			graphics.lineStyle(0, 0, 0);
			var mat:Matrix = new Matrix();
			mat.createGradientBox(bordersize, height, 0, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [backgroundcolor, backgroundcolor], [0, transparencyfrac], [0, 255], mat);
			graphics.drawRect(0, bordersize, bordersize, height - 2 * bordersize);
			graphics.endFill();
			mat.createGradientBox(bordersize, height, Math.PI, width - bordersize, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [backgroundcolor, backgroundcolor], [0, transparencyfrac], [0, 255], mat);
			graphics.drawRect(width - bordersize, bordersize, bordersize, height - 2 * bordersize);
			graphics.endFill();
			mat.createGradientBox(width, bordersize, Math.PI/2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [backgroundcolor, backgroundcolor], [0, transparencyfrac], [0, 255], mat);
			graphics.drawRect(bordersize, 0, width - 2 * bordersize, bordersize);
			graphics.endFill();
			mat.createGradientBox(width, bordersize, 3*Math.PI/2, 0, height - bordersize);
			graphics.beginGradientFill(GradientType.LINEAR, [backgroundcolor, backgroundcolor], [0, transparencyfrac], [0, 255], mat);
			graphics.drawRect(bordersize, height - bordersize, width - 2 * bordersize, bordersize);
			graphics.endFill();
			graphics.beginFill(backgroundcolor, transparencyfrac);
			graphics.drawRect(bordersize, bordersize, width - 2 * bordersize, height - 2 * bordersize);
			graphics.endFill();
			mat.createGradientBox(2 * bordersize, 2 * bordersize, 0, 0, 0);
			graphics.beginGradientFill(GradientType.RADIAL, [backgroundcolor, backgroundcolor], [transparencyfrac, 0], [0, 255], mat);
			graphics.drawRect(0, 0, bordersize, bordersize);
			graphics.endFill();
			mat.createGradientBox(2 * bordersize, 2 * bordersize, 0, 0, height - 2 * bordersize);
			graphics.beginGradientFill(GradientType.RADIAL, [backgroundcolor, backgroundcolor], [transparencyfrac, 0], [0, 255], mat);
			graphics.drawRect(0, height - bordersize, bordersize, bordersize);
			graphics.endFill();
			mat.createGradientBox(2 * bordersize, 2 * bordersize, 0, width - 2 * bordersize, 0);
			graphics.beginGradientFill(GradientType.RADIAL, [backgroundcolor, backgroundcolor], [transparencyfrac, 0], [0, 255], mat);
			graphics.drawRect(width - bordersize, 0, bordersize, bordersize);
			graphics.endFill();
			mat.createGradientBox(2 * bordersize, 2 * bordersize, 0, width - 2 * bordersize, height - 2 * bordersize);
			graphics.beginGradientFill(GradientType.RADIAL, [backgroundcolor, backgroundcolor], [transparencyfrac, 0], [0, 255], mat);
			graphics.drawRect(width - bordersize, height - bordersize, bordersize, bordersize);
			graphics.endFill();
			
			
			
			fieldFormat = new TextFormat();
			fieldFormat.size = 9;
			fieldFormat.font = "Arial";
			fieldFormat.color = 0xFFFFFF;
			fieldFormat.align = TextFormatAlign.RIGHT;
			
			field = new TextField();
			field.defaultTextFormat = fieldFormat;
			field.x = 1;
			field.y = 1;
			field.width = width - 2;
			field.height = height - 2;
			field.wordWrap = true;
			
			addChild(field);
		}
		
		//Sets the text to appear in the box. HTML tags allowed.
		public function setText(text:String):void {
			field.htmlText = text;
		}
		
	}

}