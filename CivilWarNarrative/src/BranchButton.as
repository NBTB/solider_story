package  
{
	import flash.display.SimpleButton;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class BranchButton extends SimpleButton
	{
		public static const DEFAULT_TEXT:String = "Continue";    //The default text that appears on a button for a random or conditional branch.
		
		public var field:TextField;
		public var reference:String;
		
		public var stores:Boolean;
		public var key:String;
		public var value:String;
		
		public function BranchButton(text:String = "", reference:String = null, stores:Boolean = false, key:String = null, value:String = null) 
		{
			this.reference = reference;
			this.stores = stores;
			this.key = key;
			this.value = value;
			
			field = new TextField();
			field.width = 216;
			field.height = 30;
			field.border = true;
			field.textColor = 0xFFFFFF;
			field.text = text;
			
			super(field, field, field, field);
		}
		
		public function setText(text:String):void
		{
			field.text = text;
		}
		
	}

}