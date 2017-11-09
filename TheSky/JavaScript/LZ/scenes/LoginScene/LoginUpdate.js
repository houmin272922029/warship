var LoginUpdate = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("LoginUpdateOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.LoginUpdate_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		var sp = this.loading_icon;
		var animFrames = [];
		var frame;
		for (var i = 1; i <= 6; i++) {
			frame = cc.spriteFrameCache.getSpriteFrame("loading_" + i + ".png");
			animFrames.push(frame);
		}
		var ani = new cc.Animation(animFrames, 0.1);
		sp.runAction(cc.animate(ani).repeatForever());
		
		this.pt = new cc.ProgressTimer(new cc.Sprite("#resUpProgress.png"));
		this.pt.type = cc.ProgressTimer.TYPE_BAR;
		this.pt.midPoint = cc.p(0, 0);
		this.pt.barChangeRate = cc.p(1, 0);
		this.updateLayer.addChild(this.pt);
		this.pt.setPosition(cc.p(this.resUpProgressBg.x, this.resUpProgressBg.y));
		
		this.loadingNote = new cc.LabelTTF(common.LocalizedString("update_stmp1"), FONT_NAME, 25, cc.size(0, 0), cc.TEXT_ALIGNMENT_CENTER);
		this.updateLayer.addChild(this.loadingNote);
		this.loadingNote.attr({
			x:this.resUpProgressBg.x,
			y:this.resUpProgressBg.y + 30,
			anchorX:0.5,
			anchorY:0.5
		})
		this.loadingNote.color = cc.color(255, 255, 255);
		this.resUpProgressBg.visible = false;
		this.pt.visible = false;
	},
	onEnter:function(){
		this._super();
		this.getVersion();
	},
	getVersion:function(){
		LoginModule.doGetVersion(common.getVersion(), logindata.uid, function(dic){
			this.versionInfo = dic.info.versionInfo;
			var updateSet = this.versionInfo.updateSet;
			if (updateSet) {
				// 有大版本更新
				return this.appUpdate();
			}
			this.patchUpadte();
		}.bind(this));
	},
	/**
	 * 版本更新
	 * @param set
	 */
	appUpdate:function(){
		var versionInfo = this.versionInfo;
		var set = versionInfo.updateSet;
		var flag = set.flag;
		var type = 0;
		if (flag == 1) {
			// 强制更新
			type = 2;
		}
		var text = set.notice;
		var cb = new ConfirmBox({info:text, type:type, confirm:function(){
			cc.sys.openURL(set.url);
		}.bind(this), close:function(){
			this.patchUpadte();
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
	/**
	 * 内容包更新
	 */
	patchUpadte:function(){
		var versionInfo = this.versionInfo;
		var url = versionInfo.cdnUrl + versionInfo.smallVersion + "/version.json";
		var xhr = cc.loader.getXMLHttpRequest();
		xhr.open("GET", url, true);
		var self = this;
		['abort', 'error', 'timeout'].forEach(function (eventname) {
			xhr["on" + eventname] = function () {
				var text = common.LocalizedString("update_stmp7");
				var cb = new ConfirmBox({info:text, type:2, confirm:function(){
					self.patchUpadte();
				}});
				cc.director.getRunningScene().addChild(cb);
			}
		});
		xhr.onreadystatechange = function(){
			if (xhr.readyState == 4) {
				if (xhr.status == 404 || xhr.status == 403) {
					var text = common.LocalizedString("update_stmp6");
					var cb = new ConfirmBox({info:text, confirm:function(){
						this.patchUpadte();
					}.bind(this), close:function(){
						this.enterGame();
					}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
				} else if (xhr.status >= 200 && xhr.status <= 207) {
					var data = xhr.responseText;
					try {
						this.cdnList = JSON.parse(data);
					} catch (e) {
						var text = common.LocalizedString("update_stmp8");
						var cb = new ConfirmBox({info:text, confirm:function(){
							this.patchUpadte();
						}.bind(this)});
						cc.director.getRunningScene().addChild(cb);
					} finally {
					}
					this.checkUpdate();
				}
			}
		}.bind(this);
		xhr.send();
		
	},
	enterGame:function(){
		this.resUpProgressBg.visible = true;
		this.pt.visible = true;
		this.pt.percentage = 0;
		this.pt.runAction(cc.progressTo(0.5, 100));
		this.runAction(cc.sequence(
			cc.delayTime(0.7),
			cc.callFunc(function(){
				postNotifcation(NOTI.GET_SETTING);
			}, this)
		));
		this.loadingNote.setString(common.LocalizedString("update_stmp3"));
	},
	/**
	 * 检查更新
	 * 
	 * @param cdnList
	 */
	checkUpdate:function(){
//		cc.loader.loadJson("version.json", function(data){
//			traceTable("localList", data);
//		})
		var cdnList = this.cdnList;
		var bComplete = true;
		if (jsb.fileUtils.isFileExist(CACHE_PATH + "/" + VERSION_FILE)) {
			bComplete = false;
		} else {
			cc.GameHelper.deleteDir(CACHE_PATH + "/");
			cc.GameHelper.createDir(CACHE_PATH + "/");
			if (!cc.GameHelper.copyFile(WRITABLE_PATH + "/" + VERSION_FILE, CACHE_PATH + "/" + VERSION_FILE)) {
				cc.GameHelper.copyFile(VERSION_FILE, CACHE_PATH + "/" + VERSION_FILE);
			}
		}
		cc.loader.loadJson(CACHE_PATH + "/" + VERSION_FILE, function(error, data){
			var self = this;
			function diff(cdnList, localList){
				self.localList = localList;
				var list = [];
				for (var file in cdnList) {
					var cv = cdnList[file];
					if (!localList || !localList[file] || localList[file] !== cv) {
						list.push({file:file, v:cv});
					}
				}
				if (getJsonLength(list)) {
					var text = common.LocalizedString("update_stmp9", getJsonLength(list));
					var cb = new ConfirmBox({info:text, type:2, confirm:function(){
						self.startDownload(list);
					}});
					cc.director.getRunningScene().addChild(cb);
					
				} else {
					self.enterGame();
				}
			}
			if (error) {
				cc.loader.loadJson(VERSION_FILE, function(error, data) {
					diff(cdnList, data);
				}.bind(this));
			} else {
				diff(cdnList, data);
			}
		}.bind(this));
	},
	/**
	 * 下载文件
	 * 
	 * @param list
	 */
	startDownload:function(list){
		this.loadingNote.setString(common.LocalizedString("update_stmp2", "0"));
		this.resUpProgressBg.visible = true;
		this.pt.visible = true;
		this.pt.percentage = 0;
		this.downloadCount = list.length;
		this.finishCount = 0;
		this.failCount = 0;
		var mt = 10;
		var temp = [];
		for (var i = 0; i < mt; i++) {
			temp[i] = [];
		}
		for (var i = 0; i < list.length; i++) {
			var dic = list[i];
			temp[i % mt].push(dic); 
		}
		for (var i = 0; i < mt; i++) {
			this.downloadPool(temp[i]);
		}
	},
	/**
	 * 线程池
	 * 
	 * @param list
	 */
	downloadPool:function(list){
		var versionInfo = this.versionInfo;
		var url = versionInfo.cdnUrl + versionInfo.smallVersion + "/";
		var self = this;
		function download(index){
			var dic = list[index];
			if (!dic) {
				return;
			}
			var file = dic.file;
			var v = dic.v;
			var dh = new cc.downloadHelper();
			dh.download(url + file, file, CACHE_PATH + "/" + file, function(path){
				self.finishCount++;
				self.refreshPt();
				if (path) {
					trace("download succ : " + file);
					self.downloadSucc(file, v);
				} else {
					trace("download fail");
					self.downloadFail();
				}
				download(index + 1);
			});
		}
		download(0);
	},
	refreshPt:function(){
		var pct = Math.min(100, (this.finishCount / this.downloadCount * 100)).toFixed(2);
		this.loadingNote.setString(common.LocalizedString("update_stmp2", pct));
		this.pt.percentage = pct;
	},
	downloadSucc:function(file, v){
		this.localList[file] = v;
		trace("downloadSucc | downloadCount : " + this.downloadCount + " | finishCount : " + this.finishCount);
		cc.GameHelper.writeFile(JSON.stringify(this.localList), CACHE_PATH + "/" + VERSION_FILE);
		if (this.downloadCount === this.finishCount) {
			this.downloadFinish();
		}
	},
	downloadFail:function(){
		trace("downloadFail | downloadCount : " + this.downloadCount + " | finishCount : " + this.finishCount);
		this.failCount++;
		if (this.downloadCount === this.finishCount) {
			this.downloadFinish();
		}
	},
	downloadFinish:function(){
		trace("download finish");
		if (this.failCount === 0) {
			cc.GameHelper.copyDirFile(CACHE_PATH, WRITABLE_PATH);
			cc.GameHelper.deleteDir(CACHE_PATH);
//			var self = this;
//			cc.loader.loadJson("project.json", function(error, data){
//				traceTable("jsList", data.jsList);
//				cc.loader.loadJs(WRITABLE_PATH, data.jsList, function(error, data){
//					if (!error) {
//						self.enterGame();
//					}
//				})
//			}.bind(this));
			var text = common.LocalizedString("update_stmp5");
			var cb = new ConfirmBox({info:text, type:2, confirm:function(){
				cc.GameHelper.exitGame();
			}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
		} else {
			var text = common.LocalizedString("update_stmp4", this.failCount);
			var cb = new ConfirmBox({info:text, type:2, confirm:function(){
				this.checkUpdate();
			}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
		}
	}
	
});