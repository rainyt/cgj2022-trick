package scene;

import zygame.components.ZImage;
import zygame.components.ZModel;
import zygame.ldtk.LDTKProject.LDTKMap;
import scene.cmd.Move;
import zygame.components.ZBuilder;
import zygame.utils.load.Frame;
import zygame.display.batch.BImage;
import scene.player.Role;
import zygame.components.ZBuilderScene;

/**
 * 关卡
 */
@:build(zygame.macro.AutoBuilder.build("LevelScene"))
class LevelScene extends ZBuilderScene {
	public var commands:Array<Command> = [];
	public var role:Role;
	public var currentPupil:Pupil;
	public var map:LDTKMap;
	public var level:Int = 0;

	override function onBuilded() {
		super.onBuilded();
		var project = Main.assets.getLDTKProject("levels");
		map = project.createLDTKMap(project.levels[level - 1].identifier);
		gamebox.addChild(map);
		map.scale(800 / map.height);
		map.x = gamebox.width / 2 - map.width / 2;
		map.y = getStageHeight() / 2 - map.height / 2;

		role = new Role();
		role.levelScene = this;
		role.directionIndex = UP;

		var s = new ZImage();
		s.dataProvider = ZBuilder.getBaseBitmapData("Atlas:originl");
		map.addChild(s);
		s.x = 4 * 80;
		s.y = 8 * 80;

		var s = new ZImage();
		s.dataProvider = ZBuilder.getBaseBitmapData("Atlas:goal");
		map.addChild(s);
		s.x = 4 * 80;
		s.y = 0 * 80;

		map.addChild(role);
		role.x = 4 * 80 + 40;
		role.y = 8 * 80 + 40;

		this.down.clickEvent = function() {
			commands.push(DOWN);
			this.updateCommand();
		}
		this.up.clickEvent = function() {
			commands.push(UP);
			this.updateCommand();
		}
		this.left.clickEvent = function() {
			commands.push(LEFT);
			this.updateCommand();
		}
		this.right.clickEvent = function() {
			commands.push(RIGHT);
			this.updateCommand();
		}
		this.start.clickEvent = function() {
			// 开始
			createPuiler();
		}
		this.back.clickEvent = function() {
			this.replaceScene(SelectScene, true);
		}
		this.detele.clickEvent = function() {
			commands.pop();
			this.updateCommand();
		}
		this.remake.clickEvent = function() {
			commands = [];
			this.updateCommand();
		}
		this.next.visible = false;
		this.next.clickEvent = function() {
			this.releaseScene();
			this.replaceScene(LevelScene, false, true, false, {
				level: level + 1
			});
		}
	}

	public function createPuiler():Void {
		role.reset();
		if (currentPupil != null) {
			currentPupil.stop();
			currentPupil = null;
			this.role.stop();
			return;
		}
		var p:Pupil = new Pupil();
		for (item in commands) {
			var action = new Move();
			action.command = item;
			p.addScript(action, role);
		}
		p.onExit = function(code) {
			this.role.stop();
			currentPupil = null;
			if (Std.int(role.x / 80) == 4 && Std.int(role.y / 80) == 0) {
				ZModel.showTextModel("太棒了，挑战成功");
				next.visible = true;
				back.visible = false;
				start.visible = false;
			} else {
				ZModel.showTextModel("失败啦，再试试看吧");
			}
		}
		p.start();
		this.role.play(99999);
		currentPupil = p;
	}

	public function updateCommand():Void {
		this.batchs.removeTiles();
		var index = 0;
		var offestY = 0;
		for (c in this.commands) {
			var tile = new BImage(getCommandFrame(c));
			if (90 * index + tile.width > this.command.width) {
				index = 0;
				offestY++;
			}
			this.batchs.addChild(tile);
			tile.x = 90 * index;
			tile.y = 90 * offestY;
			index++;
		}
	}

	private function getCommandFrame(c:Command):Frame {
		switch c {
			case UP:
				return ZBuilder.getBaseBitmapData("Atlas:farwardl");
			case DOWN:
				return ZBuilder.getBaseBitmapData("Atlas:farwardl2");
			case LEFT:
				return ZBuilder.getBaseBitmapData("Atlas:left");
			case RIGHT:
				return ZBuilder.getBaseBitmapData("Atlas:right");
		}
		return null;
	}
}

enum abstract Command(Int) from Int to Int {
	var UP = 1;
	var DOWN = 3;
	var LEFT = 0;
	var RIGHT = 2;
}
