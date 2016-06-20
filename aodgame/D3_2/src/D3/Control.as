package D3
{
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

	internal class Control
	{
		private var bit:Bitte;

		public function Control(stage)
		{
			bit = Bitte.getInstance();
			Procedure(stage);
		}
		
		private function Procedure(stage)
		{
			stage.addEventListener(MouseEvent.CLICK,clii);
			function clii(event:MouseEvent):void
			{
				bit.cli=1;
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE,coord);
			function coord(event:MouseEvent):void
			{
				bit.sx=event.stageX;
				bit.sy=event.stageY;
			}

			stage.addEventListener(MouseEvent.MOUSE_UP, upClick);			
			function upClick(event:MouseEvent):void 
			{
				bit.dm=0;
			}
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, downClick);			
			function downClick(event:MouseEvent):void 
			{
				bit.dm=1;
			}		
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, forwardScroll);
			function forwardScroll(event:MouseEvent):void 
			{
				if (event.delta>0)
				{
					bit.scrollY=1;
				}
				if (event.delta<0)
				{
					bit.scrollY=-1;
				}
			}
			
			stage.addEventListener(KeyboardEvent.KEY_UP, keyPressedUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
						
			function keyPressedUp(event:KeyboardEvent)
			{
				if(event.keyCode ==37 || event.keyCode == 65) {bit.horiz = 0;}
				if(event.keyCode == 39 || event.keyCode == 68) {bit.horiz = 0;}
				if(event.keyCode == 38 || event.keyCode == 87) {bit.vertic = 0;} 
				if(event.keyCode == 40 || event.keyCode == 83) {bit.vertic = 0;}
			}			
			function keyPressedDown(event:KeyboardEvent)
			{
				if(event.keyCode ==37 || event.keyCode == 65) {bit.horiz = 1;}
				if(event.keyCode == 39 || event.keyCode == 68) {bit.horiz = 2;} 
				if(event.keyCode == 38 || event.keyCode == 87) {bit.vertic = 1;} 
				if(event.keyCode == 40 || event.keyCode == 83) {bit.vertic = 2;}
			}
		}	
		
	}	
}