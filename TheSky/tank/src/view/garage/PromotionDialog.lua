--[[
	车库鼠式坦克晋升
	Date: 2017-10 
]]

local PromotionDialog = qy.class("PromotionDialog", qy.tank.view.BaseDialog, "view/garage/PromotionDialog")

function PromotionDialog:ctor(uid,ddate,garageself)
    self.entity = qy.tank.entity.TankEntity
    PromotionDialog.super.ctor(self)
    self.model = qy.tank.model.GarageModel
    self.service = qy.tank.service.GarageService
    self.controller = qy.tank.controller.GarageController
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    print("选中的tankid",self.model.formation[garageself.selectIdx].tank_id)
    self.select_tank_id = self.model.formation[garageself.selectIdx].tank_id
    self.model:set_tankd_id(self.select_tank_id)

    self:InjectView("Button_1")
    self:InjectView("Close_Btn")
    self:InjectView("Ok_Btn")
    self:InjectView("Text_up")
    self:InjectView("Text_down")

    for i=1,11 do
        self:InjectView("Explain_"..i)
        self:InjectView("Desc_"..i)
        self:InjectView("BianKuang_"..i)
        self:InjectView("Image_"..i)
        self:InjectView("Item_"..i)
    end

    for i=1,2 do
        self:InjectView("Text_houlai_"..i)
        self:InjectView("Text_jichu_"..i)
        self:InjectView("Fuhao_"..i)
    end

    for i=1,3 do
        self:InjectView("Node_"..i)
    end
    for i=1,10 do
        self:InjectView("Tiao_"..i)
    end

    local award = self.model:GetJinSheng().consumes

   
    -- for i=1,#award do
    --     local item = qy.tank.view.common.AwardItem.createAwardView(award[i],1)
    --     self["Node_"..i]:addChild(item)
    --     item:setScale(0.8)
    --     item.fatherSprite:setSwallowTouches(false)
    --     item.name:setVisible(false)
    -- end
    self:showaward()

    self:OnClick("Close_Btn",function (  )
        qy.Event.dispatch(qy.Event.UPDATA_SHUSHI)
        --删除了东西
        self:removeSelf()
    end)

    self:OnClick("Ok_Btn",function (response)
        self.service:GetPromotion(uid,function (id)
        --qy.tank.entity.TankEntity.new(response)
        --qy.tank.entity.TankEntity:__initByData(response)
        print("PromotionDialog.self.x",self.x)
         print("PromotionDialog.self.x",self.select_tank_id) 
            if self.x == 10 then
                -- self.Ok_Btn:setTouchEnabled(false)
                -- self.Ok_Btn:setBright(false)
                print("晋升换tank",self.select_tank_id)
                local view = require("view/garage/AdvanceStarView").new(ddate,self.select_tank_id,id)
                self.viewStack:push(view)
            end
            self.model:Addx()
            self:updata(2)
        end)
    end)

    for i=1,11 do
        self:OnClick("Item_"..i,function ()
            if i <11 then
                self:showtext(i)
            else
                self.Text_up:setString("")
                self.Text_down:setString("")
                for i=1,2 do
                    self["Text_jichu_"..i]:setString("")
                    self["Text_houlai_"..i]:setString("战车晋升")
                    self["Fuhao_"..i]:setVisible(false)                   
                end      
            end
        end,{["isScale"] = false})
    end
    self:updata(1)
end

function PromotionDialog:updata(id)
    self.x = self.model:GetJinSheng().tank_list.promotion_stage -- 0,1,2,3,4..11 当前的晋升等级
    
   print("xxxxxxxxx",self.x)
    --设置文字
    for i=1,11 do
        self["Explain_"..i]:setString(self.model.config[tostring(self.select_tank_id)]["explain_"..i])--cell底部文字
        if i == self.x+1 then
            self["Desc_"..i]:setString(self.model.config1[tostring(i)].desc)--cell中部文字
        else
            self["Desc_"..i]:setString("前置未完成")
        end
        self["Desc_"..i]:setVisible(i > self.x)--中部文字是否可见
        self["BianKuang_"..i]:setVisible(i <= self.x)--是否显示边框
        self["Item_"..i]:setTouchEnabled(i > self.x)
        self["Item_"..i]:setBright(i > self.x)
        self["Image_"..i]:setVisible(i > self.x)--中部黄色img是否可见
    end
    
    for i=1,10 do
        self["Tiao_"..i]:setVisible(self.x >= i)
    end
    if id == 2 then
        -- local award = self.model:GetTankPromotion(self.x + 1)
        -- if award ~= nil then
        --     for i=1,#award do
        --         local item = qy.tank.view.common.AwardItem.createAwardView(award[i],1)
        --         self["Node_"..i]:removeAllChildren(true)
        --         self["Node_"..i]:addChild(item)
        --         item:setScale(0.8)
        --         item.fatherSprite:setSwallowTouches(false)
        --         item.name:setVisible(false)
        --     end
        -- end
        self:showaward2()
    end
    
    if self.x <10 then
        self:showtext(self.x+1)
    else
        self.Text_up:setString("")
        self.Text_down:setString("")
        for i=1,2 do
            self["Text_jichu_"..i]:setString("")
            self["Text_houlai_"..i]:setString("战车晋升")
            self["Fuhao_"..i]:setVisible(false)                   
        end      
    end  
