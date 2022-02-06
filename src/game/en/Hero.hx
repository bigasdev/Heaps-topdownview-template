package en;

/**
	SamplePlayer is an Entity with some extra functionalities:
	- falls with gravity
	- has basic level collisions
	- controllable (using gamepad or keyboard)
	- some squash animations, because it's cheap and they do the job
**/

class Hero extends Entity {
	var ca : ControllerAccess<GameAction>;
	var walkSpeed = 0.;
	var walkSpeedY = 0.;
	var anims = dn.heaps.assets.Aseprite.getDict(hxd.Res.atlas.hero);

	public var coins=0;

	public var turret:en.Turret;
	public var gameStarted:Bool;

	public function closeToTurret() : Bool{
		return turret != null;
	}

	// This is TRUE if the player is not falling
	var onGround(get,never) : Bool;
		inline function get_onGround() return !destroyed && dy==0 && yr==1 && level.hasCollision(cx,cy+1);


	public function new() {
		super(5,5);

		// Start point using level entity "PlayerStart"
		var start = level.data.l_Entities.all_PlayerStart[0];
		if( start!=null )
			setPosCase(start.cx, start.cy);

		// Misc inits
		frictX = 0;
		frictY = 0;

		// Camera tracks this
		camera.trackEntity(this, true);
		camera.clampToLevelBounds = true;

		// Init controller
		ca = App.ME.controller.createAccess();
		ca.lockCondition = Game.isGameControllerLocked;

		// Placeholder display
		spr.set(Assets.hero);
		spr.set("Idle");
		spr.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		spr.anim.registerStateAnim(anims.Walk,1,1,()->M.fabs(dxTotal)>0.05);
		spr.anim.registerStateAnim(anims.Idle,1,1,()->M.fabs(dxTotal)<0.04);

		Game.ME.scroller.add(spr, Const.DP_FRONT);
	}


	override function dispose() {
		super.dispose();
		ca.dispose(); // don't forget to dispose controller accesses
	}
	function turretStuff(){
		if(closeToTurret()){
			turret.spr.alpha = 1;
			turret.say("Build your first turret here", Color.randomColor());
			var d = distCase(turret);
			if(d > 1.75){
				turret.removeFromPlayer();
				turret = null;
			}
		}
	}

	/** X collisions **/
	override function onPreStepX() {
		super.onPreStepX();

		// Right collision
		if( xr>0.8 && level.hasCollision(cx+1,cy) )
			xr = 0.8;

		// Left collision
		if( xr<0.2 && level.hasCollision(cx-1,cy) )
			xr = 0.2;
	}


	/** Y collisions **/
	override function onPreStepY() {
		super.onPreStepY();

		// Land on ground
		if( yr>1 && level.hasCollision(cx,cy+1) ) {
			dy = 0;
			yr = 1;
		}

		// Ceiling collision
		if( yr<0.2 && level.hasCollision(cx,cy-2) )
			yr = 0.2;
	}


	/**
		Control inputs are checked at the beginning of the frame.
		VERY IMPORTANT NOTE: because game physics only occur during the `fixedUpdate` (at a constant 30 FPS), no physics increment should ever happen here! What this means is that you can SET a physics value (eg. see the Jump below), but not make any calculation that happens over multiple frames (eg. increment X speed when walking).
	**/
	override function preUpdate() {
		super.preUpdate();

		if(!game.isPlaying)return;

		walkSpeed = 0;
		walkSpeedY = 0;
		/*if( onGround )
			cd.setS("recentlyOnGround",0.1); // allows "just-in-time" jumps*/


		// Jump
		/*if( cd.has("recentlyOnGround") && ca.isPressed(Jump) ) {
			dy = -0.85;
			setSquashX(0.6);
			cd.unset("recentlyOnGround");
			fx.dotsExplosionExample(centerX, centerY, 0xffcc00);
			ca.rumble(0.05, 0.06);
		}*/

		if(!cd.has("shoot") && ca.isPressed(Shoot)){
			if(!closeToTurret())return;
			turret.enableTurret();
			game.debug(Std.string(game.drop.dropSeed.random(15)));
			if(!gameStarted){
				gameStarted = true;
				game.onGameStart();
			}
			cd.setS("shoot", .2);
		}

		// Walk
		if( ca.getAnalogDist(MoveX)>0) {
			// As mentioned above, we don't touch physics values (eg. `dx`) here. We just store some "requested walk speed", which will be applied to actual physics in fixedUpdate.
			walkSpeed = ca.getAnalogValue(MoveX); // -1 to 1
		}

		if( ca.getAnalogDist(MoveY)>0){

			walkSpeedY = ca.getAnalogValue(MoveY);
		}
	}


	override function fixedUpdate() {
		super.fixedUpdate();
		turretStuff();

		// Gravity
		/*if( !onGround )
			dy+=0.05;*/

		var speed = 0.25;

		if( walkSpeed!=0 && walkSpeedY!=0){
			speed = 0.15;
		}

		// Apply requested walk movement
		if( walkSpeed!=0 ) {
			dx += walkSpeed * speed;
		}

		if(walkSpeedY!=0){
			dy += walkSpeedY * speed;
		}
	}
}