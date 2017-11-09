var itemdata = {
	items:{},
	delayItems:{},
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if (data.items) {
			var items = data.items
			for (var itemId in items) {
				var amount = items[itemId];
				this.items[itemId] = amount;
			}
		}
		if (data.delayItems) {
			var dItems = data.delayItems
			for (var k in dItems) {
				this.delayItems[k] = dItems[k];
			}
		}
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
	payItem:function(itemId, pay){
		var amount = this.items[itemId];
		if (amount) {
			amount -= pay;
		}
		this.items[itemId] = Math.max(amount, 0);
	},
	gainItem:function(itemId, gain){
		this.items[itemId] = this.items[itemId] || 0;
		this.items[itemId] += gain; 
	},
}
itemdata.addDataObserver();