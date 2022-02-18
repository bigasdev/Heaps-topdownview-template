package sample;
/**
	This small class just creates a SamplePlayer instance in current level
**/
class SampleGame extends Game {

	public var text:Null<h2d.Flow>;

	public function new() {
		super();
	}

	override function startLevel(l:World_Level) {
		super.startLevel(l);
		hero = new en.Hero();
		for(i in level.data.l_Entities.all_Text){
			createText(i.f_String, i.f_Color_int, i.cx, i.cy, i.f_willBeRemoved);
		}
	}

	override function postUpdate(){
		super.postUpdate();

	}

	public function createText(str:Dynamic, ?c=0xffcc00, x:Int, y:Int, z:Bool){
		var w = new h2d.Object();
		scroller.add(w, Const.DP_BG);
		w.scaleX = 1;
		w.scaleY = 1;
	

		var tf = new h2d.Text(Assets.fontPixelSmall, w);
		tf.maxWidth = 240;
		tf.text = str;
		tf.textColor = c;
		tf.x = Std.int( -tf.textWidth*0.5 );
		tf.y = Std.int( -tf.textHeight*0.5 );
		w.x = Std.int( x*Const.GRID - 0.5 );
		w.y = Std.int( y*Const.GRID - .65 );
	}
}

