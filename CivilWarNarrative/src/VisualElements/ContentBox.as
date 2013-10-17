package VisualElements 
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
    import flash.text.GridFitType;
	/**
	 * A ContentBox is the primary means of communicating text to the user. It it used for both the 
	 * story content and tangential prompts or information.
	 * @author Robert Cigna
	 */
	public class ContentBox extends Sprite
	{
		private var fieldFormat:TextFormat;
		private var field:TextField;
		
		[Embed(source="arial.ttf", 
                fontName = "embArial", 
                mimeType = "application/x-font", 
                fontWeight="normal", 
                fontStyle="normal", 
                unicodeRange="U+0020-U+007E", 
                advancedAntiAliasing="true", 
                embedAsCFF="false")]
        private var embArial:Class;
		
		/**
		 * Constructs the ContentBox with the given position and size.
		 * @param	x The x coordinate of the ContentBox.
		 * @param	y The y coordinate of the ContentBox.
		 * @param	width The width of the ContentBox.
		 * @param	height The height of the ContentBox. It should be at least 10.
		 */
		public function ContentBox(x:int, y:int, width:int, height:int) 
		{

			this.x = x;
			this.y = y;
			
			fieldFormat = new TextFormat("embArial", 18, 0xE5E5E5);
			fieldFormat.leftMargin = 10;
			
			field = new TextField();
			field.embedFonts = true;
			field.defaultTextFormat = fieldFormat;
			field.width = width - 10;
			//field.height = height - 10;
			field.x = 1;
			field.y = 1;
			field.autoSize = TextFieldAutoSize.LEFT;
			//field.background = true;
			//field.backgroundColor = 0x225a8e;
			field.multiline = true;
			field.wordWrap = true;
			addChild(field);
		}
		
		/**
		 * Sets the text to appear in the box. 
		 * @param	text The text to show in the box. HTML tags allowed.
		 */
		public function setText(text:String, size:int = 12):void {
			//fieldFormat.size = (int)(size * 1.2);
			//field.defaultTextFormat = fieldFormat;
			field.htmlText = text;
			var mat:Matrix = new Matrix();
			mat.createGradientBox(width, height, Math.PI / 2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [0x4a589e, 0x3d4983], [.65, .85], [0, 255], mat);
			graphics.moveTo(3, 0);
			graphics.lineStyle(1, 0x2c345d, 1, true);
			graphics.lineTo(width - 3, 0);
			graphics.curveTo(width, 0, width, 3);
			graphics.lineTo(width, height - 3);
			graphics.curveTo(width, height, width - 3, height);
			graphics.lineTo(3, height);
			graphics.curveTo(0, height, 0, height - 3);
			graphics.lineTo(0, 3);
			graphics.curveTo(0, 0, 3, 0);
			graphics.endFill();
		}
	}

}