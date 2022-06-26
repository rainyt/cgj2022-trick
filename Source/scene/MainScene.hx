package scene;

import openfl.events.MouseEvent;
import zygame.utils.Lib;
import zygame.components.ZBuilderScene;

@:build(zygame.macro.AutoBuilder.build("MainScene"))
class MainScene extends ZBuilderScene {
	override function onBuilded() {
		super.onBuilded();
		Lib.setTimeout(function() {
			this.addEventListener(MouseEvent.CLICK, function(e) {
				this.replaceScene(SelectScene);
			});
		}, 1200);
	}
}
