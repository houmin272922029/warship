var retina = cc._Reader.getResolutionScale();


//var COMMON_SERVER_URL = "http://188.188.188.106/ol/public";
//var PCLId = "talentwalkerTgameZhIos";

switch (ssoType) {
case "testSSO" :
	COMMON_SERVER_URL = "http://188.188.188.106/ol/public";
	PCLId = "testIntranet"
		break;
case "tgameCnSSO":
	COMMON_SERVER_URL = "http://ol.tw.7talent.com/public/";
	PCLId = "talentwalkerTgameTwIos";
	break;
}

var userID = "sj";
var token = "111";

var MD5_KEY = {
		SSO_SECRET_KEY : "dd09232c3c1c3f3c376dd83ddc0eb58c",
		LOGIN_KEY : "66fcc8ff4f3da51e6f62a9d98e288830"
}

var GAMEDEBUG = true;
var FONT_NAME = ccbi_dir + "/ccbi/ccbResources/FZCuYuan-M03S.ttf";

//version_sign_for_sed
var smallVersion = "eedf4a";

var CACHE_PATH = jsb.fileUtils.getCachePath();
var WRITABLE_PATH = jsb.fileUtils.getWritablePath();
var VERSION_FILE = "version.json";
cc.log("-----cache-----:" + CACHE_PATH);
cc.log("-----write-----:" + WRITABLE_PATH);
