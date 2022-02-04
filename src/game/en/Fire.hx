package en;



class Fire extends Entity {
	public var enemy:Enemy;
	var speed=0.3;

	// This is TRUE if the player is not falling

	public function new(x:Int,y:Int) {
		super(x,y);

		// Start point using level entity "PlayerStart"


		//number = start.f_Integer;

		// Placeholder display
		spr.set(Assets.tiles);
		spr.set("fxImpact1");
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


		if(enemy!=null){
			var d = distCase(enemy);
			if(d > 0.0015){
				if(cx < enemy.cx){
					dx += speed*tmod;
				}
				if(cx > enemy.cx){
					dx -= speed*tmod;
				}
				if(cy < enemy.cy){
					dy += speed*tmod;
				}
				if(cy > enemy.cy){
					dy -= speed*tmod;
				}
			}

			if(d < 1){
				enemy.hit(1, this);
				destroy();
			}
		}
		// Gravity
		/*if( !onGround )
			dy+=0.05;*/
	}
}