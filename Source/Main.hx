package;

import zygame.utils.ZAssets;
import scene.MainScene;
import zygame.components.base.ZConfig;
import zygame.core.Start;

class Main extends Start {
	public static var assets:ZAssets = new ZAssets();

	public function new() {
		super(1920, 1080, false, true);
		this.stage.color = 0x011627;
		ZConfig.fontName = #if cpp "font/ipix.ttf" #else "IPix" #end;
		assets.loadFile("assets/levels.ldtk");
		assets.start(function(f) {
			if (f == 1) {
				this.replaceScene(MainScene);
			}
		});
	}
}
