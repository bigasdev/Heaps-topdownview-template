package assets;

import dn.heaps.slib.*;
import dn.heaps.assets.*;

/**
	This class centralizes all assets management (ie. art, sounds, fonts etc.)
**/
class Assets {
	// Fonts
	public static var fontPixel : h2d.Font;
	public static var fontPixelSmall : h2d.Font;

	public static var SFXLib = dn.heaps.assets.SfxDirectory.load("sfx", true);

	static var music: dn.heaps.Sfx;

	/** Main atlas **/
	public static var tiles : SpriteLib;
	public static var hero : SpriteLib;
	public static var explosion : SpriteLib;

	/** LDtk world data **/
	public static var worldData : World;
	public static var tilesDict = dn.heaps.assets.Aseprite.getDict(hxd.Res.atlas.tiles);
	public static var explosionDict = dn.heaps.assets.Aseprite.getDict(hxd.Res.atlas.explosion);


	static var _initDone = false;
	public static function init() {
		if( _initDone )
			return;
		_initDone = true;


		// Fonts
		fontPixel = new hxd.res.BitmapFont( hxd.Res.fonts.pixel_unicode_regular_12_xml.entry ).toFont();
		fontPixelSmall = new hxd.res.BitmapFont( hxd.Res.fonts.minecraftiaOutline.entry).toFont();

		// build sprite atlas directly from Aseprite file
		tiles = dn.heaps.assets.Aseprite.convertToSLib(Const.FPS, hxd.Res.atlas.tiles.toAseprite());
		hero = dn.heaps.assets.Aseprite.convertToSLib(Const.FPS, hxd.Res.atlas.Hero.toAseprite());
		explosion = dn.heaps.assets.Aseprite.convertToSLib(Const.FPS, hxd.Res.atlas.explosion.toAseprite());

		// CastleDB file hot reloading
		#if debug
		hxd.Res.data.watch(function() {
			// Only reload actual updated file from disk after a short delay, to avoid reading a file being written
			App.ME.delayer.cancelById("cdb");
			App.ME.delayer.addS("cdb", function() {
				CastleDb.load( hxd.Res.data.entry.getBytes().toString() );
				Const.fillCdbValues();
				if( Game.exists() )
					Game.ME.onDbReload();
			}, 0.2);
		});
		#end

		// Parse castleDB JSON
		CastleDb.load( hxd.Res.data.entry.getText() );
		Const.fillCdbValues();

		// `const.json` hot-reloading
		hxd.Res.const.watch(function() {
			// Only reload actual updated file from disk after a short delay, to avoid reading a file being written
			App.ME.delayer.cancelById("constJson");
			App.ME.delayer.addS("constJson", function() {
				Const.fillJsonValues( hxd.Res.const.entry.getBytes().toString() );
				if( Game.exists() )
					Game.ME.onDbReload();
			}, 0.2);
		});

		// LDtk init & parsing
		worldData = new World();

		// LDtk file hot-reloading
		#if debug
		var res = try hxd.Res.load(worldData.projectFilePath.substr(4)) catch(_) null; // assume the LDtk file is in "res/" subfolder
		if( res!=null )
			res.watch( ()->{
				// Only reload actual updated file from disk after a short delay, to avoid reading a file being written
				App.ME.delayer.cancelById("ldtk");
				App.ME.delayer.addS("ldtk", function() {
					worldData.parseJson( res.entry.getText() );
					if( Game.exists() )
						Game.ME.onLdtkReload();
				}, 0.2);
			});
		#end
	}


	/**
		Pass `tmod` value from the game to atlases, to allow them to play animations at the same speed as the Game.
		For example, if the game has some slow-mo running, all atlas anims should also play in slow-mo
	**/
	public static function update(tmod:Float) {
		if( Game.exists() && Game.ME.isPaused() )
			tmod = 0;

		tiles.tmod = tmod;
		// <-- add other atlas TMOD updates here
	}

}