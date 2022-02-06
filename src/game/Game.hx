import h2d.Text;
import dn.Process;

class Game extends Process {
	public static var ME : Game;

	public var app(get,never) : App; inline function get_app() return App.ME;

	public var hero: en.Hero;
	public var enemies : Array<Enemy> = [];

	public var turretBuff=0.;

	/** Game controller (pad or keyboard) **/
	public var ca : ControllerAccess<GameAction>;

	/** Particles **/
	public var fx : Fx;

	/** Basic viewport control **/
	public var camera : Camera;

	/** Drop manager* */
	public var drop : en.Drop;

	/** Container of all visual game objects. Ths wrapper is moved around by Camera. **/
	public var scroller : h2d.Layers;

	/** Level data **/
	public var level : Level;

	/** UI **/
	public var hud : ui.Hud;

	public var options: Array<InteractableData> = [];
	public var perkTitle: h2d.Text;


	// Bool for the game loop
	public var isPlaying:Bool;

	//Value for the turrets
	public var turrets=0;

	/** Slow mo internal values**/
	var curGameSpeed = 1.0;
	var slowMos : Map<String, { id:String, t:Float, f:Float }> = new Map();

	public function onGameStart(){
		debug("Game Started!");
		spawnEnemy();
	}
	public function spawnEnemy(){
		for(i in 0...turrets){
			var e = new en.Enemy(1);
			e.setPosCase(level.data.l_Entities.all_Enemy[i].cx,level.data.l_Entities.all_Enemy[i].cy);
			e.nextWaypoint = level.data.l_Entities.all_Waypoint[0];
			enemies.push(e);
		}
		cd.setS("Spawned",1.5);
	}

	public function new() {
		super(App.ME);

		ME = this;
		ca = App.ME.controller.createAccess();
		ca.lockCondition = isGameControllerLocked;
		createRootInLayers(App.ME.root, Const.DP_BG);

		isPlaying = false;

		drop = new en.Drop(531);

		scroller = new h2d.Layers();
		root.add(scroller, Const.DP_BG);
		scroller.filter = new h2d.filter.Nothing(); // force rendering for pixel perfect

		fx = new Fx();
		hud = new ui.Hud();
		camera = new Camera();

		createInteractable();

		hud.jamText();
		hud.coinsTextGen();

		startLevel(Assets.worldData.all_levels.FirstLevel);
	}


	public function createInteractable(){
		var n = 30;


		var tf = new h2d.Text(Assets.fontPixel);
		tf.text = "Select your perk!";
		tf.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		tf.dropShadow = {dx:1,dy:1,color:0,alpha:1};
		tf.scaleX = 5;
		tf.scaleY = 5;
		tf.x = 180;
		tf.y = 30;
		root.add(tf, Const.DP_UI);
		perkTitle = tf;


		for(i in 0...3){
			var i = new h2d.Interactive(240,280);
			i.onClick = function(_) selectOption();
			var tf = new h2d.Graphics();
			tf.scaleX = 10;
			tf.scaleY = 10;
			tf.x = Std.int(n);
			tf.y = Std.int(150);
			n = n + 250;
			i.x = tf.x;
			i.y = tf.y;
			i.backgroundColor = Color.randomColor();
			var s = Assets.tiles.h_get(Assets.tilesDict.interactable, tf);
			root.add(i, Const.DP_UI);
			root.add(tf, Const.DP_UI);


			var t = new h2d.Text(Assets.fontPixel);
			t.text = "Test Perk";
			t.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
			t.dropShadow = {dx:.5,dy:1,color:0,alpha:.75};
			t.scaleX = 2;
			t.scaleY = 2;
			t.x = tf.x + 8;
			t.y = tf.y + 10;
			root.add(t, Const.DP_UI);

			var tx = new h2d.Text(Assets.fontPixel);
			tx.text = "Test perk! select this perk for something, later this will be changed to buffs and nerfs for the core of the game";
			tx.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
			tx.dropShadow = {dx:.5,dy:1,color:0,alpha:.75};
			tx.scaleX = 1;
			tx.scaleY = 1;
			tx.x = tf.x + 18;
			tx.maxWidth = 190;
			tx.y = tf.y + 75;
			root.add(tx, Const.DP_UI);


			i.onOver = function(_){
				s = Assets.tiles.h_get(Assets.tilesDict.interactableSelected, tf);
				t.textColor = Color.hexToInt("#FFFF00");
				tx.textColor = Color.hexToInt("#FFFF00");
			}
			i.onOut = function(_){
				s = Assets.tiles.h_get(Assets.tilesDict.interactable, tf);
				t.textColor = Color.hexToInt("#FFFFFF");
				tx.textColor = Color.hexToInt("#FFFFFF");
			}
			
			var d = new InteractableData(i,tf, t, tx);
			options.push(d);
		}
	}

	public function selectOption(){
		for(i in options){
			root.removeChild(i.button);
			root.removeChild(i.sprite);
			root.removeChild(i.textX);
			root.removeChild(i.textY);
		}
		root.removeChild(perkTitle);
		isPlaying = true;
	}

	public static function isGameControllerLocked() {
		return !exists() || ME.isPaused() || App.ME.anyInputHasFocus();
	}


	public static inline function exists() {
		return ME!=null && !ME.destroyed;
	}


