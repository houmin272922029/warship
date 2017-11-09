function webSSO(){
	
}

webSSO.prototype = {
	login:function(func){
		cc.log("web login");
		func.apply();
	}
}