end

function PromotionDialog:showtext(idx)
   
    local j,k = self.model:GetTypeId(idx,self.select_tank_id)--返回的是一行表格数据
    local shuju1,shuju2 = self.model:gettext2(idx,self.select_tank_id)--数据 600
    local shuju3 = self.model:getNum(self.x,j.type_str)
    if k ~=nil then
         local shuju4 = self.model:getNum(self.x,k.type_str)
        if self.model:GetJinSheng().tank_list[k.type_str] then
             local is_one = self:is_true(k.type_str)
            if is_one == 0 then
                self.Text_down:setString(k.desc..":")
                self.Text_jichu_2:setString(self.model:GetJinSheng().tank_list[k.type_str] + shuju4)
                self.Text_houlai_2:setString(self.model:GetJinSheng().tank_list[k.type_str] + shuju2.."  +"..shuju2 - shuju4)
            else
                self.Text_down:setString(k.desc..":")
                self.Text_jichu_2:setString(((self.model:GetJinSheng().tank_list[k.type_str] + shuju4)/10).."%")
                self.Text_houlai_2:setString(((self.model:GetJinSheng().tank_list[k.type_str] + shuju2)/10).."%      +"..((shuju2 - shuju4)/10).."%")
            end
        else
            local is_one = self:is_true(k.type_str)
            if is_one == 0 then
                self.Text_down:setString(k.desc..":")
                self.Text_jichu_2:setString(0 + shuju4)
                self.Text_houlai_2:setString(0 + shuju2.."  +"..shuju2 - shuju4)
            elseif is_one == 1 then
                if k.type_str == "hit_plus" then
                    self.Text_down:setString(k.desc..":")
                    self.Text_jichu_2:setString(((1000 + shuju4)/10).."%")
                    self.Text_houlai_2:setString(((1000 + shuju2)/10).."%      +"..((shuju2 - shuju4)/10).."%")
                elseif k.type_str == "crit_hurt" then
                    self.Text_down:setString(k.desc..":")
                    self.Text_jichu_2:setString(((1500 + shuju4)/10).."%")
                    self.Text_houlai_2:setString(((1500 + shuju2)/10).."%      +"..((shuju2 - shuju4)/10).."%")
                else
                    self.Text_down:setString(k.desc..":")
                    self.Text_jichu_2:setString(((0 + shuju4)/10).."%")
                    self.Text_houlai_2:setString(((0 + shuju2)/10).."%      +"..((shuju2 - shuju4)/10).."%")
                end
                
            end
        end
         self.Fuhao_2:setVisible(true)
    else
        self.Text_down:setString("")
        self.Text_houlai_2:setString("")
        self.Text_jichu_2:setString("")
        self.Fuhao_2:setVisible(false) 
    end

    if j ~=nil then
        if self.model:GetJinSheng().tank_list[j.type_str] then
             local is_one = self:is_true(j.type_str)
            if is_one == 0 then
                self.Text_up:setString(j.desc..":")
                self.Text_jichu_1:setString(self.model:GetJinSheng().tank_list[j.type_str] + shuju3)
                self.Text_houlai_1:setString(self.model:GetJinSheng().tank_list[j.type_str] + shuju1.."  +"..shuju1 - shuju3)
            else
                self.Text_up:setString(j.desc..":")
                self.Text_jichu_1:setString(((self.model:GetJinSheng().tank_list[j.type_str] + shuju3)/10).."%")
                self.Text_houlai_1:setString(((self.model:GetJinSheng().tank_list[j.type_str] + shuju1)/10).."%      +"..((shuju1 - shuju3)/10).."%")
            end
        else
            local is_one = self:is_true(j.type_str)
            if is_one == 0 then
                self.Text_up:setString(j.desc..":")
                self.Text_jichu_1:setString(0 + shuju3)
                self.Text_houlai_1:setString(0 + shuju1.."  +"..shuju1 - shuju3)
            elseif is_one == 1 then
                if j.type_str == "hit_plus" then
                    self.Text_up:setString(j.desc..":")
                    self.Text_jichu_1:setString(((1000 + shuju3)/10).."%")
                    self.Text_houlai_1:setString(((1000+ shuju1)/10).."%      +"..((shuju1 - shuju3)/10).."%")
                elseif j.type_str == "crit_hurt" then
                    self.Text_up:setString(j.desc..":")
                    self.Text_jichu_1:setString(((1500 + shuju3)/10).."%")
                    self.Text_houlai_1:setString(((1500+ shuju1)/10).."%      +"..((shuju1 - shuju3)/10).."%")
                else
                self.Text_up:setString(j.desc..":")
                self.Text_jichu_1:setString(((0 + shuju3)/10).."%")
                self.Text_houlai_1:setString(((0+ shuju1)/10).."%      +"..((shuju1 - shuju3)/10).."%")
                end
            end
        end
        self.Fuhao_1:setVisible(true)


    else
       
    end

