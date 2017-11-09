var fsmBone = cc.Layer.extend({
	ctor:function(unit, name, resCount, path){
		this._super();
		this.unit = unit;
		this.initLayer(name, resCount, path);
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	/**
	 * 创建骨骼动画
	 * 
	 * @param name
	 * @param resCount
	 * @param path
	 */
	initLayer:function(name, resCount, path){
		resCount = resCount || 1;
		path = path || "bone/hero/";

		var manager = ccs.armatureDataManager;
		var jsonPath = path + name + "/" + name + ".ExportJson";
		for (var i = 0; i < resCount; i++) {
			var img = path + name + "/" + name + i +".png";
			var plist = path + name + "/" + name + i + ".plist";
			manager.addArmatureFileInfo(img, plist, jsonPath);
		}

		this.puppet = new ccs.Armature("Axe");
		this.addChild(this.puppet);

		this.puppet.getAnimation().setMovementEventCallFunc(this.meFunc.bind(this), this.puppet);

		this.puppet.name = name;
		this.puppet.jsonPath = jsonPath;
	},
	/**
	 * 动作完成回调
	 * 
	 * @param target
	 * @param type
	 * @param movementName
	 */
	meFunc:function(target, type, movementName){
		if (type > 0) {
			if (movementName === "atk" || movementName === "Damaged" || movementName === "Death") {
				this.unit.movementDone();
			}
		}
	}
});

