// params = {retry:2,timeout:60,action:"",httpParam:{}}
var Http = function(params){
	var p = params || {};
	this.retryMaxTime = p.retry || 2;
	this.timeout = p.timeout || 60000;
	this.action = p.action;
	this.httpParam = p.httpParam || [];
	this.param = p.param || {};
	this.url = "";
};
/*
 * @param string action 请求
 * @param dic httpParam 发送给服务器的参数
 * @param dic param 请求本身相关的回调等参数
 * @param bool noLoading 不需要遮罩
 */
Http.prototype.doRequset = function(action, httpParam, param) {
	this.checkParams(param, httpParam);
	if (this.checkAction(action)) {
		cc.log("http invalid action");
		return;
	}
	this.spliceParams();
	this.sendRequest(this.success_callback, this.error_callback);
};

Http.prototype.checkParams = function(param, httpParam) {
	this.param = param || {};
	this.httpParam = httpParam || [];

	this.success_callback = this.param.success_callback || function(data) {
		cc.log("http default succecc callback: " + data);
	};
	this.error_callback = this.param.error_callback || function(data) {
		cc.log("http default error callback: " + data);
	};
	this.progress_callback = this.param.progress_callback || function(data) {
		cc.log("http default progress callback: " + data);
	};
};

Http.prototype.checkAction = function(action) {
	this.action = action || null;
	return this.action == null;
};

Http.prototype.spliceParams = function(){
	this.url = COMMON_SERVER_URL + "?action=" + this.action;
	var server = LoginModule.getSelectedServer();
	if (server && server.url && this.action != ACTION.GETSERVERLIST && this.action != ACTION.GETVERSION) {
		this.url = server.url + "?action=" + this.action;
	}
	
	var param = JSON.stringify(this.httpParam);
	this.url = this.url + "&params=" + encodeURIComponent(param);
	
	var md5Str = this.action + param
	if (logindata.sid) {
		md5Str = md5Str + logindata.sid;
	}
	md5Str = md5Str + MD5_KEY.LOGIN_KEY;
	md5Str = MD5(md5Str);
//	cc.log("spliceParams md5 = "+md5Str);
	this.url = this.url + "&sign=" + encodeURIComponent(md5Str);
};

Http.prototype.sendRequest = function(success_callback, error_callback){
	var xhr = cc.loader.getXMLHttpRequest();
	xhr.timeout = this.timeout;
	
	xhr.open("GET", this.url, true);
	var sid = logindata.sid
	if (sid) {
		xhr.setRequestHeader("sid", sid);
	}
	xhr.setRequestHeader("CHANNELID", PCLId);
	var server = LoginModule.getSelectedServer();
	if (server && this.action != ACTION.GETVERSION && this.action != ACTION.GETSERVERLIST) {
		xhr.setRequestHeader("SERVERCODE", server.id);
	} else {
		//xhr.setRequestHeader("SERVERCODE", "server1");
		xhr.setRequestHeader("SERVERCODE", "serverPublic");
		['abort', 'error', 'timeout'].forEach(function (eventname) {
			xhr["on" + eventname] = function () {
				error_callback(-1, "network error");
			}
		});
	}
	xhr.onreadystatechange = function(){
		if (xhr.readyState == 4 && (xhr.status >= 200 && xhr.status <= 207)) {
			var data = xhr.responseText;
//			traceTable("http response", data);
			var json;
			try {
				json = JSON.parse(data);
//				traceTable("http response", json);
				success_callback(json);
			} catch (e) {
				trace(e);
			} finally {
				json = null;
			}
		}
	}
	xhr.send();
}
