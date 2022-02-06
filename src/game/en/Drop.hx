package en;

class Drop{
    public var dropSeed:hxd.Rand;


    public function new(seed:Int){
        dropSeed = new hxd.Rand(seed);
    }
}