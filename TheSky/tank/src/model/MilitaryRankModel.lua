--军衔model
local MilitaryRankModel = qy.class("MilitaryRankModel", qy.tank.model.BaseModel)
local StringUtil = qy.tank.utils.String
local ColorMapUtil = qy.tank.utils.ColorMapUtil

function MilitaryRankModel:init(date,callback)
	--{"attack":0,"militaryrank_level":1,"exp_time":20160920,"is_get":100,"exp":0,"type":200,"defense":0,"get_time":20160920,"blood":0}
	print("军衔数据",json.encode(date))
   	self.localcfg = qy.Config.militaryrank--读表
   	self.localranklevelcfg = qy.Config.militaryrank_level
   	self.NowRanklevle = date.militaryrank_level
   	self.ExperienceValue = date.exp
   	self.is_get = date.is_get
   	self.attack = date.attack
   	self.defense = date.defense
   	self.blood = date.blood
   	self.type = date.type
   	callback()
end

function MilitaryRankModel:getAddAttrSingle(type)
   --计算战斗力获取攻击防御，生命的接口
   	-- if self.NowRanklevle ~= 1 then 
    --     for i=1,self.NowRanklevle-1 do
    --         local data = self.localcfg[tostring(i)]
    --         local data2 =  self.localranklevelcfg[tostring(i)]
    --         att = att + data.attack + data2.attack*10
    --         def = def + data.defense + data2.defense*10
    --         blod = blod + data.blood + data2.blood*10
    --     end
    -- end
    local _data = self:getlocalDateById(self.NowRanklevle)
    local _data1 = self:getlocalLevelDateById(self.NowRanklevle)
    local totalatt = _data.attack + _data1.attack * self.attack + _data1.total_attack
    local totaldef = _data.defense + _data1.defense * self.defense + _data1.total_defense
    local totalblod = _data.blood + _data1.blood * self.blood + _data1.total_blood
   	if type == 1 then
   		return totalatt
   	elseif type == 2 then
   		return totaldef
   	elseif type == 3 then
   		return totalblod
   	end
end
function MilitaryRankModel:getlocalDateById(id)
   return self.localcfg[tostring(id)]
end

function MilitaryRankModel:getlocalLevelDateById(id)
   return self.localranklevelcfg[tostring(id)]
end
--当前军衔等级
function MilitaryRankModel:getRankLevel()
   return self.NowRanklevle
end
function MilitaryRankModel:GetExperienceValue(  )
	-- body
	print("历练值",self.ExperienceValue)
	return self.ExperienceValue
end
function MilitaryRankModel:getBtn( )
	-- body
	return self.is_get
end
function MilitaryRankModel:uplevel(type )
	if type == 1 then
		self.uptype = true
	else
		self.uptype = false
	end
end
function MilitaryRankModel:getuplevel()
	return self.uptype
end
function MilitaryRankModel:GetNumById(id)
	-- 返回三个属性的个数
	if id == 1 then
		return self.attack
	end
	if id == 2 then
		return self.defense
	end
	if id == 3 then
		return self.blood
	end
	if id == 4 then
		return self.blood + self.attack + self.defense
	end
end
function MilitaryRankModel:GetType( )
	return self.type
end
function MilitaryRankModel:GetValueById( id )
	-- 飘字儿属性
	if id == 1 then
		return self.localranklevelcfg[tostring(self.NowRanklevle)].attack
	end
	if id == 2 then
		return self.localranklevelcfg[tostring(self.NowRanklevle)].defense
	end
	if id == 3 then
		return self.localranklevelcfg[tostring(self.NowRanklevle)].blood
	end
end
function MilitaryRankModel:getDescInfoByStr(_str,type)
    local infoArr = {}
    if _str == nil then
        return infoArr
    end

    local _arr = StringUtil.split(_str, "&")
    if _arr == nil or #_arr == 0 then
        return infoArr
    end

    infoArr.txt = {}
    infoArr.color = {}

    if #_arr == 1 then
        local _arr2 = StringUtil.split(_arr[1], "#")
        infoArr.txt[1] = _arr2[1]
        infoArr.color[1] = ColorMapUtil.qualityMapColorFor3b(tonumber(_arr2[2]) or 1)
    else
        for i = 1, #_arr do
            -- print("_arr _arr _arr _arr _arr===",_arr[i])
            local _arr2 = StringUtil.split(_arr[i], "#")
            -- print("_arr2 _arr2 _arr2 _arr2 _arr2===",qy.json.encode(_arr2))
            infoArr["txt"][i] = _arr2[1]
            infoArr["color"][i] = ColorMapUtil.qualityMapColorFor3b(tonumber(_arr2[2]) or 1)
            -- print("color color color color color=self==",qy.json.encode(infoArr.color[i-1]))
        end
    end

    local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(true)
    -- richTxt:setContentSize(500, 150)
    richTxt:setAnchorPoint(0.5,0.5)
    local txt 
    if type ==1 then
    	txt = "特权:"..infoArr.txt[1]
    elseif type == 2 then
    	txt = infoArr.txt[1]
    else
    	txt = "解锁特权:"..infoArr.txt[1]
    end
    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(infoArr.color[1].r,infoArr.color[1].g,infoArr.color[1].b), 255, txt, qy.res.FONT_NAME, 20)
    richTxt:pushBackElement(stringTxt1)
    local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(infoArr.color[2].r,infoArr.color[2].g,infoArr.color[2].b), 255, infoArr.txt[2] , qy.res.FONT_NAME, 20)
    richTxt:pushBackElement(stringTxt2)
     

    return richTxt
end




return MilitaryRankModel