	/** Load a level **/
	function startLevel(l:World.World_Level) {
		if( level!=null )
			level.destroy();
		fx.clear();
		for(e in Entity.ALL) // <---- Replace this with more adapted entity destruction (eg. keep the player alive)
			e.destroy();
		garbageCollectEntities();
		trace(l.toString());

		level = new Level(l);
		// <---- Here: instanciate your level entities

		camera.centerOnTarget();
		hud.onLevelStart();
		Process.resizeAll();
	}



	/** Called when either CastleDB or `const.json` changes on disk **/
	@:allow(assets.Assets)
	function onDbReload() {
		hud.notify("DB reloaded");
	}


	/** Called when LDtk file changes on disk **/
	@:allow(assets.Assets)
	function onLdtkReload() {
		hud.notify("LDtk reloaded");
		if( level!=null )
			startLevel( Assets.worldData.getLevel(level.data.uid) );
	}

	/** Window/app resize event **/
	override function onResize() {
		super.onResize();
	}


	/** Garbage collect any Entity marked for destruction. This is normally done at the end of the frame, but you can call it manually if you want to make sure marked entities are disposed right away, and removed from lists. **/
	public function garbageCollectEntities() {
		if( Entity.GC==null || Entity.GC.length==0 )
			return;

		for(e in Entity.GC)
			e.dispose();
		Entity.GC = [];
	}

	/** Called if game is destroyed, but only at the end of the frame **/
	override function onDispose() {
		super.onDispose();

		fx.destroy();
		for(e in Entity.ALL)
			e.destroy();
		garbageCollectEntities();
	}


	/**
		Start a cumulative slow-motion effect that will affect `tmod` value in this Process
		and all its children.

		@param sec Realtime second duration of this slowmo
		@param speedFactor Cumulative multiplier to the Process `tmod`
	**/
	public function addSlowMo(id:String, sec:Float, speedFactor=0.3) {
		if( slowMos.exists(id) ) {
			var s = slowMos.get(id);
			s.f = speedFactor;
			s.t = M.fmax(s.t, sec);
		}
		else
			slowMos.set(id, { id:id, t:sec, f:speedFactor });
	}


	/** The loop that updates slow-mos **/
	final function updateSlowMos() {
		// Timeout active slow-mos
		for(s in slowMos) {
			s.t -= utmod * 1/Const.FPS;
			if( s.t<=0 )
				slowMos.remove(s.id);
		}

		// Update game speed
		var targetGameSpeed = 1.0;
		for(s in slowMos)
			targetGameSpeed*=s.f;
		curGameSpeed += (targetGameSpeed-curGameSpeed) * (targetGameSpeed>curGameSpeed ? 0.2 : 0.6);

		if( M.fabs(curGameSpeed-targetGameSpeed)<=0.001 )
			curGameSpeed = targetGameSpeed;
	}


	/**
		Pause briefly the game for 1 frame: very useful for impactful moments,
		like when hitting an opponent in Street Fighter ;)
	**/
	public inline function stopFrame() {
		ucd.setS("stopFrame", 0.2);
	}


	/** Loop that happens at the beginning of the frame **/
	override function preUpdate() {
		super.preUpdate();

		for(e in Entity.ALL) if( !e.destroyed ) e.preUpdate();
	}

	/** Loop that happens at the end of the frame **/
	override function postUpdate() {
		super.postUpdate();

		// Update slow-motions
		updateSlowMos();
		baseTimeMul = ( 0.2 + 0.8*curGameSpeed ) * ( ucd.has("stopFrame") ? 0.3 : 1 );
		Assets.tiles.tmod = tmod;

		// Entities post-updates
		for(e in Entity.ALL) if( !e.destroyed ) e.postUpdate();

		// Entities final updates
		for(e in Entity.ALL) if( !e.destroyed ) e.finalUpdate();

		// Dispose entities marked as "destroyed"
		garbageCollectEntities();
	}


	/** Main loop but limited to 30 fps (so it might not be called during some frames) **/
	override function fixedUpdate() {
		super.fixedUpdate();

		// Entities "30 fps" loop
		for(e in Entity.ALL) if( !e.destroyed ) e.fixedUpdate();
	}


	/** Main loop **/
	override function update() {
		super.update();

		// Entities main loop
		for(e in Entity.ALL) if( !e.destroyed ) e.update();

		if(!cd.has("Spawned") && hero.gameStarted){
			spawnEnemy();
		}


		// Global key shortcuts
		if( !App.ME.anyInputHasFocus() && !ui.Modal.hasAny() && !Console.ME.isActive() ) {

			// Exit by pressing ESC twice
			#if hl
			if( ca.isKeyboardPressed(K.ESCAPE) )
				if( !cd.hasSetS("exitWarn",3) )
					hud.notify(Lang.t._("Press ESCAPE again to exit."));
				else
					App.ME.exit();
			#end

			// Attach debug drone (CTRL-SHIFT-D)
			#if debug
			if( ca.isKeyboardPressed(K.D) && ca.isKeyboardDown(K.CTRL) && ca.isKeyboardDown(K.SHIFT) )
				new DebugDrone(); // <-- HERE: provide an Entity as argument to attach Drone near it
			#end

			// Restart whole game
			if( ca.isPressed(Restart) )
				App.ME.startGame();

		}
	}

	public function debug(str:String){
		#if debug
		trace(str);
		#end
	}
}

class InteractableData{
	public var button:h2d.Interactive;
	public var sprite:h2d.Graphics;
	public var textX:h2d.Text;
	public var textY:h2d.Text;

	public function new(x:h2d.Interactive,y:h2d.Graphics,z:h2d.Text,c:h2d.Text){
		button = x;
		sprite = y;
		textX = z;
		textY = c;
	}
}