end

function PromotionDialog:is_true(type_1)
     local array_list = {"hit_plus","crit_hurt","crit_rate","dodge_rate","anti_disarm_ratio"}
     local is_true = 0
     for k,v in pairs(array_list) do
         if v == type_1 then
            is_true = 1
            return is_true
        else
            is_true = 0
        end
     end
     return is_true
end

function PromotionDialog:showaward()
    for i=1,3 do
        self["Node_"..i]:removeAllChildren(true)
    end
    local award = self.model:GetJinSheng().consumes
    local item = qy.tank.view.common.AwardItem.createAwardView({
                ["type"] = award[1].type,
                ["num"] = award[1].num,
                ["id"] = award[1].id,
            }, 1)
        self.Node_1:addChild(item)
        local color = tonumber(award[1].num) > tonumber(qy.tank.model.UserInfoModel.userInfoEntity.silver) and cc.c4b(251, 48, 0,255) or cc.c4b(255, 255, 255, 255)
        item.num:setTextColor(color)
        item:setScale(0.8)
        item.fatherSprite:setSwallowTouches(false)
        item.name:setVisible(false)
        print("wocaininiisdfds",qy.tank.model.UserInfoModel.userInfoEntity.props)
        for k,v in pairs(qy.tank.model.UserInfoModel.userInfoEntity) do
            print(k,v)
        end

    local propsd = self.model:GetJinSheng().props
    local item = qy.tank.view.common.AwardItem.createAwardView({
            ["type"] = 14,
            ["num"] = award[2].num,
            ["id"] = award[2].id,
        }, 1)
    self.Node_2:addChild(item)
    if propsd[tostring(award[2].id)] then
        local color = tonumber(award[2].num) > tonumber(propsd[tostring(award[2].id)].num) and cc.c4b(251, 48, 0,255) or cc.c4b(255, 255, 255, 255)
        item.num:setTextColor(color)
    else
         item.num:setTextColor(cc.c4b(251, 48, 0,255))
    end
    item:setScale(0.8)
    item.fatherSprite:setSwallowTouches(false)
    item.name:setVisible(false)

    local item = qy.tank.view.common.AwardItem.createAwardView({
            ["type"] = award[3].type,
            ["num"] = award[3].num,
            ["id"] = award[1].id,
        }, 1)
    self.Node_3:addChild(item)
    local color = tonumber(award[3].num) > tonumber(qy.tank.model.UserInfoModel.userInfoEntity.prestige) and cc.c4b(251, 48, 0,255) or cc.c4b(255, 255, 255, 255)
    item.num:setTextColor(color)
    item:setScale(0.8)
    item.fatherSprite:setSwallowTouches(false)
    item.name:setVisible(false)
   end

function PromotionDialog:showaward2( )
    if self.x <11 then
        for i=1,3 do
            self["Node_"..i]:removeAllChildren(true)
        end
        self.model:updateziyuan(self.x)

        local award = self.model:GetTankPromotion(self.x + 1)
        local item = qy.tank.view.common.AwardItem.createAwardView({
                    ["type"] = award[1].type,
                    ["num"] = award[1].num,
                    ["id"] = award[1].id,
                }, 1)
            self.Node_1:addChild(item)
            local color = tonumber(award[1].num) > tonumber(qy.tank.model.UserInfoModel.userInfoEntity.silver) and cc.c4b(251, 48, 0,255) or cc.c4b(255, 255, 255, 255)
            item.num:setTextColor(color)
            item:setScale(0.8)
            item.fatherSprite:setSwallowTouches(false)
            item.name:setVisible(false)

        local propsd = self.model:GetJinSheng().props
        local item = qy.tank.view.common.AwardItem.createAwardView({
                ["type"] = 14,
                ["num"] = award[2].num,
                ["id"] = award[2].id,
            }, 1)
        self.Node_2:addChild(item)
        if propsd[tostring(award[2].id)] then
            local color = tonumber(award[2].num) > tonumber(propsd[tostring(award[2].id)].num) and cc.c4b(251, 48, 0,255) or cc.c4b(255, 255, 255, 255)
            item.num:setTextColor(color)
        else
            item.num:setTextColor(cc.c4b(251, 48, 0,255))
        end
        item:setScale(0.8)
        item.fatherSprite:setSwallowTouches(false)
        item.name:setVisible(false)

        local item = qy.tank.view.common.AwardItem.createAwardView({
                ["type"] = award[3].type,
                ["num"] = award[3].num,
                ["id"] = award[1].id,
            }, 1)
        self.Node_3:addChild(item)
        local color = tonumber(award[3].num) > tonumber(qy.tank.model.UserInfoModel.userInfoEntity.prestige) and cc.c4b(251, 48, 0,255) or cc.c4b(255, 255, 255, 255)
        item.num:setTextColor(color)
        item:setScale(0.8)
        item.fatherSprite:setSwallowTouches(false)
        item.name:setVisible(false)
    else
        for i=1,3 do
            self["Node_"..i]:setVisible(false)
        end
    end
end

return PromotionDialog
