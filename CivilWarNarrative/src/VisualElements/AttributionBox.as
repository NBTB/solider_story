package VisualElements 
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * AttributionBoxes are inconspicuous text boxes that appear in the lower right and show attribution information for the background image.
	 * @author Robert Cigna
	 */
	public class AttributionBox extends Sprite
	{
		//{ region Constants
		public static const BORDER_SIZE:int = 10;            //The width of the faded edge.
		public static const TRANSPARENCY_FRAC:Number = .4;   //The transparency fraction of the box's general background.
		public static const BKG_COLOR:uint = 0x7B6748;       //The color of the background of the box.
		//} endregion
		
		private var fieldFormat:TextFormat;
		private var field:TextField;
		
		/**
		 * Constructs an AttributionBox with the given position and size.
		 * @param	x The x coordinate of the AttributionBox.
		 * @param	y The y coordinate of the AttributionBox.
		 * @param	width The width of the AttributionBox. It should be greater than twice the border size.
		 * @param	height The height of the AttributionBox. It should be greater than twice the border size.
		 */
		public function AttributionBox(x:int, y:int, width:int, height:int) 
		{
			this.x = x;
			this.y = y;
			this.cacheAsBitmap = true;
			
			//create a pale, transparent background to ensure readable contrast
			graphics.lineStyle(0, 0, 0);
			var mat:Matrix = new Matrix();
			mat.createGradientBox(BORDER_SIZE, height, 0, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [BKG_COLOR, BKG_COLOR], [0, TRANSPARENCY_FRAC], [0, 255], mat);
			graphics.drawRect(0, BORDER_SIZE, BORDER_SIZE, height - 2 * BORDER_SIZE);
			graphics.endFill();
			mat.createGradientBox(BORDER_SIZE, height, Math.PI, width - BORDER_SIZE, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [BKG_COLOR, BKG_COLOR], [0, TRANSPARENCY_FRAC], [0, 255], mat);
			graphics.drawRect(width - BORDER_SIZE, BORDER_SIZE, BORDER_SIZE, height - 2 * BORDER_SIZE);
			graphics.endFill();
			mat.createGradientBox(width, BORDER_SIZE, Math.PI/2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [BKG_COLOR, BKG_COLOR], [0, TRANSPARENCY_FRAC], [0, 255], mat);
			graphics.drawRect(BORDER_SIZE, 0, width - 2 * BORDER_SIZE, BORDER_SIZE);
			graphics.endFill();
			mat.createGradientBox(width, BORDER_SIZE, 3*Math.PI/2, 0, height - BORDER_SIZE);
			graphics.beginGradientFill(GradientType.LINEAR, [BKG_COLOR, BKG_COLOR], [0, TRANSPARENCY_FRAC], [0, 255], mat);
			graphics.drawRect(BORDER_SIZE, height - BORDER_SIZE, width - 2 * BORDER_SIZE, BORDER_SIZE);
			graphics.endFill();
			graphics.beginFill(BKG_COLOR, TRANSPARENCY_FRAC);
			graphics.drawRect(BORDER_SIZE, BORDER_SIZE, width - 2 * BORDER_SIZE, height - 2 * BORDER_SIZE);
			graphics.endFill();
			mat.createGradientBox(2 * BORDER_SIZE, 2 * BORDER_SIZE, 0, 0, 0);
			graphics.beginGradientFill(GradientType.RADIAL, [BKG_COLOR, BKG_COLOR], [TRANSPARENCY_FRAC, 0], [0, 255], mat);
			graphics.drawRect(0, 0, BORDER_SIZE, BORDER_SIZE);
			graphics.endFill();
			mat.createGradientBox(2 * BORDER_SIZE, 2 * BORDER_SIZE, 0, 0, height - 2 * BORDER_SIZE);
			graphics.beginGradientFill(GradientType.RADIAL, [BKG_COLOR, BKG_COLOR], [TRANSPARENCY_FRAC, 0], [0, 255], mat);
			graphics.drawRect(0, height - BORDER_SIZE, BORDER_SIZE, BORDER_SIZE);
			graphics.endFill();
			mat.createGradientBox(2 * BORDER_SIZE, 2 * BORDER_SIZE, 0, width - 2 * BORDER_SIZE, 0);
			graphics.beginGradientFill(GradientType.RADIAL, [BKG_COLOR, BKG_COLOR], [TRANSPARENCY_FRAC, 0], [0, 255], mat);
			graphics.drawRect(width - BORDER_SIZE, 0, BORDER_SIZE, BORDER_SIZE);
			graphics.endFill();
			mat.createGradientBox(2 * BORDER_SIZE, 2 * BORDER_SIZE, 0, width - 2 * BORDER_SIZE, height - 2 * BORDER_SIZE);
			graphics.beginGradientFill(GradientType.RADIAL, [BKG_COLOR, BKG_COLOR], [TRANSPARENCY_FRAC, 0], [0, 255], mat);
			graphics.drawRect(width - BORDER_SIZE, height - BORDER_SIZE, BORDER_SIZE, BORDER_SIZE);
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
		
		/**
		 * Sets the text to appear in the box.
		 * @param	text The text to display in the box. HTML tags allowed.
		 */
		public function setText(text:String):void {
			field.htmlText = text;
		}
		
	}

}