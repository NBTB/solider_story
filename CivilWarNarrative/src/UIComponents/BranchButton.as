package UIComponents
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Graphics;
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class BranchButton extends SimpleButton
	{
		public static const DEFAULT_TEXT:String = "Continue";        //The default text that appears on a button for a random or conditional branch.
		public static const DEFAULT_RETURN_TEXT:String = "Return";   //The default text for a button on an ending slide that takes the user back to the initial state.
		
		private var graphic:ButtonGraphic;
		private var hovergraphic:ButtonGraphic;
		public var reference:String;
		
		public var stores:Boolean;
		public var key:String;
		public var value:String;
		
		public function BranchButton(x:int, y:int, width:int, height:int)//text:String = "", reference:String = null, stores:Boolean = false, key:String = null, value:String = null) 
		{
			//this.reference = reference;
			//this.stores = stores;
			//this.key = key;
			//this.value = value;
			
			this.x = x;
			this.y = y;
			
			graphic = new ButtonGraphic(width, height, Slide.NORMAL_GRADIENT);
			hovergraphic = new ButtonGraphic(width, height, Slide.SELECTED_GRADIENT);
			super(graphic, hovergraphic, graphic, graphic);
		}
		
		public function setText(text:String):void
		{
			graphic.setText(text);
			hovergraphic.setText(text);
		}
		
		public function reset():void {
			//this.mouseEnabled = false;
			//this.mouseEnabled = true;
			dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, 0, 0, super, false, false, false, false, 0));
			dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT, true, false, 0, 0, super, false, false, false, false, 0));
		}
	}

}