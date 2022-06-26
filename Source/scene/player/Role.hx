package scene.player;

import zygame.utils.Align;
import motion.Actuate;
import scene.LevelScene.Command;
import zygame.components.data.AnimationData;
import zygame.components.ZAnimation;

class Role extends ZAnimation {
	/**
	 * 方向
	 */
	public var direction:Array<Command> = [LEFT, UP, RIGHT, DOWN];

	public var directionIndex(get, set):Int;

	private var _directionIndex:Int = 3;

	public var levelScene:LevelScene;

	function get_directionIndex():Int {
		return _directionIndex;
	}

	function set_directionIndex(value:Int):Int {
		if (value >= 4)
			value = 0;
		else if (value < 0)
			value = 3;
		_directionIndex = value;
		switch direction[directionIndex] {
			case UP:
				this.rotation = 180;
			case DOWN:
				this.rotation = 0;
			case LEFT:
				this.rotation = -90;
			case RIGHT:
				this.rotation = 90;
		}
		return value;
	}

	public function new() {
		super();
	}

	override function onInit() {
		super.onInit();
		var data = new AnimationData(6);
		data.addFrames(["Atlas:mouse-1", "Atlas:mouse-2", "Atlas:mouse-3"]);
		this.dataProvider = data;
		this.hAlign = Align.CENTER;
		this.vAlign = Align.CENTER;
		this.scale(1.5);
	}

	/**
	 * 更新指令
	 * @param c 
	 */
	public function updateCommand(c:Command):Bool {
		switch c {
			case LEFT:
				directionIndex += 1 * getState();
				return false;
			case RIGHT:
				directionIndex -= 1 * getState();
				return false;
			default:
				return true;
		}
	}

	public function getMoveAction(c:Command):Dynamic {
		var back = c == DOWN ? -1 : 1;
		back *= getState();
		var data:Dynamic = {};
		switch direction[directionIndex] {
			case UP:
				data.y = this.y - 80 * back;
			case DOWN:
				data.y = this.y + 80 * back;
			case LEFT:
				data.x = this.x + 80 * back;
			case RIGHT:
				data.x = this.x - 80 * back;
		}
		return data;
	}

	public function reset():Void {
		this.directionIndex = UP;
		this.x = 4 * 80 + 40;
		this.y = 8 * 80 + 40;
		Actuate.stop(this);
	}

	public function getState():Int {
		var pix = Std.int(this.x / 80);
		var piy = Std.int(this.y / 80);
		var gird = this.levelScene.map.getGrid(pix, piy);
		return gird == 3 ? -1 : 1;
	}

	public function getNextCx(c:Command):Int {
		var back = c == DOWN ? -1 : 1;
		// 状态反向操作
		back *= getState();
		switch (directionIndex) {
			case Command.LEFT:
				return Std.int(this.x / 80) + 1 * back;
			case Command.RIGHT:
				return Std.int(this.x / 80) - 1 * back;
			default:
				return Std.int(this.x / 80);
		}
	}

	public function getNextCy(c:Command):Int {
		var back = c == DOWN ? -1 : 1;
		// 状态反向操作
		back *= getState();
		switch (directionIndex) {
			case Command.UP:
				return Std.int(this.y / 80) - 1 * back;
			case Command.DOWN:
				return Std.int(this.y / 80) + 1 * back;
			default:
				return Std.int(this.y / 80);
		}
	}
}
