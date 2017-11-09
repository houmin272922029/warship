var UnionMessage = cc.Layer.extend({
	ctor:function(messages){
		this._super();
		this.messages = messages;
		traceTable("messages", messages);
		cc.BuilderReader.registerController("UnionInfomationViewOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionMessage_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		
		for (var i = 0; i < 15; i++) {
			var msg = messages[i + ""];
			if (!msg) {
				this["message" + (i + 1)].visible = false;
				this["timeLabel" + (i + 1)].visible = false;
				continue;
			}
			this["message" + (i + 1)].setString(msg.message);
			var t = Global.serverTime - msg.time;
			var date = DateUtil.secondGetdhms(t);
			if (date.d > 0) {
				var d = Math.min(date.d, 7);
				this["timeLabel" + (i + 1)].setString(common.LocalizedString("union_information_daysbefore", d));
			} else {
				if (date.h > 0) {
					this["timeLabel" + (i + 1)].setString(common.LocalizedString("union_information_hoursbefore", date.h));
				} else {
					this["timeLabel" + (i + 1)].setString(common.LocalizedString("union_information_justbefore"));
				}
			}
		}		
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	}
});