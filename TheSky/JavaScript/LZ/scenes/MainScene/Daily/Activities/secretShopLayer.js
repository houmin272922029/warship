var secretShopLayer = DailyPageViewCell.extend({
	ctor : function(params){
		this._super(params);
	},
	
	onActivate : function() {
		DailyDrinkModule.fetchInstrucesData([]);
	},
});