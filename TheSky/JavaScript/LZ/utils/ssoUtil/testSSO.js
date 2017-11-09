function testSSO(){

}

testSSO.prototype = {
	login:function(func){
		cc.log("内网登陆");
		logindata.setUid(userID);
		logindata.setToken(token);
		func.apply();
	}
}