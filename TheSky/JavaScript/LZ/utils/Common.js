/**
 * 切面方法，方法执行前
 * @param func 执行前先执行的方法
 * @returns {Function}
 */
Function.prototype.before = function(func){
	var __self = this;
	return function(){
		if (func.apply(this, arguments) === false) {
			return false;
		}
		return __self.apply(this, arguments);
	}
}

/**
 * 切面方法，方法执行后
 * @param func 执行后在方法返回前先执行的方法
 * @returns {Function}
 */
Function.prototype.after = function(func){
	var __self = this;
	return function(){
		var ret = __self.apply(this, arguments);
		if (ret === false) {
			return false;
		}
		func.apply(this, arguments);
		return ret;
	}
}

Function.prototype.around = function(before, after){
	var __self = this;
	return function(){
		if (!before || before.apply(this, arguments) === false) {
			return false;
		}
		var ret = __self.apply(this, arguments);
		if (!after) {
			return ret;
		}
		return after.apply(this, arguments);
	}
}
function around(obj, prop, advice){
	var exist = obj[prop];
	var previous = function(){
		return exist.apply(obj, arguments);
	}
	var advised = advice(previous);
	obj[prop] = function(){
		//当调用remove后，advised为空
		//利用闭包的作用域链中可以访问到advised跟previous变量，根据advised是否为空可以来决定调用谁
		return advised ? advised.apply(obj, arguments) : previous.apply(obj, arguments);
	};
	
	return {
		remove:function(){
			//利用闭包的作用域链，在remove时将advised置空，这样执行过程中不会进入本次around
			advised = null;
			advice = null;
		}
	}
}

String.prototype.format = function(args) {
	var result = this;
	if (arguments.length < 1) {
		return result;
	}

	var data = arguments;       // 如果模板参数是数组
	if (arguments.length == 1 && typeof (args) == "object") {
		// 如果模板参数是对象
		data = args;
	}
	for (var key in data) {
		var value = data[key];
		if (undefined != value) {
			result = result.replace("{" + key + "}", value);
		}
	}
	return result;
}

function deepcopy(source) {
	var result={};
	for (var key in source) {
		result[key] = typeof source[key] === "object" ? deepcopy(source[key]): source[key];
	} 
	return result; 
}

