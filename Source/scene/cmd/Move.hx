package scene.cmd;

import zygame.utils.Lib;
import scene.LevelScene.Command;
import motion.easing.Linear;
import scene.player.Role;
import motion.Actuate;
import script.core.Script;

/**
 * 前进后退指令
 */
class Move extends Script {
	public var command:Command;

	override function reset(display:Any) {
		super.reset(display);
		var r:Role = display;
		if (r.updateCommand(command)) {
			// 判断下一个格子是否可以行动
			var code = r.levelScene.map.getGrid(r.getNextCx(command), r.getNextCy(command));
			if (code == 1 || code == 3) {
				Actuate.tween(display, 0.5, r.getMoveAction(command)).onComplete(function() {
					exit();
				}).ease(Linear.easeNone);
			} else {
				Lib.setTimeout(exit, 100);
			}
		} else {
			Lib.setTimeout(exit, 100);
		}
	}

	override function onUpdate() {
		super.onUpdate();
	}
}
