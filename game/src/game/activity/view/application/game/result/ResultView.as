package game.activity.view.application.game.result
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.activity.BaseMediator;
	import game.activity.view.application.game.GameView;
	import game.activity.view.application.game.ShipViewDescription;
	import game.application.data.DataProvider;
	import game.application.data.game.ShipData;

	public class ResultView extends Sprite
	{
		private const SHOW_TIME			:Number = 0.3;
		
		public static const MENU		:String = "menu";
		public static const REVANGE		:String = "revange";
		public static const PLAY_AGAIN	:String = "play_again";
		
		private var tween				:TweenLite;
		
		private var viewLink			:MovieClip;
		
		public function ResultView()
		{
			init();
		}
		
		private function init():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("ResultWindow");
			
			viewLink = new classInstance();
			this.addChild( viewLink );	
			
			viewLink.alpha = 0;
			
			this.addEventListener(MouseEvent.CLICK, handlerMouseClick);

			setUser();
			setOponent();
			
//			trace(DataProvider.getInstance().getGameDataProvider());
			
			tween = TweenLite.to(viewLink, SHOW_TIME, {alpha:1});			
		}
		
		private function setUser():void
		{
//			(viewLink.getChildByName("user_name") as TextField).text = DataProvider.getInstance().getGameDataProvider().user.name;
//			(viewLink.getChildByName("user_points") as TextField).text = DataProvider.getInstance().getGameDataProvider().user.points.toString();			
			
//			setShipsState(viewLink, GameView.getInstance().getUserShipsDescription());
		}
		
		private function setOponent():void
		{
//			(viewLink.getChildByName("oponent_name") as TextField).text = DataProvider.getInstance().getGameDataProvider().opponent.name;
//			(viewLink.getChildByName("opponent_points") as TextField).text = DataProvider.getInstance().getGameDataProvider().opponent.points.toString();	
			
//			setShipsState(viewLink, GameView.getInstance().getOponentShipsDescription());
		}
		
		private function setShipsState(shipsContainer:MovieClip, shipsDescription:Vector.<ShipViewDescription>):void
		{
			var oneCounter:int,	twoCounter:int, threeCounter:int;
			
			for (var i:int = 0; i < shipsDescription.length; i++) 
			{
				if(shipsDescription[i].sunk)
				{
					var decks:int = shipsDescription[i].deck;
					
					if(decks == 4)
					{					
						(shipsContainer.getChildByName("s4_1") as MovieClip).gotoAndStop(2);						
					}
					else if(decks == 3)
					{						
						threeCounter++;
						(shipsContainer.getChildByName("s3_" + threeCounter.toString()) as MovieClip).gotoAndStop(2);							
					}					
					else if(decks == 2)
					{
						twoCounter++;
						(shipsContainer.getChildByName("s2_" + twoCounter.toString()) as MovieClip).gotoAndStop(2);							
					}					
					else if(decks == 1)
					{
						oneCounter++;
						(shipsContainer.getChildByName("s1_" + oneCounter.toString()) as MovieClip).gotoAndStop(2);							
					}
				}
			}
		}
		
		private function setTexts():void
		{
			trace("!");
		}
		
		private function handlerMouseClick(e:MouseEvent):void
		{
			var name:String = e.target.name;
			
			switch(name)
			{
				case "menuBtn":
				{
					this.dispatchEvent( new Event(MENU) );	
					
					break;
				}
					
				case "revangeBtn":
				{
					this.dispatchEvent( new Event(REVANGE) );
					break;
				}
					
				case "playAgainBtn":
				{
					this.dispatchEvent( new Event(PLAY_AGAIN) );
					break;
				}
			}
		}
		
		public function destroy():void
		{
			this.removeEventListener(MouseEvent.CLICK, handlerMouseClick);
			this.removeChild( viewLink );	
			
			viewLink = null;
		}
	}
}