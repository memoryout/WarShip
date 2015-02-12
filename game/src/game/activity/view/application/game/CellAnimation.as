package game.activity.view.application.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import game.activity.BaseMediator;
	import game.application.data.game.ShipData;

	public class CellAnimation extends Sprite
	{
		public static const USERT_TYPE:		String = "user";
		public static const OPPONENT_TYPE:	String = "oponent";
		
		public static const ADD_SHOOT_EVENT:	String = "add_shoot";
		public static const FINISH_HIT_EVENT:	String = "finish_hit";
		public static const FINISH_SUNK_EVENT:	String = "finish_sunk";
		
		public static const ADD_BROKEN_EVENT:	String = "add_broken";
		public static const ADD_HITED_EVENT:	String = "add_hited";
		
		public static const HIT_FIRE_ANI:		String = "hitFire";
		public static const HIT_WATER_ANI:		String = "hitWater";
		
		public static const HIT_FIRE_FOUR:		String = "hitFireFour";
		public static const HIT_FIRE_THREE:		String = "hitFireThree";
		public static const HIT_FIRE_TWO:		String = "hitFireTwo";
		public static const HIT_FIRE_ONE:		String = "hitFireOne";
		
		public static const SHOOTED_ANI:		String = "shootedAni";
		
		public static const SELECTED_EMPTY:		int = 0;
		public static const HIT_SHIP:			int = 1;
		public static const SUNK_SHIP:			int = 2;
		
		private var correctionForSunAnimation:	Array = [71, 100, 172, 216];
		
		private var _addBrokenShipCall:			Function;
		private var _addTableCall:				Function;
		
		private var shootedAnimationUserContainer:		Array = new Array();
		private var shootedAnimationOpponentContainer:	Array = new Array();
		
		private var timeOutId:uint;
		
		public function CellAnimation()
		{
			mouseEnabled = false;
		}
		
		public function setSunkAnimation(xPosition:Number, yPosition:Number, ship:ShipData, addBrokenShipCall:Function, playerType:String):void
		{
			_addBrokenShipCall = addBrokenShipCall;
			
			var classInstance:Class,	animation:MovieClip;
			
			classInstance = BaseMediator.getSourceClass(getSunkAnimationName(ship.deck));
			
			if(classInstance)
			{
				animation = new classInstance();				
				classInstance = null;				
			}
			
			this.addChild(animation);	
			
			animation.name = "deck_" + ship.deck + "_dirrection_" + ship.dirrection + "_x_" + xPosition + "_y_" + yPosition;
			
			animation.x = xPosition;
			animation.y = yPosition;
			
			animation.mouseEnabled = false;
			
			if(ship.dirrection == 0)  
			{
				animation.rotation = 90;	
				animation.x += 	correctionForSunAnimation[ship.deck -1];			
			}		
			
			animation.addEventListener(FINISH_SUNK_EVENT, removeAnimation);	
			animation.addEventListener(ADD_BROKEN_EVENT, addBrokenShip);	
			
			animation.gotoAndPlay(2);		
			
//			setShootedAnimation(xPosition, yPosition, ship.x, ship.y, playerType);
		}
		
		private function addBrokenShip(e:Event):void
		{
			e.currentTarget.removeEventListener(ADD_BROKEN_EVENT, addBrokenShip);	
			
			var nameSplited:Array = e.currentTarget.name.split("_");
			
			_addBrokenShipCall(nameSplited[5], nameSplited[7], nameSplited[1], nameSplited[3]);
		}
		
		private function getSunkAnimationName(deckNumber:int):String
		{
			if(deckNumber == 4)
				return HIT_FIRE_FOUR;
			else if(deckNumber == 3)
				return HIT_FIRE_THREE;
			else if(deckNumber == 2)
				return HIT_FIRE_TWO;	
			else if(deckNumber == 1)
				return HIT_FIRE_ONE;
			
			return "";
		}
		
		public function setAnimation(animationParameters:Object, selectType:int, fieldPoint:Object, addTableCall:Function, playerType:String):void
		{	
			_addTableCall = addTableCall;
			
			var classInstance:Class,	animation:MovieClip;
						
			classInstance = BaseMediator.getSourceClass(getAnimationName(selectType));
			
			if(classInstance)
			{
				animation = new classInstance();				
				classInstance = null;				
			}
			
			this.addChild(animation);	
			
			animation.name = "pointX_" + fieldPoint.x + "_pointY_" + fieldPoint.y 
				+ "_x_" + animationParameters.xPosition + "_y_" + animationParameters.yPosition + "_frame_" + animationParameters.gotoTableFrame + "_userType_" + playerType;
			
			animation.x = animationParameters.xPosition;
			animation.y = animationParameters.yPosition;
			
			animation.mouseEnabled = false;
			
//			animation.scaleX = animation.scaleY = cellScale;		
			
			animation.addEventListener(FINISH_HIT_EVENT, removeAnimation);	
						
			animation.addEventListener(ADD_SHOOT_EVENT, addShootAni);	
			
			animation.addEventListener(ADD_HITED_EVENT, addHitedCell);	
			
			animation.gotoAndPlay(2);					
		}
		
		private function addShootAni(e:Event):void
		{
			e.currentTarget.removeEventListener(ADD_SHOOT_EVENT, addShootAni);	
			
			var nameSplited:Array = e.currentTarget.name.split("_");
			
			setShootedAnimation(nameSplited[5], nameSplited[7], nameSplited[1], nameSplited[3], nameSplited[11]);
		}
		
		public function setShootedAnimation(xPosition:Number, yPosition:Number, x:int, y:int, playerType:String, cellScale:Number = 1):void
		{
			var classInstance:Class,	animation:MovieClip;
			
			classInstance = BaseMediator.getSourceClass(SHOOTED_ANI);
			
			if(classInstance)
			{
				animation = new classInstance();				
				classInstance = null;				
			}
			
			this.addChildAt(animation, 0);	
			
			animation.x = xPosition;
			animation.y = yPosition;
			
			animation.mouseEnabled = false;
			
			animation.name = x + "_" + y;
			
//			animation.scaleX = animation.scaleY = cellScale;	
			
			if(playerType == USERT_TYPE)
				shootedAnimationUserContainer.push(animation);
			else if(playerType == OPPONENT_TYPE)
				shootedAnimationOpponentContainer.push(animation);
			
			animation.gotoAndPlay(2);		
		}
		
		public function removeShotedAnimation(playerType:String, coopdinates:Object = null):void
		{		
			var i:int;
			
			if(playerType == USERT_TYPE)
			{
				for (var j:int = 0; j < coopdinates.length; j++) 
				{
					for (i = 0; i < shootedAnimationUserContainer.length; i++) 
					{				
						var nameName:Array = shootedAnimationUserContainer[i].name.split("_");	
							
						if(uint(nameName[0]) == coopdinates[j].x && uint(nameName[1]) == coopdinates[j].y)
						{
							if(shootedAnimationUserContainer[i] && this.contains(shootedAnimationUserContainer[i]))
								removeChild(shootedAnimationUserContainer[i]);
						}
										
					}	
				}
				
			}
			else if(playerType == OPPONENT_TYPE)
			{
				
				for (i = 0; i < shootedAnimationOpponentContainer.length; i++) 
				{
					if(shootedAnimationOpponentContainer[i] && this.contains(shootedAnimationOpponentContainer[i]))
						removeChild(shootedAnimationOpponentContainer[i]);
				}
				
				shootedAnimationOpponentContainer = new Array();				
			}
		}
		
		private function addHitedCell(e:Event):void
		{
			e.currentTarget.removeEventListener(ADD_HITED_EVENT, addHitedCell);	
			
			var nameSplited:Array = e.currentTarget.name.split("_");
						
			_addTableCall({x:nameSplited[1], y:nameSplited[3]}, nameSplited[5], nameSplited[7], nameSplited[9]);
		}
		
		private function getAnimationName(animationType:int):String
		{
			if(animationType == SELECTED_EMPTY) 
				return HIT_WATER_ANI;
				
			else if(animationType == HIT_SHIP) 				
				return HIT_FIRE_ANI;
			
			return "";
		}
		
		private function removeAnimation(e:Event):void
		{
			if(this.contains(e.currentTarget as MovieClip)) 
				this.removeChild(e.currentTarget as MovieClip);
		}
		
		public function setShipShootAnimation(shipsDescriptionContainer:Vector.<ShipViewDescription>):void
		{		
			var i:int, shipLink:MovieClip, highRange:int;
			
			var randomShipShot:int = Math.random()*shipsDescriptionContainer.length;
			
			while(shipsDescriptionContainer[randomShipShot].sunk)
			{
				randomShipShot = Math.random()*shipsDescriptionContainer.length;
			}
			
			if(shipsDescriptionContainer[randomShipShot].deck == 4)
			{
				if(shipsDescriptionContainer[randomShipShot].dirrection == 0)
					highRange = 1;
				else
					highRange = 3;
				
				for (i = 0; i < highRange; i++) 
				{
					shipLink = shipsDescriptionContainer[randomShipShot].link;					
					
					timeOutId = setTimeout(addShotAnimation, 300*i, shipLink, i);
//					addShotAnimation(shipLink, i);
				}				
				
			}else if(shipsDescriptionContainer[randomShipShot].deck == 3)
			{
				if(shipsDescriptionContainer[randomShipShot].dirrection == 0)
					highRange = 1;
				else
					highRange = 2;
				
				for (i = 0; i < highRange; i++) 
				{
					shipLink = shipsDescriptionContainer[randomShipShot].link;					
					timeOutId = setTimeout(addShotAnimation, 300*i, shipLink, i);
//					addShotAnimation(shipLink, i);
				}				
				
			}else if(shipsDescriptionContainer[randomShipShot].deck == 2)
			{				
				shipLink = shipsDescriptionContainer[randomShipShot].link;								
				addShotAnimation(shipLink, 0);
				
			}else if(shipsDescriptionContainer[randomShipShot].deck == 1)
			{
				shipLink = shipsDescriptionContainer[randomShipShot].link;				
				addShotAnimation(shipLink, 0);
			}			
		}
		
		private function addShotAnimation(shipLink:MovieClip, pointIndex:int):void
		{
			var classInstance:Class = BaseMediator.getSourceClass("shotAni"), shotAni:MovieClip;			
			
			if(classInstance)
			{
				shotAni = new classInstance();				
				classInstance = null;	
			}	
			
			this.addChild(shotAni);
			shotAni.x = (shipLink.getChildByName("point_" + pointIndex) as MovieClip).x + shipLink.x;
			shotAni.y = (shipLink.getChildByName("point_" + pointIndex) as MovieClip).y + shipLink.y;
			
			shotAni.mouseEnabled = false;
			
			shotAni.addEventListener("finish_shot", removeAnimation);	
			shotAni.gotoAndPlay(2);		
		}	
	}
}