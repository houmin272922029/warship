var HttpDelegate = (function(){
	var instance;
	function init(){
		// private
		/*
		 * 拦截器
		 * 对请求返回的数据进行拦截、处理
		 * @ param table data 请求返回的数据
		 * @ return 无
		 */
		_parseByControlModule = function(data){
			if (!data) {
				common.showTipText("network error");
				return
			}
			var code = data.code;
			var data = data.info;
			if (code && data) {
				// TODO 
				if (data.sid) {
					logindata.setSid(data.sid);
				}
				if (data.serverTime) {
					Global.serverTime = data.serverTime;
				}
				if (data.serverBegin) {
					Global.serverBegin = data.serverBegin;
				}
				var action = HttpDelegate.getInstance().action;
				if (action === ACTION.STAGE_FIGHT || action === ACTION.STAGE_MULTI_FIGHT || action === ACTION.FRAG_FRAG_BATTLE) {
					return;
				}
				common.pay(data.pay);
				common.gain(data.gain);
				common.popupGain(data.gain);
			}
		}
		return {
			// public
			doAction:function(action, httpParam, param){
				this.action = action;
				var http = new Http();
				common.addLoadinMask();
				http.doRequset(action, httpParam, {
					success_callback:function(data){
						common.removeLoadingMask();
						_parseByControlModule(data);
						if (data && data.code == 200) {
							param.success_callback(data);
						} else {
							if (data.code == 1107) {
								
								var text = common.LocalizedString("sail_clearSweepTimeVIP",3);
								var cb = new ConfirmBox({info:text, confirm:function(){
									postNotifcation(NOTI.GOTO_LOGUETOWN, {type : 0});
								}.bind(this)});
								cc.director.getRunningScene().addChild(cb);
								
								param.error_callback(data);
							} else {
								common.showTipText(common.LocalizedString("ERR_" + data.code));  //  + " | " + data.info);
								param.error_callback(data);
							}
							
						}
					},
					error_callback:function(errCode, errMsg){
						common.removeLoadingMask();
						common.showTipText("network error, code:" + errCode + ", msg:" + errMsg);
						param.error_callback();
					}
				});
			},
		}
	}
	return {
		getInstance:function(){
			if (!instance) {
				instance = init();
			}
			return instance;
		}
	}
})();