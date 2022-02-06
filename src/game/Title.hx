import sample.SampleGame;
import h2d.Text;
import dn.Process;

class Title extends Process {
	/** Game controller (pad or keyboard) **/
	public var ca : ControllerAccess<GameAction>;

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

		trace(Lang.t._("Title is ready!"));
		bigText("PROJECT DOOM", Color.hexToInt("#f5da42"));
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
	public function createButton(str:Dynamic, ?c=0xffcc00){
		var tf = new h2d.Text(Assets.fontPixel);
		root.add(tf, Const.DP_UI);
		tf.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		tf.dropShadow = {dx:1,dy:1,color:0,alpha:1};
		tf.text = Std.string(str);
		tf.textColor = c;
		tf.scaleX = 2;
		tf.scaleY = 2;
		tf.x = Std.int(w() / 2 - tf.textWidth * 2 + 115);
		tf.y = Std.int(h() / 2);
	}

	public function bigText(str:Dynamic, ?c=0xffcc00) {
		var tf = new h2d.Text(Assets.fontPixel);
		root.add(tf, Const.DP_UI);
		tf.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		tf.dropShadow = {dx:1,dy:1,color:0,alpha:1};
		tf.text = Std.string(str);
		tf.textColor = c;
		tf.scaleX = 5;
		tf.scaleY = 5;
		tf.x = Std.int(w() / 2 - tf.textWidth * 2 - 40);
		tf.y = Std.int(h() / 2 - 200);


		var tf = new h2d.Text(Assets.fontPixel);
		tf.text = "MageJam2022";
		tf.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		tf.dropShadow = {dx:1,dy:1,color: 0, alpha:1};
		tf.maxWidth = 0.1 * w()/Const.UI_SCALE;
		root.add(tf, Const.DP_UI);
		tf.y = 565;
		tf.x = 645;
		tf.scaleX = 2;
		tf.scaleY = 2;
		tf.alpha = .5;
		tf.textColor = 0xffffff;

		var tf = new h2d.Text(Assets.fontPixel);
		tf.text = "VERSION 0.01";
		tf.filter = new dn.heaps.filter.PixelOutline(0x00000, 1);
		tf.dropShadow = {dx:1,dy:1,color: 0, alpha:1};
		root.add(tf, Const.DP_UI);
		tf.y = 565;
		tf.x = 325;
		tf.scaleX = 2;
		tf.scaleY = 2;
		tf.alpha = .5;
		tf.textColor = 0xffffff;
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

	}

	/** Main loop but limited to 30fps (so it might not be called during some frames) **/
	override function fixedUpdate() {
		super.fixedUpdate();

	}
	function startGame(){
		new sample.SampleGame();
		destroy();
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

