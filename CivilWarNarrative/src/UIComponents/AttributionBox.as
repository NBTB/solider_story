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
	public class AttributionBox extends Sprite
	{
		private var fieldFormat:TextFormat;
		private var field:TextField;
		
		public function AttributionBox() 
		{
			fieldFormat = new TextFormat();
			fieldFormat.size = 9;
			fieldFormat.font = "Arial";
			fieldFormat.color = 0xFFFFFF;
			fieldFormat.align = TextFormatAlign.RIGHT;
			
			field = new TextField();
			field.defaultTextFormat = fieldFormat;
			//field.x = 530;
			//field.y = 395;
			field.width = 216;
			field.height = 75;
			//field.border = true;
			field.wordWrap = true;
			
			addChild(field);
		}
		
		public function setText(text:String):void {
			field.text = text;
		}
		
	}

}