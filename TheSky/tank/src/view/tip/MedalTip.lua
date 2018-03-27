

local MedalTip = qy.class("MedalTip", qy.tank.view.BaseDialog, "view/tip/MedalTip")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel

function MedalTip:ctor(delegate)
    MedalTip.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self.delegate = delegate
    self:InjectView("pannel")
    self:InjectView("title")
    for i=1,3 do
    	self:InjectView("shuxing"..i)
    	self:InjectView("extra"..i)
    	self:InjectView("yizhi"..i)
    end
    self.data = delegate.data
    self:Update()
end
function MedalTip:onEnter()
    
end
function MedalTip:Update()
    self.attr = self.data
    local medaldata = model.medalcfg[self.attr.medal_id..""]
    self["title"]:setString(medaldata.name)
    local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(medaldata.medal_colour)
    self["title"]:setColor(color)
    local isfulllist = model:IsFull(self.attr,1)
    for i=1,3 do
    	local foreign_id = medaldata.foreign_id
    	local llist = model.localmedalcfg[foreign_id..""]
    	self["yizhi"..i]:setString(llist["name"..i])
        local data = self.attr.attr
        if data[i] then
            self["extra"..i]:setVisible(true)
            local id = data[i].attr_id
            local medalattr = model.medalattribute[id..""]
            local attribute = medalattr.attribute--类型
            local color = medalattr.colour_id --颜色 
            if color > 6 then color = 6 end
            self["attrcolor"..i] = color
            local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(color)
            self["shuxing"..i]:setColor(color)
            local  totalnum = data[i].attr_val
            --判断属性满不满
            if isfulllist["id"..i] == -1 then
                local tempnum = isfulllist["num"..i]/10
                if attribute < 6 then
                    self["extra"..i]:setString("+"..isfulllist["num"..i])
                else
                    self["extra"..i]:setString("+"..tempnum.."%")
                end
                self["extra"..i]:setColor(cc.c3b(255,255,255))
            elseif isfulllist["id"..i] == 1 then
                local tempnum = isfulllist["nothernum"..i]/10
                if attribute < 6 then
                    self["extra"..i]:setString(isfulllist["nothernum"..i])
                else
                    self["extra"..i]:setString(tempnum.."%")
                end
                totalnum = totalnum + isfulllist["num"..i]
                self["extra"..i]:setColor(cc.c3b(255,255,255))
                self["atttfull"..i] = true
            else
                self["atttfull"..i] = false
                totalnum = totalnum + isfulllist["num"..i]
                self["extra"..i]:setString("(共鸣)")
                self["extra"..i]:setColor(color)
            end
            if isfulllist["id"..i] == 1 then
                if attribute < 6 then
                    self["shuxing"..i]:setString("·"..model.tujianTypeNameList[tostring(attribute)]..":+"..totalnum.."(满)")
                else
                    local tempnum = totalnum/10
                    self["shuxing"..i]:setString("·"..model.tujianTypeNameList[tostring(attribute)]..":+"..tempnum.."%".."(满)")
                end
            else
                if attribute < 6 then
                    self["shuxing"..i]:setString("·"..model.tujianTypeNameList[tostring(attribute)]..":+"..totalnum)
                else
                    local tempnum = totalnum/10
                    self["shuxing"..i]:setString("·"..model.tujianTypeNameList[tostring(attribute)]..":+"..tempnum.."%")
                end
            end
        else
            self["shuxing"..i]:setString(" 未激活")
            self["shuxing"..i]:setColor(cc.c3b(255,255,255))
            self["extra"..i]:setVisible(false)
        end
    end
    -- local totalnum1 = 0
    -- local totalnum2 = 0
    -- local localrevise = model.localrevise--本地消耗表
    -- local medallist = model.medalcfg
    -- totalnum1 = self.data.af + totalnum1
    -- totalnum2 = self.data.ex + totalnum2
    -- local medal_id =self.data.medal_id
    -- local qulity = medallist[medal_id..""].medal_colour
    -- local decompose = localrevise[qulity..""].decompose
    -- for i=1,#decompose do
    --     if decompose[i].type == 42 then
    --          totalnum1 =  totalnum1 + decompose[i].num
    --     else
    --         totalnum2 =  totalnum2 + decompose[i].num
    --     end
    -- end
    -- self.num1:setString(totalnum1)
    -- self.num2:setString(totalnum2)
 
end
function MedalTip:onExit()
    
end


return MedalTip
