package scene;

import zygame.components.ZLabel;
import zygame.components.ZButton;
import zygame.utils.DisplayTools;
import zygame.utils.Lib;
import zygame.components.ZBuilderScene;

/**
 * 选关界面
 */
@:build(zygame.macro.AutoBuilder.build("SelectLevel"))
class SelectScene extends ZBuilderScene {
	override function onBuilded() {
		super.onBuilded();
		DisplayTools.map(this, function(d):Bool {
			if (d is ZButton) {
				trace("事件侦听");
				var button:ZButton = cast d;
				button.clickEvent = function() {
					DisplayTools.map(button, function(data) {
						if (data is ZLabel) {
							this.replaceScene(LevelScene, false, true, false, {
								level: Std.parseInt(cast(data, ZLabel).dataProvider)
							});
						}
						return true;
					});
				}
			}
			return true;
		});
	}
}
