lStorage = cc.sys.localStorage;
UDefKey = {
		Setting_BossAuto:"bossAuto",
		Setting_Music:"music",
		Setting_Effect:"effect",
};
function setUDBool(key, bStroage){
	lStorage.setItem(key, bStroage);
}
function getUDBool(key){
	return lStorage.getItem(key);
}