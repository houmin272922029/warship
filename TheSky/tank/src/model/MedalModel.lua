--军衔model
local MedalModel = qy.class("MedalModel", qy.tank.model.BaseModel)
local StringUtil = qy.tank.utils.String
local ColorMapUtil = qy.tank.utils.ColorMapUtil


MedalModel.tujianTypeNameList ={
    ["1"] = "攻击",
    ["2"] = "防御",
    ["3"] = "生命",
    ["4"] = "穿深",
    ["5"] = "穿深抵抗",
    ["6"] = "暴击率",
    ["7"] = "暴击减免",
    ["8"] = "闪避",
    ["9"] = "命中",
    ["13"] = "暴伤减免"
}
function MedalModel:init(date)
	  print("勋章",json.encode(date))
   	self.localmedalcfg = qy.Config.medal--勋章读表
    self.medalcfg = qy.Config.medal_card--勋章碎片表
    self.localrevise = qy.Config.medal_revise--重铸或分解消耗表
    self.medalattribute = qy.Config.medal_attribute--属性随机表
    self.medalcolor = qy.Config.medal_colour--品质权重表
    -- print("+++++++++",json.encode(self.localmedalcfg))
    self.totallist = date
    self.medallist = {}--总medal数据，仓库里使用的
    self.explainlist = {}--可分解的medal
    self.chonghzutype = 0
    self:sortmedallist(date)
    -- for k,v in pairs(qy.Config.medal) do
    --   table.insert(self.localmedalcfg,V)
    -- end
    --  table.sort(self.localmedalcfg, function(a, b)
    --     return a.medal_id > b.medal_id 
    -- end)
  
   	
end
function MedalModel:initnum( data )
  -- {"baseinfo":{"direct_decompose_medal":[]},"recast_num":2}
    self.freetime = data.recast_num
    self.changelist = data.direct_decompose_medal
end
function MedalModel:initchangelist( data )
    self.changelist = data.direct_decompose_medal
end
function MedalModel:sortmedallist( date )
    for k,v in pairs(date) do
        local medalid  = v.medal_id
        v.medal_colour = self.medalcfg[tostring(medalid)].medal_colour
    end
    local list1 = {}
    local list2 = {}
    local list3 = {}
    self.medallist = {}
    self.explainlist ={}
    for k,v in pairs(date) do
        if v.tank_unique_id ~= 0 then
            table.insert(list1,v)
        else
            table.insert(list2,v)
        end
    end
    table.sort(list1, function(a, b)
        return a.medal_colour > b.medal_colour 
    end)
    table.sort(list2, function(a, b)
        return a.medal_colour > b.medal_colour 
    end)
    -- print(",,,,,,,,,,,,,,1111111",json.encode(list1))
    -- print(",,,,,,,,,,,,,,2222222",json.encode(list2))
    table.insertto(list1,list2)
    table.insertto(self.medallist,list1)
    -- print(",,,,,,,,,,,,,,2222222",json.encode(list3))
    -- self.medallist = list3[1][1]
    table.insertto(self.explainlist,list2)
    -- self.explainlist = self.explainlist[1]
    -- print("...................",json.encode(self.medallist))
end
function MedalModel:GetMedalByPos( pos )
    local list = {}
    for k,v in pairs(self.medallist) do
        local temppos = self.medalcfg[tostring(v.medal_id)].position
            if v.tank_unique_id == 0 and temppos == pos then
              table.insert(list,v)
            end
    end
    return list
end
function MedalModel:addMedal( data )
    if data then
        if not self.totallist[tostring(data.unique_id)] then
            self.totallist[tostring(data.unique_id)] = data
        end
    end
    self:sortmedallist(self.totallist)
end
function MedalModel:updatemedalById( data )
  local list = {}
  for k,v in pairs(data) do
     table.insert(list,v)
  end
  -- print("--",list[1].unique_id)
  -- print("写下之前",json.encode(self.totallist[tostring(list[1].unique_id)]))
  self.totallist[tostring(list[1].unique_id)] = list[1]
  -- print("写下之后啊啊啊啊",json.encode(self.totallist[tostring(list[1].unique_id)]))
  self:sortmedallist(self.totallist)
end
function MedalModel:removemedalById( data )
  for k,v in pairs(data) do
    for m,n in pairs(self.totallist) do
        if n.unique_id == v then
          self.totallist[m] = nil
        end
    end
  end
  self:sortmedallist(self.totallist)
end
function MedalModel:atTank( tank_id )--由坦克id得到他身上的勋章
    local list = {}
    for k,v in pairs(self.totallist) do
        if v.tank_unique_id == tank_id then
            list[tostring(v.pos)] = v.unique_id
        end
    end
    return list
end
function MedalModel:removetankmedal( data )
    -- print("removetankmedal",json.encode(data))
    for k,v in pairs(data) do
        for m,n in pairs(self.totallist) do
            if n.unique_id  == v then
                n.tank_unique_id = 0
            end
        end
    end
    self:sortmedallist(self.totallist)
