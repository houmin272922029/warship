local GodWarModel = qy.class("GodWarModel", qy.tank.model.BaseModel)

GodWarModel.TypeNameList ={
    ["1"] = "一",["2"] = "二",["3"] = "三",["4"] = "四",["5"] = "五",["6"] = "六",["7"] = "七",["8"] = "八",["9"] = "九",["10"] = "十",
    ["11"] = "至尊战神",["12"] = "阶礼包",["13"] = "阶特权",["14"] = "累计充值",["15"] = "钻石",["16"] = "本月已充值",
}
function GodWarModel:init(data)
	self.localfittingcfg = qy.Config.recharge_buff--配件表
    self.sviplevel = 0
    if data.recharge_buff then
    	self.sviplevel = data.recharge_buff.level
    end
end
function GodWarModel:getDataByid( id )
	return self.localfittingcfg[tostring(id)]
end
function GodWarModel:update( data )
	self.sviplevel = data.last_month_info.level
	self.rechagenum = data.current_month_info.num
	self.status = data.last_month_info.today_is_get
end
function GodWarModel:totalAttr(id)
    local list = {
    ["1"] = 0,
    ["2"] = 0,
    ["3"] = 0,
    ["4"] = 0,
    ["5"] = 0,
    ["6"] = 0,
    ["7"] = 0,
    ["8"] = 0,
    ["9"] = 0,
    ["10"] = 0,
    ["11"] = 0,
    ["12"] = 0,
    ["13"] = 0,
    ["14"] = 0,
    ["16"] = 0,
    ["17"] = 0,
    ["18"] = 0,
    ["20"] = 0,
    ["21"] = 0
    }
    if self.sviplevel == 0 then
    	return 0
    end
    local staticdata = self.localfittingcfg[tostring(self.sviplevel)]
    for i=1, staticdata.num do
    	local types = staticdata["type_"..i]
    	list[tostring(types)] = staticdata["param_"..i]
    end
    return list[tostring(id)]
end


return GodWarModel