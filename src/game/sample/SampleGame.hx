package sample;
/**
	This small class just creates a SamplePlayer instance in current level
**/
class SampleGame extends Game {


	public function new() {
		super();
	}

	override function startLevel(l:World_Level) {
		super.startLevel(l);
		hero = new en.Hero();
		for(i in l.l_Entities.all_Turret){
			var t = new en.Turret(i.f_Integer);
			t.setPosCase(i.cx,i.cy);
		}
		for(i in l.l_Entities.all_Waypoint){
			var e = new en.Waypoint(1);
			e.setPosCase(i.cx,i.cy);
		}
	}
}

