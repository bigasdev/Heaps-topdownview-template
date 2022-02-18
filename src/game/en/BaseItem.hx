package en;



class BaseItem extends Entity {

	public var itemName = "";
	
	//Set this to true to move to the player
	public var moveToPlayer = false;

	var speed=0.3;
	var distanceCheck = 1;
	var playerDistanceMagnet = 5;

	public function new(x:Int,y:Int,z:String = "ItemBase") {
		super(x,y);
		itemName = z;

		// Sprite display

		/*spr.set(Assets.tiles);
		spr.set("coin");
		spr.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		spr.setCenterRatio(0.5,0.5);
		spr.alpha = 1;

		Game.ME.scroller.add(spr, Const.DP_FRONT);*/
	}
	override function update(){
		if(!game.isPlaying)return;

		var d = distCase(game.hero);
		if(d < distanceCheck){
			onItemPick();
		}
	}

	//Set every parameter for the pickup event here
	function onItemPick(){
		game.debug("Added to the inventory: "+itemName);
		destroy();
	}

	override function fixedUpdate() {
		super.fixedUpdate();

		if(!game.isPlaying || !moveToPlayer)return;


		var d = distCase(game.hero);
		if(d > 0.0015 && d < playerDistanceMagnet){
			if(cx < game.hero.cx){
				dx += speed*tmod;
			}
			if(cx > game.hero.cx){
				dx -= speed*tmod;
			}
			if(cy < game.hero.cy){
				dy += speed*tmod;
			}
			if(cy > game.hero.cy){
				dy -= speed*tmod;
			}
		}

		// Gravity
		/*if( !onGround )
			dy+=0.05;*/
	}
}