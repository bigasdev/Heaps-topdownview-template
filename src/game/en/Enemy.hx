package en;



class Enemy extends Entity {
	var number: Int;
	var speed = 0.03;

	public var nextWaypoint: Entity_Waypoint;


	// This is TRUE if the player is not falling

	public function new(x:Int) {
		super(5,5);

		// Start point using level entity "PlayerStart"
		var start = level.data.l_Entities.all_Enemy[x];
		if( start!=null )
			setPosCase(start.cx, start.cy);


		//number = start.f_Integer;

		// Placeholder display
		spr.set(Assets.tiles);
		spr.set("fxCircle7");
		spr.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		spr.setCenterRatio(0.5,0.5);
		spr.alpha = 1;
		Game.ME.scroller.add(spr, Const.DP_MAIN);

		initLife(3);

		say("3");
	}

	override function onDamage(dmg:Int, from:Entity){
		blink(Color.rgbToInt(Color.WHITE));
		sayingText.text = Std.string(life);
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
	override function beforeDestroy(){
		game.enemies.remove(this);
		new Coin(cx,cy);
		fx.bigExplode(cx,cy);
	}

	override function fixedUpdate() {
		super.fixedUpdate();


		if(nextWaypoint !=null){
			var d = distCase(nextWaypoint.cx,nextWaypoint.cy);
			if(d > 0.0015){
				if(cx < nextWaypoint.cx){
					dx += speed*tmod;
				}
				if(cx > nextWaypoint.cx){
					dx -= speed*tmod;
				}
				if(cy < nextWaypoint.cy){
					dy += speed*tmod;
				}
				if(cy > nextWaypoint.cy){
					dy -= speed*tmod;
				}
			}
			if(d > 0.1 && d < 0.3){
				var next = level.data.l_Entities.all_Waypoint[nextWaypoint.f_Integer+1];
				if(next != null){
					nextWaypoint = next;
				}
			}
		}
		// Gravity
		/*if( !onGround )
			dy+=0.05;*/
	}
}