end
function MedalModel:totalAttr( tank_id ,attrnum)--查看总数性,tank面板在这里取值
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
  ["13"] = 0
  }
  local staticdata = {}
  for k,v in pairs(self.totallist) do
      if v.tank_unique_id == tank_id then
          table.insert(staticdata,v)
      end
  end
  -- print("总数性啊",json.encode(staticdata))
  for k,v in pairs(staticdata) do
      local attr = v.attr
      local mannum = 0
      local totalnum = #attr
      -- print("一共几条属性",totalnum)
      -- print("11111111",json.encode(attr[1]))
      for k,p in pairs(attr) do
          local attr_id = p.attr_id
          -- print("///////////////",attr_id)
          local attribute = self.medalattribute[attr_id..""].attribute--第几号属性 123456789
          -- print("0000000000",attribute)
          --先计算属性是否满
          local attr_val = p.attr_val--返回的值，用来判断是否满或共鸣
          -- print("勋章id",v.medal_id)
          local qulity = self.medalcfg[v.medal_id..""].medal_colour  + 1--勋章的属性 
          -- if qulity > 6 then qulity = 6 end
          local tempdata = {}
          for k,v in pairs(self.medalattribute) do
              if v.colour_id == qulity and v.attribute == attribute then
                table.insert(tempdata,v)
              end
          end
          -- print("找到了唯一的一条",json.encode(tempdata))
          if attr_val >= tempdata[1].max then
              mannum = mannum + 1
             list[attribute..""] = list[attribute..""] + p.attr_val + tempdata[1].full
          else
             list[attribute..""] = list[attribute..""] + p.attr_val
          end
      end
        --判断是否共鸣
      for k,p in pairs(attr) do
          local attr_id = p.attr_id
          local attribute = self.medalattribute[attr_id..""].attribute--第几号属性 123456789
          --先计算属性是否满
          local attr_val = p.attr_val--返回的值，用来判断是否满或共鸣
          local qulity = self.medalcfg[v.medal_id..""].medal_colour  + 1--勋章的属性 
          local tempdata = {}
          for k,v in pairs(self.medalattribute) do
              if v.colour_id == qulity and v.attribute == attribute then
                table.insert(tempdata,v)
              end
          end
          if totalnum == 3 and mannum == 3 then
              -- print("共鸣了")
              list[attribute..""] = list[attribute..""] + tempdata[1].total_full
          end
      end
      

  end
  return list[tostring(attrnum)]
end
function MedalModel:totalAttr2( tank_id )
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
  ["13"] = 0
  }
  local staticdata = {}
  for k,v in pairs(self.totallist) do
      if v.tank_unique_id == tank_id then
          table.insert(staticdata,v)
      end
  end
  -- print("总数性啊",json.encode(staticdata))
  for k,v in pairs(staticdata) do
      local attr = v.attr
      local mannum = 0
      local totalnum = #attr
      -- print("一共几条属性",totalnum)
      -- print("11111111",json.encode(attr[1]))
      for k,p in pairs(attr) do
          local attr_id = p.attr_id
          -- print("///////////////",attr_id)
          local attribute = self.medalattribute[attr_id..""].attribute--第几号属性 123456789
          -- print("0000000000",attribute)
          --先计算属性是否满
          local attr_val = p.attr_val--返回的值，用来判断是否满或共鸣
          -- print("勋章id",v.medal_id)
          local qulity = self.medalcfg[v.medal_id..""].medal_colour  + 1--勋章的属性 
          -- if qulity > 6 then qulity = 6 end
          local tempdata = {}
          for k,v in pairs(self.medalattribute) do
              if v.colour_id == qulity and v.attribute == attribute then
                table.insert(tempdata,v)
              end
          end
          -- print("找到了唯一的一条",json.encode(tempdata))
          if attr_val >= tempdata[1].max then
              mannum = mannum + 1
             list[attribute..""] = list[attribute..""] + p.attr_val + tempdata[1].full
          else
             list[attribute..""] = list[attribute..""] + p.attr_val
          end
      end
        --判断是否共鸣
      for k,p in pairs(attr) do
          local attr_id = p.attr_id
          local attribute = self.medalattribute[attr_id..""].attribute--第几号属性 123456789
          --先计算属性是否满
          local attr_val = p.attr_val--返回的值，用来判断是否满或共鸣
          local qulity = self.medalcfg[v.medal_id..""].medal_colour  + 1--勋章的属性 
          local tempdata = {}
          for k,v in pairs(self.medalattribute) do
              if v.colour_id == qulity and v.attribute == attribute then
                table.insert(tempdata,v)
              end
          end
          if totalnum == 3 and mannum == 3 then
              -- print("共鸣了")
              list[attribute..""] = list[attribute..""] + tempdata[1].total_full
          end
      end
      

  end
  return list
