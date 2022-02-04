package en;



class Turret extends Entity {
	var number: Int;
	var shootCd=1;

	// This is TRUE if the player is not falling

	public function new(x:Int) {
		super(5,5);

		// Start point using level entity "PlayerStart"
		var start = level.data.l_Entities.all_Turret[x];
		if( start!=null )
			setPosCase(start.cx, start.cy);


		number = start.f_Integer;

		// Placeholder display
		spr.set(Assets.tiles);
		spr.set(Std.string("turret"+number));
		spr.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		spr.setCenterRatio(0.5,0.5);
		spr.alpha = .5;
	}

	public function removeFromPlayer(){
		spr.alpha = .5;
		removeSay();
	}

	override function dispose() {
		super.dispose();
	}
	function shoot(){
		if(game.enemies.length>0){
			var f = new Fire(cx, cy);
			f.enemy = game.enemies[0];
		}
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

		if(d < 1.5){
			game.hero.turret = this;
		}

		if(!cd.has("turretShoot")){
			shoot();
			cd.setS("turretShoot", shootCd-game.turretBuff);
		}
		
		// Gravity
		/*if( !onGround )
			dy+=0.05;*/
	}
}