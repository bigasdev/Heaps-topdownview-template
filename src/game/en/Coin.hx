package en;



class Coin extends Entity {
	public var player:Hero;
	var speed=0.3;

	// This is TRUE if the player is not falling

	public function new(x:Int,y:Int) {
		super(x,y);

		// Start point using level entity "PlayerStart"


		//number = start.f_Integer;

		// Placeholder display
		spr.set(Assets.tiles);
		spr.set("coin");
		spr.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		spr.setCenterRatio(0.5,0.5);
		spr.alpha = 1;

		Game.ME.scroller.add(spr, Const.DP_FRONT);
	}

	override function dispose() {
		super.dispose();
	}


	/** X collisions **/
	/** Y collisions **/

	/**
		Control inputs are checked at the beginning of the frame.
		VERY IMPORTANT NOTE: because game physics only occur during the `fixedUpdate` (at a constant 30 FPS), no physics increment should ever happen here! What this means is that you can SET a physics value (eg. see the Jump below), but not make any calculation that happens over multiple frames (eg. increment X speed when walking).
	**/
	override function preUpdate() {
		super.preUpdate();
	}


	override function fixedUpdate() {
		super.fixedUpdate();


		var d = distCase(game.hero);
		if(d > 0.0015 && d < 3.25){
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

			if(d < .85){
				game.hero.coins++;
				fx.coinExplode(game.hero.cx,game.hero.cy);
				destroy();
			}
		}

		// Gravity
		/*if( !onGround )
			dy+=0.05;*/
	}
}