end
function MedalModel:totalAttr3( data,idss )--查看资料用的啊
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
  ["13"] = 0
  }
  for k,v in pairs(data) do
      local attr = {}
      if type(v) == "number" then
      else
        attr = v.attr
      end
      local mannum = 0
      local totalnum = #attr
      -- print("一共几条属性",totalnum)
      -- print("11111111",json.encode(attr[1]))
      for k,p in pairs(attr) do
          local attr_id = p.attr_id
          -- print("///////////////",attr_id)
          local attribute = self.medalattribute[attr_id..""].attribute--第几号属性 123456789
          -- print("0000000000",attribute)
          --先计算属性是否满
          local attr_val = p.attr_val--返回的值，用来判断是否满或共鸣
          -- print("勋章id",v.medal_id)
          local qulity = self.medalcfg[v.medal_id..""].medal_colour  + 1--勋章的属性 
          -- if qulity > 6 then qulity = 6 end
          local tempdata = {}
          for k,v in pairs(self.medalattribute) do
              if v.colour_id == qulity and v.attribute == attribute then
                table.insert(tempdata,v)
              end
          end
          -- print("找到了唯一的一条",json.encode(tempdata))
          if attr_val >= tempdata[1].max then
              mannum = mannum + 1
             list[attribute..""] = list[attribute..""] + p.attr_val + tempdata[1].full
          else
             list[attribute..""] = list[attribute..""] + p.attr_val
          end
      end
        --判断是否共鸣
      for k,p in pairs(attr) do
          local attr_id = p.attr_id
          local attribute = self.medalattribute[attr_id..""].attribute--第几号属性 123456789
          --先计算属性是否满
          local attr_val = p.attr_val--返回的值，用来判断是否满或共鸣
          local qulity = self.medalcfg[v.medal_id..""].medal_colour  + 1--勋章的属性 
          local tempdata = {}
          for k,v in pairs(self.medalattribute) do
              if v.colour_id == qulity and v.attribute == attribute then
                table.insert(tempdata,v)
              end
          end
          if totalnum == 3 and mannum == 3 then
              -- print("共鸣了")
              list[attribute..""] = list[attribute..""] + tempdata[1].total_full
          end
      end
  end
  return list[idss..""]
end
function MedalModel:IsFull( data ,types)--id为第几条属性
  --返回list id = -1 代表没满，1 代表满了，2 代表共鸣  num为额外加多少值
  local list = {
    ["id1"] = 0,
    ["num1"]= 0,
    ["id2"] = 0,
    ["num2"]= 0,
    ["id3"] = 0,
    ["num3"]= 0,
    ["nothernum1"] =0,
    ["nothernum2"] =0,
    ["nothernum3"] =0,
    ["min1"] = 0,
    ["max1"] = 0,
    ["min2"] = 0,
    ["max2"] = 0,
    ["min3"] = 0,
    ["max3"] = 0,
  }
  local attr = {}
  if types == 1 then
     attr = data.attr
  else
     attr = data.mod_attr
  end
    local mannum = 0
    local totalnum = #attr
    -- print("一共几条属性",totalnum)
    local xx = 0
    -- print("11111111",json.encode(attr[1]))
    for k,p in pairs(attr) do
        xx = xx + 1
        local attr_id = p.attr_id
        -- print("///////////////",attr_id)
        local attribute = self.medalattribute[attr_id..""].attribute--第几号属性 123456789
        -- print("0000000000",attribute)
        --先计算属性是否满
        local attr_val = p.attr_val--返回的值，用来判断是否满或共鸣
        -- print("勋章id",data.medal_id)
        local qulity = self.medalcfg[data.medal_id..""].medal_colour  + 1--勋章的属性 
        -- if qulity > 6 then qulity = 6 end
        local tempdata = {}
        for k,v in pairs(self.medalattribute) do
            if v.colour_id == qulity and v.attribute == attribute then
              table.insert(tempdata,v)
            end
        end
        -- print("找到了唯一的一条",json.encode(tempdata))
        if attr_val >= tempdata[1].max then
            mannum = mannum + 1
            list["id"..xx] = 1
            list["nothernum"..xx] = tempdata[1].total_full
        else
            list["min"..xx] = tempdata[1].min
            list["max"..xx] = tempdata[1].max
            list["id"..xx] = -1
        end
        list["num"..xx] =  tempdata[1].full
    end
      --判断是否共鸣
      local yy = 0
    for k,p in pairs(attr) do
        yy = yy +1
        local attr_id = p.attr_id
        local attribute = self.medalattribute[attr_id..""].attribute--第几号属性 123456789
        --先计算属性是否满
        local attr_val = p.attr_val--返回的值，用来判断是否满或共鸣
        local qulity = self.medalcfg[data.medal_id..""].medal_colour  + 1--勋章的属性 
        local tempdata = {}
        for k,v in pairs(self.medalattribute) do
            if v.colour_id == qulity and v.attribute == attribute then
              table.insert(tempdata,v)
            end
        end
        if totalnum == 3 and mannum == 3 then
            -- print("共鸣了")
            list["id"..yy] = 2
            list["num"..yy] = list["num"..yy] + tempdata[1].total_full
        end
    end
    return list
end
return MedalModel