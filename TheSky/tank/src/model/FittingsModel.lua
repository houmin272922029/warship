--军衔model
local FittingsModel = qy.class("FittingsModel", qy.tank.model.BaseModel)
local StringUtil = qy.tank.utils.String
local ColorMapUtil = qy.tank.utils.ColorMapUtil


FittingsModel.TypeNameList ={
    ["1"] = "攻击力",
    ["2"] = "防御力",
    ["3"] = "生命值",
    ["4"] = "穿深",
    ["5"] = "穿深抵抗",
    ["6"] = "命中",
    ["7"] = "闪避",
    ["8"] = "暴击率",
    ["9"] = "暴伤减免",
    ["10"] = "缴械率",
    ["11"] = "暴击伤害",
    ["12"] = "攻击力",
    ["13"] = "防御力",
    ["14"] = "生命值",
    ["16"] = "伤害加成",
    ["17"] = "伤害减免",
    ["18"] = "暴击率减免",
    ["20"] = "无视防御",
    ["21"] = "治疗效果"
}
function FittingsModel:init(data)
	self.localfittingcfg = qy.Config.fittings--配件表
    self.localdeputycfg  = qy.Config.fittings_deputy_attr_weight --副属性表
    self.fittings_upgrade = qy.Config.fittings_upgrade --精炼消耗表
    self.fittings_shop = qy.Config.fittings_shop--商店表
    self.mianrange = 0.2 --主属性范围
    self.otherrange = 0.2--副属性范围
    self.refreshtype = 0 
    self.jingliantype = 0
    self.totallist = {}
    if data.fittings then
        self.totallist = data.fittings
    end
    
    self:sortlist(self.totallist)
  
   	
end
function FittingsModel:getcfgByQuality( qulity )
    local list = {}
    for k,v in pairs(self.localdeputycfg) do
        if v.quality == qulity then
          table.insert(list,v)
        end
    end
    table.sort(list, function(a, b)
        return a.ID < b.ID 
    end)
    return list

end
function FittingsModel:removeByqulity( list )--一键分解获得精铁数量（未装备未精炼）
    local num = 0
    for i=1,#list do
          for k,v in pairs(self.storelist) do
              local fittings_id = v.fittings_id
              local fine_iron = self.localfittingcfg[tostring(fittings_id)].fine_iron
              local qulity =  self.localfittingcfg[tostring(fittings_id)].quality
              if (list[i] == qulity) and v.level == 0 then
                num = num + fine_iron
              end
          end
    end

    return num
end
function FittingsModel:getfenjienums( list )--分解单个或者多个选择的，
    local num = 0
    for i=1,#list do
          for k,v in pairs(self.storelist) do
              local fittings_id = v.fittings_id
              local fine_iron = self.localfittingcfg[tostring(fittings_id)].fine_iron
             
              if list[i] == v.unique_id then
                  num = num + fine_iron
                  if v.level ~= 0 then
                    local qulity = self.localfittingcfg[tostring(fittings_id)].quality -1
                    local upxiaohao = self.fittings_upgrade[tostring(v.level)]["exp_sum_"..qulity]
                    num = num + upxiaohao *0.8
                  end
              end
            
          end
    end
    return num
end
--根据某个pos得到未装备的列表
function FittingsModel:getFittingsByPos( pos )
    local list = {}
        for k,v in pairs(self.storelist) do
            local ft_id = v.fittings_id
            local poss = self.localfittingcfg[tostring(ft_id)].fittings_type
            if poss == pos then
                table.insert(list,v)
            end
        end
    table.sort(list, function(a, b)
        local quality1 = self.localfittingcfg[tostring(a.fittings_id)].quality
        local quality2 = self.localfittingcfg[tostring(b.fittings_id)].quality
        if quality1 == quality2 then
            return a.level > b.level
        end
        return quality1 > quality2
    end)
    return list
end
function FittingsModel:GetupdataBydata( data )--精炼消耗
    local fitting_id = data.fittings_id
    local quality = self.localfittingcfg[tostring(fitting_id)].quality - 1
    local datas = self.fittings_upgrade[tostring(data.level)]
    local num = datas["exp_"..quality]
    return num
end
function FittingsModel:initShopList( data )
    self.refreshtimes = data.hand_times --刷新次数
    self.ShopList = data.shop
    self.buylog = data.log--已经购买过的放里面
    if data.next_refresh_time then
        self.next_refresh_time = data.next_refresh_time
    end
end
function FittingsModel:getFittingsById( ids )
    for k,v in pairs(self.totallist) do
        if v.unique_id == ids then
          return v
        end
    end
end
function FittingsModel:updateShopList( data )
    if data.shop then
        self.ShopList = data.shop
    end
    self.buylog = data.log
