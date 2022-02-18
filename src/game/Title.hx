import hxd.res.Image;
import sample.SampleGame;
import h2d.Text;
import dn.Process;

class Title extends Process {
	/** Game controller (pad or keyboard) **/
	public var ca : ControllerAccess<GameAction>;

	//Variables to control the text/images objects that will have the color changed in the start
	public var texts : Array<h2d.Text> = [];
	public var sprite: h2d.Object;

	var done = false;
	var speed = 0.02;

	/** Particles **/
	/** Container of all visual game objects. Ths wrapper is moved around by Camera. **/
	public var scroller : h2d.Layers;

	public function new() {
		super(App.ME);
		ca = App.ME.controller.createAccess();
		createRootInLayers(App.ME.root, Const.DP_UI);


		scroller = new h2d.Layers();
		root.add(scroller, Const.DP_BG);
		scroller.filter = new h2d.filter.ColorMatrix(); // force rendering for pixel perfect

		logoAndText("", Color.hexToInt("#f5da42"));
		createButton("Press start to continue");

		Process.resizeAll();
	}

	/** CDB file changed on disk**/
	public function onCdbReload() {}


	/** Window/app resize event **/
	override function onResize() {
		super.onResize();
		scroller.setScale(Const.SCALE);
	}

	//Function to create a button **It works with the spacebar/enter as well**
	public function createButton(str:Dynamic, ?c=0xffcc00){
		var i = new h2d.Interactive(150,150);
		i.onClick = function(_)startGame();
		var tf = new h2d.Text(Assets.fontPixel);
		root.add(i, Const.DP_UI);


		root.add(tf, Const.DP_UI);
		tf.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		tf.dropShadow = {dx:1,dy:1,color:0,alpha:1};
		tf.text = Std.string(str);
		tf.textColor = c;
		tf.scaleX = 2;
		tf.scaleY = 2;
		tf.x = Std.int(w() / 2 - tf.textWidth * 2 + 115);
		tf.y = Std.int(h() / 2);
		i.x = tf.x;
		i.y = tf.y;
		texts.push(tf);
	}

	//Function to add a logo/image and my @text
	public function logoAndText(str:Dynamic, ?c=0xffcc00) {

		//Logo
		var tf = new h2d.Object();
		var s = Assets.tiles.h_get(Assets.tilesDict.logo, tf);
		root.add(tf, Const.DP_UI);
		tf.scaleX = 8;
		tf.scaleY = 8;
		tf.x = Std.int(w() / 2  - 200	);
		tf.y = Std.int(h() / 2 - 140);

		sprite = tf;

		//@ Text
		var tf = new h2d.Text(Assets.fontPixelSmall);
		tf.text = "@ bigasdev\nVERSION 0.1";
		tf.dropShadow = {dx:1,dy:1,color: 0, alpha:1};
		root.add(tf, Const.DP_UI);
		tf.y = 525;
		tf.x = 325;
		tf.scaleX = 2;
		tf.scaleY = 2;
		tf.alpha = .5;
		tf.textColor = 0xffffff;

		texts.push(tf);
	}

	/** Called if game is destroyed, but only at the end of the frame **/
	override function onDispose() {
		super.onDispose();
		ca.dispose();
	}

	/** Loop that happens at the beginning of the frame **/
	override function preUpdate() {
		super.preUpdate();

	}

	/** Loop that happens at the end of the frame **/
	override function postUpdate() {
		super.postUpdate();
		

		if(done){
			for(t in texts){
				sprite.alpha = M.fmax(-1 , sprite.alpha - speed*0.5*tmod);
				t.color.r = M.fmax(-1, t.color.r - speed*tmod );
				t.color.g = M.fmax(-1, t.color.g - speed*tmod );
				t.color.b = M.fmax(-1, t.color.b - speed*tmod );
				if( t.color.r<=-1 && t.color.g<=-1 && t.color.b<=-1) {
					new sample.SampleGame();
					destroy();
				}
			}
		}
	}

	/** Main loop but limited to 30fps (so it might not be called during some frames) **/
	override function fixedUpdate() {
		super.fixedUpdate();

	}
	function startGame(){
		if(done)return;
		Assets.SFXLib.explosion1(0.1);
		done = true;
		/*new sample.SampleGame();
		destroy();*/
	}
	/** Main loop **/
	override function update() {
		super.update();

		if( ca.isPressed(Pause) ){
			if( !cd.hasSetS("exitWarn",3) )
				trace(Lang.t._("Press ESCAPE again to exit."));
			else
				hxd.System.exit();
		}

			// Restart
		if( ca.isPressed(Start)){
			startGame();
		}

	}
}

