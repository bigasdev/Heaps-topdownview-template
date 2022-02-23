package en;



class Enemy extends Entity {
	var number: Int;
	var speed = 0.015;
	var diamondChance = 3;
	public var medkitChance = 0;


	// This is TRUE if the player is not falling

	public function new(x:Int,y:Int,h:Int) {
		super(5,5);

		// Start point using level entities
		var start = level.data.l_Entities.all_Enemy[x];
		if( start!=null )
			setPosCase(start.cx, start.cy);
		


		//number = start.f_Integer;

		// Placeholder display
		spr.set(Assets.tiles);
		spr.set("dino");
		spr.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		spr.alpha = 1;
		Game.ME.scroller.add(spr, Const.DP_MAIN);


		initLife(h);
		hpBar = new Entity.HpBar(this);
	}

	override function onDamage(dmg:Int, from:Entity){
		blink(Color.rgbToInt(Color.WHITE));
	}

	override function dispose() {
		super.dispose();
	}
	override function beforeDestroy(){
		super.beforeDestroy();
		game.enemies.remove(this);
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

		if(!game.isPlaying)return;
		// Gravity
		/*if( !onGround )
			dy+=0.05;*/
	}
}