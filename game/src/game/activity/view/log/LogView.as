package game.activity.view.log
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class LogView extends Sprite
	{
		private var _txt:				TextField;
		
		public function LogView()
		{
			super();
			
			createSkin();
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		
		private function createSkin():void
		{
			_txt = new TextField();
			_txt.background = true;
			_txt.alpha = 0.7;
			_txt.width = 800;
			_txt.height = 500;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.defaultTextFormat = new TextFormat(null, 20);
			this.addChild( _txt);
		}
		
		
		public function addMessage(value:String):void
		{
			_txt.appendText( value + "\n\n" );
			_txt.scrollV = _txt.maxScrollV;
		}
	}
}