var common = {
	LOADING_COUNT:0,
	/*
	 * 格式化多语言字符串
	 */
	LocalizedString:function(key, args){
		if (key.length == 0) {
			return key;
		}
		if (Localizable) {
			var temp = key.replace(/\./g, '\_');
			var temp = key;
			if (!Localizable[temp]) {
				return key;
			}
			if (args !== null) {
				return String(Localizable[temp].format(args));
			} else {
				return String(Localizable[temp]);
			}
		} else {
			return key;
		}
	},
	addLoadinMask:function(){
		if (common.LOADING_COUNT < 1) {
			this.loadingLayer = new ActionLoading();
			cc.director.getRunningScene().addChild(this.loadingLayer);
		}
		common.LOADING_COUNT++;
	},
	removeLoadingMask:function(){
		common.LOADING_COUNT = Math.max(common.LOADING_COUNT - 1, 0);
		if (common.LOADING_COUNT < 1) {
			this.loadingLayer.removeFromParent(true);
		}
	},
	showTipText:function(text){
		// TODO show text
		trace(text);
		this.ShowText(text);
	},
	/**
	 * 字符转换 例如 ‘1-->01’
	 * @param num
	 * @param length
	 * @returns
	 */
	fix:function(num, length){
		return  ('' + num).length < length ? ((new Array(length + 1)).join('0') + num).slice(-length) : '' + num;
	},
	/**
	 * 获取一段字的高度
	 * @param string
	 * @param width
	 * @param fontSize
	 * @param fontName
	 * @returns  高度
	 */
	getFontHeight:function(string, width, fontSize, fontName){
		if (!fontName) {
			fontName = FONT_NAME;
		}
		var tempLabel = new cc.LabelTTF(string, fontName, fontSize, cc.size(width, 0), cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP);
		tempLabel.visible = true;
		var node = new cc.Node();
		node.addChild(tempLabel,200);
		var height = tempLabel.getContentSize().height;
		tempLabel.removeFromParent(true);
		return height;
	},

	/**
	 * 返回两个数字间的随机整数
	 * @param min
	 * @param max
	 */
	getRandomNum: function (min, max) {
		var Range = max - min;   
		var Rand = Math.random();   
		return(min + Math.round(Rand * Range));  
	},
	
	/**
	 * 在游戏上部显示一个黑色背景的提示条
	 * @param tips 要显示的提示
	 */
	ShowText:function(tips){
		var bg = new cc.Scale9Sprite("images/grayBg.png");
		bg.setAnchorPoint(0.5, 0.5);
		bg.setCapInsets(cc.rect(15, 15, 15, 15));
		bg.setPosition(cc.p(cc.winSize.width / 2, cc.winSize.height / 2));
		cc.director.getRunningScene().addChild(bg);
		
		var fullWidth = cc.winSize.width * 0.6;
		var tipLabel = new cc.LabelTTF(tips, FONT_NAME, 23,
				cc.size(0, 0), 
				cc.TEXT_ALIGNMENT_CENTER, 
				cc.VERTICAL_TEXT_ALIGNMENT_CENTER
				);
		bg.addChild(tipLabel);
		
		var labelContentSize = tipLabel.getContentSize();
		
		if (labelContentSize.width > fullWidth) {
			tipLabel.removeFromParent(true);
			tipLabel = new cc.LabelTTF(tips, FONT_NAME, 23,
					cc.size(fullWidth, 0), 
					cc.TEXT_ALIGNMENT_CENTER, 
					cc.VERTICAL_TEXT_ALIGNMENT_CENTER
					);
			bg.addChild(tipLabel);
			labelContentSize = tipLabel.getContentSize();
		}
		
		bg.setContentSize(cc.size(labelContentSize.width + 10, labelContentSize.height + 10))
		tipLabel.setPosition(cc.p(bg.getContentSize().width/ 2, bg.getContentSize().height / 2));
		bg.scale = retina;
		bg.runAction(cc.sequence(
				cc.delayTime(1.5),
				cc.fadeOut(0.25),
				cc.callFunc(function(){
					bg.removeFromParent(true);
				})
		));
	},
	/**
	 * 格式化多语言图片地址
	 * @param path
	 */
	formatLResPath:function(path){
		return ccbi_dir + "/ccbi/ccbResources/" + path;
	},
	/**
	 * 
	 * @param layer
	 * @param swallow
	 * @param node 需要检查点击区域的node
	 * @param outsidecb 点击node外侧的回调
	 * @returns {___anonymous3050_3838}
	 */
	swallowLayer:function(layer, swallow, node, outsidecb){
		swallow = swallow === undefined ? true : swallow;
		var bOutside = false;
		var lst = cc.EventListener.create({
			event: cc.EventListener.TOUCH_ONE_BY_ONE,
			swallowTouches:swallow,
			onTouchBegan:function(touch, event){
				var target = event.getCurrentTarget();
				var pos = touch.getLocation();
				if (node && outsidecb) {
					if (!cc.rectContainsPoint(node.getBoundingBoxToWorld(), pos)) {
						bOutside = true;
					}
				}
				if (!cc.rectContainsPoint(target.getBoundingBoxToWorld(), pos)) {
					return false;
				}
				return true;
			},
			onTouchEnded:function(touch, event){
				var target = event.getCurrentTarget();
				var pos = touch.getLocation();
				if (node && outsidecb) {
					if (!cc.rectContainsPoint(node.getBoundingBoxToWorld(), pos) && bOutside) {
						outsidecb.apply();
					}
				}
				bOutside = false;
				return true;
			}
		})
		cc.eventManager.addListener(lst, layer);
		return lst;
	},
	/**
	 * 是否包含对象
	 * @param s
	 * @param obj
	 */
	bContainObject:function(s, obj){
		for (var k in s) {
			if (s[k] === obj) {
				return true;
			}
		}
		return false;
	},
	createBone:function(name, resCount, path){
		resCount = resCount || 1;
		path = path || "bone/hero/";

		var manager = ccs.armatureDataManager;
		var jsonPath = path + name + "/" + name + ".ExportJson";
		for (var i = 0; i < resCount; i++) {
			var img = path + name + "/" + name + i +".png";
			var plist = path + name + "/" + name + i + ".plist";
			manager.addArmatureFileInfo(img, plist, jsonPath);
		}

		var puppet = new ccs.Armature(name);
		var node = new cc.Node();
		node.addChild(puppet);
		node.puppet = puppet;
		return node;
	},
	getIconById:function(id){
		if (id.indexOf("vip_") == 0) {
			return this.formatLResPath("icons/vip_001.png");
		}
		return this.formatLResPath("icons/" + id + ".png");
	},
	getResource:function(id){
		var cfg = {};
		if (id === "silver" || id === "gold" || id === "berry") {
			cfg.rank = 1;
			cfg.icon = this.formatLResPath("icons/berryIcon.png");
			cfg.name = this.LocalizedString("贝里");
			cfg.iconType = 0;
		} else if (id === "diamond") {
			cfg.rank = 4;
			cfg.icon = this.formatLResPath("icons/diamond.png");
			cfg.name = this.LocalizedString("金币");
			cfg.iconType = 0;
		
		} else if (id.indexOf("hero_") == 0) {
			var config = HeroModule.getHeroConfig(id);
			cfg.rank = config.rank;
			cfg.icon = HeroModule.getHeroHeadById(id);
			cfg.name = config.name;
			cfg.iconType = 1;
		} else {
			var config = ItemModule.getItemConfig(id);
			var bShard = false;
			if (!config) {
				config = EquipModule.getEquipConfig(id);
			}
			if (!config) {
				config = SkillModule.getSkillConfig(id);
			}
			if (!config) {
				config = ShardModule.getShardConfig(id);
				bShard = true;
			}
			if (!config) {
				cfg.rank = 1;
				cfg.icon = null;
				cfg.name = "";
			} else {
				var icon = id.indexOf("chapter") == 0 ? config.params : config.icon;
				cfg.icon = this.formatLResPath("icons/" + icon + ".png");
				cfg.rank = config.rank;
				cfg.name = config.name;
				cfg.bChapter = id.indexOf("chapter_") === 0;
				if (cfg.bChapter) {
					cfg.cidx = parseInt(id.split("_")[2]);
				}
			}
			cfg.bShard = bShard;
			cfg.iconType = 0;
		}
		cfg.id = id;
		return cfg;
	},
	/**
	 * 根据品阶获取颜色
	 * @param rank
	 */
	getColorByRank:function(rank){
		var color;
		switch (rank) {
		case 1:
			color = cc.color(255, 255, 255);
			break;
		case 2:
			color = cc.color(127, 252, 58);
			break;
		case 3:
			color = cc.color(4, 211, 255);
			break;
		case 4:
			color = cc.color(202, 100, 221);
			break;
		case 5:
			color = cc.color(255, 225, 59);
			break;
		default:
			break;
		}
		return color;
	},
	/**
	 * 判断一个字符串是否包含某个前缀
	 * @param sourceStr
	 * @param str
	 */
	havePrefix:function(sourceStr, str){
		var flag = false;
		var isFrom = sourceStr.indexOf(str);
		if (isFrom > -1) {
			flag = true;
		}
		return flag;
	},
	/**
	 * 属性图片
	 * 
	 * @param attr
	 */
	getDisplayFrame:function(attr){
		return ((attr === "mp") ? "int" : attr) + "_icon.png";
	},
	
	/**
	 * 注册点击事件
	 * 
	 * @param node 
	 * @param touchedCallback 点击回调
	 * @param beganCallback 点击开始回调
	 * @param endCallback 点击结束回调
	 */
	registerTouchedEvent:function(node, touchedCallback, beganCallback, endCallback){
		return cc.eventManager.addListener(cc.EventListener.create({
			event: cc.EventListener.TOUCH_ONE_BY_ONE,
			onTouchBegan:function(touch, event){
				var target = event.getCurrentTarget();
				var pos = touch.getLocation();
				if (!cc.rectContainsPoint(target.getBoundingBoxToWorld(), pos)) {
					return false;
				}
				target.startX = pos.x;
				target.startY = pos.y;
				if (beganCallback) {
					beganCallback();
				}
				return true;
			},
			onTouchEnded:function(touch, event){
				var target = event.getCurrentTarget();
				var pos = touch.getLocation();
				if (Math.abs(target.startX - pos.x) < 20 && cc.rectContainsPoint(target.getBoundingBoxToWorld(), pos) 
						&& Math.abs(target.startY - pos.y) < 20) {
					if (touchedCallback) {
						touchedCallback();
					}
				}
				if (endCallback) {
					endCallback();
				}
				return true;
			}
		}), node);
	},
	getVersion:function() {
		var version = "1.0";
		if (cc.sys.os === cc.sys.OS_IOS) {
			version = jsb.reflection.callStaticMethod("GameConfig", "getVersion");

		} else if (cc.sys.os === cc.sys.OS_ANDROID) {

		}
		return version;
	},
	GameWillEnterForeground:function() {
		trace("app controller call foreground");
	},
	GameDidEnterBackground:function() {
		trace("app controller call background");
	},
	pay:function(pay){
		if (!pay) {
			return;
		}
		playerdata.decrease(pay);
	},
	gain:function(gain){
		if (!gain) {
			return;
		}
		playerdata.increase(gain);
	},
	popupGain:function(gain){
		if (!gain) {
			return;
		}
		playerdata.popupGain(gain);
	},
	prob:function(prob){
		var total = 0;
		var w = [];
		var keys = [];
		for (var k in prob) {
			keys.push(k);
			total += prob[k];
			w.push(total);
		}
		var rand = Math.floor(Math.random() * total + 1);
		for (var i = 0; i < w.length; i++) {
			if (rand <= w[i]) {
				return keys[i];
			}
		}
		return null;
	},
	/**
	 * 文件是否存在
	 * @param fileName 文件名
	 */
	isFileExist:function(fileName){
		return jsb.fileUtils.isFileExist(jsb.fileUtils.fullPathForFilename(fileName));
	},
	/**
	 * 删除文件
	 * @param filePath 文件路径
	 */
	deleteFile:function(filePath){
		return cc.GameHelper.deleteDir(filePath);
	},
	/**
	 * 创建文件夹 传入/images/temp/1/123.png，创建/images/temp/1/目录
	 * @param filePath
	 */
	createDir:function(filePath){
		return cc.GameHelper.createDir(filePath);
	},
	/**
	 * 将目录所有文件拷贝到另一个目录
	 * @param srcPath
	 * @param destPath
	 */
	copyDirFile:function(srcPath, destPath){
		return cc.GameHelper.copyDirFile(srcPath, destPath);
	},
	/**
	 * 文件拷贝
	 * @param srcPath
	 * @param destPath
	 */
	copyFile:function(srcPath, destPath){
		return cc.GameHelper.copyFile(srcPath, destPath);
	},
}

function getJsonLength(json){
	if (!json) {
		return 0;
	}
	var len = 0;
	for (var item in json) {
		len++;
	}
	return len;
}

/*
 * 打印一个数组中的元素 @param string str @param Array array
 */
function traceTable(str, array) {
	trace(JSON.stringify(str));
	if (array) {
		trace(JSON.stringify(array));
	}
}

function trace(str){
	if (GAMEDEBUG) {
		cc.log(str);
	}
}

//进入后台 
cc.eventManager.addCustomListener(cc.game.EVENT_HIDE, function(event){ 
	cc.log("cc.game.EVENT_HIDE!"); 
}); 
//恢复显示 
cc.eventManager.addCustomListener(cc.game.EVENT_SHOW, function(event){ 
	cc.log("cc.game.EVENT_SHOW"); 
});
