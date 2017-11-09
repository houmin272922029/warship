//LoginModule.login = LoginModule.login.before(loginChangeParams).after(loginChangeReturn);

//around(LoginModule, "login", loginInterceptorMethod1);
//around(LoginModule, "login", loginInterceptorMethod2);

function loginChangeParams(){
	cc.log("login before");
	arguments[0].name = "DUMMY";
	cc.log("login change arguments");
}

function loginChangeReturn(){
	cc.log("login after");
	cc.log("login change return");
	return "login intercepter succ";
}

var loginInterceptorMethod1 = function(func){
	return function(){
		arguments[0].name = "summy001";
		cc.log("before function method1");
		func.apply(this, arguments);
		cc.log("after function method1");
		return "loginInterceptorMethod1";
	}
}

var loginInterceptorMethod2 = function(func){
	return function(){
		arguments[0].name = "summy002";
		cc.log("before function method2");
		func.apply(this, arguments);
		cc.log("after function method2");
		return "loginInterceptorMethod2";
	}
}

/**
 * 拦截login方法，可以检查参数
 * 
 * @param func
 * @returns {Function}
 */
function loginInterceptorMethod(func){
	return function(){
		cc.log("before login");
		var name = arguments[0].name;
		if (name === "summy") {
			cc.log("临时禁止summy登陆");
			return false;
		}
		var ret = func.apply(this, arguments);
		cc.log("after login");
		return ret;
	}
}