end
function FittingsModel:GetStoreList( postype, qulitytype )--筛选操作，
    local list = {}
    if type(postype) == "table" then
        if type(qulitytype) == "table" then
            for i=1,#postype do
                for j=1,#qulitytype do
                    for k,v in pairs(self.storelist) do
                        local fittings_id  = v.fittings_id
                        local pos = self.localfittingcfg[tostring(fittings_id)].fittings_type
                        local quality = self.localfittingcfg[tostring(fittings_id)].quality
                        if pos == postype[i] and quality == qulitytype[j] then
                          table.insert(list,v)
                        end
                    end
                end
            end
        else
           for i=1,#postype do
                for k,v in pairs(self.storelist) do
                    local fittings_id  = v.fittings_id
                    local pos = self.localfittingcfg[tostring(fittings_id)].fittings_type
                    if pos == postype[i]  then
                      table.insert(list,v)
                    end
                end
            end

        end
    else
        if type(qulitytype) == "table" then
            for j=1,#qulitytype do
                    for k,v in pairs(self.storelist) do
                        local fittings_id  = v.fittings_id
                        local quality = self.localfittingcfg[tostring(fittings_id)].quality
                        if quality == qulitytype[j] then
                          table.insert(list,v)
                        end
                    end
              end
        else
            list = self.storelist
        end
    end

    table.sort(list, function(a, b)
        local quality1 = self.localfittingcfg[tostring(a.fittings_id)].quality
        local quality2 = self.localfittingcfg[tostring(b.fittings_id)].quality
        local types1 = self.localfittingcfg[tostring(a.fittings_id)].fittings_type
        local types2 = self.localfittingcfg[tostring(b.fittings_id)].fittings_type
        if quality1 == quality2 then
            if a.level == b.level then
                if types1 == types2 then
                    return a.unique_id < b.unique_id 
                end
                return types1 < types2
            end
            return a.level > b.level
        end
        return quality1 > quality2
    end)
    return list
end
function FittingsModel:sortlist( date )
    self.storelist = {}--未装备的配件
    for k,v in pairs(date) do
        if v.tank_unique_id == 0 then
            v.ischoose = 0
            table.insert(self.storelist,v)
        end
    end
end
function FittingsModel:GetMedalByPos( pos )
    local list = {}
    for k,v in pairs(self.medallist) do
        local temppos = self.medalcfg[tostring(v.medal_id)].position
            if v.tank_unique_id == 0 and temppos == pos then
              table.insert(list,v)
            end
    end
    return list
end
function FittingsModel:addFittings( data )
    if data then
        if not self.totallist[tostring(data.unique_id)] then
            self.totallist[tostring(data.unique_id)] = data
        end
    end
    self:sortlist(self.totallist)
end
function FittingsModel:updatemedalById( data )
  local list = {}
  for k,v in pairs(data) do
     table.insert(list,v)
  end
  self.totallist[tostring(list[1].unique_id)] = list[1]
  self:sortlist(self.totallist)
end
function FittingsModel:updatemedalById1( data )
  local list = {}
  for k,v in pairs(data) do
      table.insert(list,v)
  end
  for k,v in pairs(list) do
      self.totallist[tostring(v.unique_id)] = v
  end
  self:sortlist(self.totallist)
end
function FittingsModel:removemedalById( data )
  for k,v in pairs(data) do
    for m,n in pairs(self.totallist) do
        if n.unique_id == v then
          self.totallist[m] = nil
        end
    end
  end
  self:sortlist(self.totallist)
end
function FittingsModel:atTank( tank_id )--由坦克id得到他身上的勋章
    local list = {}
    for k,v in pairs(self.totallist) do
        if v.tank_unique_id == tank_id then
            list[tostring(v.pos)] = v.unique_id
        end
    end
    return list
end
function FittingsModel:removetankfittings( data )
    -- print("removetankmedal",json.encode(data))
    for k,v in pairs(data) do
        for m,n in pairs(self.totallist) do
            if n.unique_id  == v.unique_id then
                n.tank_unique_id = v.tank_unique_id
            end
        end
    end
    self:sortlist(self.totallist)
end
function FittingsModel:totalAttr2( tank_id ,id)
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
    local staticdata = {}
    for k,v in pairs(self.totallist) do
        if v.tank_unique_id == tank_id then
            table.insert(staticdata,v)
        end
    end
    for k,v in pairs(staticdata) do
        --先算主属性
        local fittings_id = v.fittings_id
        local types = self.localfittingcfg[tostring(fittings_id)].type --z主属性类型
        local num = math.round(v.mval* ( 1 + v.level * 0.1))
        list[tostring(types)] = list[tostring(types)] + num

        --开始算副属性
        for m,n in pairs(v.sub_attr) do
            local nums = math.round(n.val * (1 + n.level * 0.5))
            list[tostring(n.type)] = list[tostring(n.type)] + nums
        end
    end
    if id then
        return list[tostring(id)]
    else
        return list
    end

end

return FittingsModel