package VisualElements 
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * TitleBanner is a banner that is displayed on Title and Ending slides.
	 * @author Robert Cigna
	 */
	public class TitleBanner extends Sprite
	{
		private var fieldFormat:TextFormat;
		private var field:TextField;
        private var embArial:Class;
		
		/**
		 * Constructs a TitleBanner with the given position and size.
		 * @param	x The x coordinate of the TitleBanner.
		 * @param	y The y coordinate of the TitleBanner.
		 * @param	width The width of the TitleBanner.
		 * @param	height The height of the TitleBanner.
		 */
		public function TitleBanner(x:int, y:int, width:int, height:int) 
		{
			var fontsize:int = 48;
			
			this.x = x;
			this.y = y;
			
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(width, height, 0, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [0x334C80, 0x0F1F4C, 0x0F1F4C, 0x334C80], [.35, .75, .75, .35], [0, 85,171, 255], mat);
			graphics.moveTo(0, 0);
			graphics.lineStyle(1, 0xE5E5E5, 1, true);
			graphics.lineTo(width, 0);
			graphics.lineStyle(0,0,0);
			graphics.lineTo(width, height);
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			graphics.lineTo(0, height);
			graphics.lineStyle(0,0,0);
			graphics.lineTo(0, 0);
			graphics.endFill();
			
			fieldFormat = new TextFormat("embArial",fontsize,0xE5E5E5);
			fieldFormat.align = TextFormatAlign.CENTER;
			
			field = new TextField();
			field.embedFonts = true;
			field.defaultTextFormat = fieldFormat;
			field.width = width-2;
			field.height = height-2;
			field.x = 1;
			field.y = (height - 1.2 * fontsize) / 2;
			
			addChild(field);
		}
		
		/**
		 * Sets the text that appears on the banner.
		 * @param	text The text to appear on the banner. HTML tags allowed.
		 */
		public function setText(text:String):void {
			field.htmlText = text;
		}
		
	}

}