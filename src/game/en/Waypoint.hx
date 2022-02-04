package en;



class Waypoint extends Entity {
	var number: Int;

	// This is TRUE if the player is not falling

	public function new(x:Int) {
		super(5,5);

		// Start point using level entity "PlayerStart"
		var start = level.data.l_Entities.all_Waypoint[x];
		if( start!=null )
			setPosCase(start.cx, start.cy);


		//number = start.f_Integer;

		// Placeholder display
		#if debug
		spr.set(Assets.tiles);
		spr.set("fxCircle15");
		spr.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		spr.setCenterRatio(0.5,0.5);
		spr.colorize(Color.randomColor());
		spr.alpha = .05;
		#end
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


		var i = distCase(game.hero);

		if(i < 1.5){
			
		}
		// Gravity
		/*if( !onGround )
			dy+=0.05;*/
	}
}