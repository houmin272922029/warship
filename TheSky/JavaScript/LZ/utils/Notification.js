var Notification = {};

function postNotifcation(notiName, object) {
	var cbs = Notification[notiName];
	if (!cbs) {
		return;
	}
	for (var i = 0; i < cbs.length; i++) {
		var dic = cbs[i];
		var obj = dic.obj;
		var cb = dic.cb;
		obj[cb].call(obj, object);
	}
}

/**
 * 添加通知
 * 
 * @param notiName 通知key
 * @param callback 方法名字
 * @param obj 调用对象
 */
function addObserver(notiName, callback, obj) {
	var cbs = Notification[notiName];
	if (!cbs) {
		var callbacks = [{cb:callback, obj:obj}];
		Notification[notiName] = callbacks;
	} else {
		for (var i = 0; i < cbs.length; i++) {
			var dic = cbs[i];
			if (dic.cb == callback && dic.obj == obj) {
				return;
			}
		}
		cbs.push({cb:callback, obj:obj});
	}
}

/**
 * 移除通知
 * 
 * @param notiName 通知key
 * @param callback 方法名字
 * @param obj 调用对象
 */
function removeObserver(notiName, callback, obj) {
	var cbs = Notification[notiName];
	if (!cbs) {
		return;
	}
	for (var i = cbs.length - 1; i >= 0; i--) {
		var dic = cbs[i];
		if (dic.cb == callback && dic.obj == obj) {
			cbs.splice(i, 1);
		}
	}
	if (Notification[notiName].length == 0) {
		delete Notification[notiName];
	}
}