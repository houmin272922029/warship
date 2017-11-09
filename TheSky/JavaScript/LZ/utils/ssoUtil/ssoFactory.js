var ssoFactory = {
	instance:null,
	getInstance:function(){
		if (!this.instance) {
			trace("ssoType:"+ssoType);
			switch (ssoType) {
			case "testSSO" :
				this.instance = new testSSO();
				break;
			case "webSSO":
				this.instance = new webSSO();
				break;
			case "tgameCnSSO":
				this.instance = new tgameCnSSO();
				break;
			}
		}
		return this.instance;
	}
}