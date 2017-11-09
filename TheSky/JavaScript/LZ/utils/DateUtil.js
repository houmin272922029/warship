var DateUtil = {
	/**
	 * 当前时间戳在今日
	 * 
	 * @param ts
	 */
	isToday:function(ts){
		var start = Global.serverBegin.ts;
		var offset = ts - start;
		return offset >= 0 && offset < 24 * 60 * 60;
	},
	/**
	 * 获取参数时间戳当天开始的时间戳
	 * 
	 * @param {Number} ts
	 * @return {Number}
	 */
	beginDay:function(ts){
		var d = new Date();
		d.setTime(ts * 1000);
		var start = Date.parse(d.format("yyyy-MM-dd")) + d.getTimezoneOffset() * 1000;
		return parseInt(start / 1000);
	},
	/**
	 * 将秒数转换为h:m:s形式
	 */
	second2hms:function(sec){
		var hour = Math.floor(sec / 3600);
		sec = sec % 3600;
		var min = Math.floor(sec / 60);
		sec = sec % 60;
		return parseInt(hour) + ":" + parseInt(min) + ":" + parseInt(sec);
	},
	/**
	 * 将秒数转换为h:m:s形式，大于一天显示x天
	 * @param sec
	 * @returns {String}
	 */
	second2dhms:function(sec){
		var day = Math.floor(sec / (3600 * 24));
		if (day > 0) {
			day = (sec % (3600 * 24) == 0) ? day : (day + 1);
			return day + "天";
		} else {
			sec = sec % (3600 * 24);
			var hour = Math.floor(sec / 3600);
			sec = sec % 3600;
			var min = Math.floor(sec / 60);
			sec = sec % 60;
			return parseInt(hour) + ":" + parseInt(min) + ":" + parseInt(sec);
		}
	},
	/**
	 * 获得天时分秒
	 * @param sec
	 * @returns {Object} {d:0, h:0, m:0, s:0}
	 */
	secondGetdhms:function(sec){
		var d = Math.floor(sec / (3600 * 24));
		sec %= (3600 * 24);
		var h = Math.floor(sec / 3600);
		sec %= 3600;
		var m = Math.floor(sec / 60);
		sec %= 60;
		return {d:d, h:h, m:m, s:sec};
	},
}

Date.prototype.format = function(format) {
	var date = {
			"M+": this.getMonth() + 1,
			"d+": this.getDate(),
			"h+": this.getHours(),
			"m+": this.getMinutes(),
			"s+": this.getSeconds(),
			"q+": Math.floor((this.getMonth() + 3) / 3),
			"S+": this.getMilliseconds()
	};
	if (/(y+)/i.test(format)) {
		format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
	}
	for (var k in date) {
		if (new RegExp("(" + k + ")").test(format)) {
			format = format.replace(RegExp.$1, RegExp.$1.length == 1
					? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
		}
	}
	return format;
}