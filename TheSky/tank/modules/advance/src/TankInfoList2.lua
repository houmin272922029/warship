--[[
	坦克信息列表通用组件
	Author: Aaron Wei
	Date: 2015-11-09 11:19:09
]]

local TankInfoList2 = qy.class("TankInfoList2", qy.tank.view.BaseView, "advance.ui.TankInfoList2")

local model = qy.tank.model.AdvanceModel
function TankInfoList2:ctor(size)
	self.size = size
    self.talentMap = {qy.TextUtil:substitute(40041),qy.TextUtil:substitute(40042),qy.TextUtil:substitute(40043),qy.TextUtil:substitute(40044),qy.TextUtil:substitute(40045),qy.TextUtil:substitute(40046),qy.TextUtil:substitute(40047)} 
    self.selectIdx = 1

    self:InjectView("info")
    self:InjectView("bg1")

    local list = {"seal","tankName","tankLevel","tankType","attack","defense","blood","hit","dodge","crit","wear","antiWear","attack2","defense2","blood2","hit2","dodge2","crit2","wear2","antiWear2","fight1","fight2","fight3","fight4","fight5","fight6","fight7","fight8","info","jiantou1","jiantou2","jiantou3","jiantou4","jiantou5","jiantou6","jiantou7","jiantou8"}
    for i = 1,#list do
        self:InjectView(list[i])
    end

    for i = 1,7 do
        self:InjectView("star"..i)
    end
end

function TankInfoList2:render(entity, entity2)
    self:clear()
    self.fightList = {}
    self.entity = entity
    self.entity2 = entity2
    if entity and type(entity) == "table" then
        -- 总容器
        if not self.info_c then
            -- self.info_c = cc.LayerColor:create(cc.c4b(0,255,255,125))
            self.info_c = cc.Layer:create()
        end

        local layout = nil
        -- 基础信息
        self.seal:loadTexture(self.entity2:getSealIcon(),1)
        -- 战车名称
        self.tankName:setColor(self.entity2:getFontColor())
        if entity.advance_level and entity.advance_level > 0 then
            self.tankName:setString(entity.name .. "  +" .. entity.advance_level)
        else
            self.tankName:setString(entity.name)
        end
        -- self.tankName:setString(self.entity2.name)
        -- 坦克等级
        self.tankLevel:setString("LV."..self.entity2.level)
        -- 战车类型
        self.tankType:setString(self.entity2.typeName)
        -- 战车星级
        self:setStar(self.entity2.star)
        -- 攻击力
        self.attack:setString(self.entity:getInitialAttack())
        -- 防御力
        self.defense:setString(self.entity:getInitialDefense())
        -- 生命力
        self.blood:setString(self.entity:getInitialBlood())
        -- 穿深值
        self.wear:setString(tostring(self.entity:getInitialWear()))
        -- 穿深抵抗值
        self.antiWear:setString(tostring(self.entity:getInitialAntiWear()))
          -- 命中
        self.hit:setString(tostring(self.entity:getInitialHit()).."%")
        -- 闪避
        self.dodge:setString(tostring(self.entity:getInitialDodgeRate()).."%")
        -- 暴击率
        self.crit:setString(tostring(self.entity:getInitialCritRate()).."%")
         -- 攻击力
        self.attack2:setString(self.entity2:getInitialAttack())
        -- 防御力
        self.defense2:setString(self.entity2:getInitialDefense())
        -- 生命力
        self.blood2:setString(self.entity2:getInitialBlood())
        -- 穿深值
        self.wear2:setString(tostring(self.entity2:getInitialWear()))
        -- 穿深抵抗值
        self.antiWear2:setString(tostring(self.entity2:getInitialAntiWear()))
        -- 命中
        self.hit2:setString(tostring(self.entity2:getInitialHit()).."%")
        -- 闪避
        self.dodge2:setString(tostring(self.entity2:getInitialDodgeRate()).."%")
        -- 暴击率
        self.crit2:setString(tostring(self.entity2:getInitialCritRate()).."%")


        -- 动态容器
        if not tolua.cast(self.dynamic_c,"cc.Node") then
            -- self.dynamic_c = cc.LayerColor:create(cc.c4b(255,0,0,125))
            self.dynamic_c = cc.Layer:create()
        end

         -- 天赋
        
        local tankCard =  qy.tank.view.common.ItemCard.new({
            ["entity"] = entity2,
        })
        tankCard:setScale(0.8)
        tankCard:setPosition(235, 280)
        self.tankCard = tankCard
        self.dynamic_c:addChild(tankCard)

        local h = -295
        local talentTitleBG = ccui.ImageView:create()
        talentTitleBG:loadTexture("Resources/common/img/line.png",1)
        talentTitleBG:setAnchorPoint(0,1)
        talentTitleBG:setPosition(10,h)
        self.dynamic_c:addChild(talentTitleBG)

        local talent = cc.Sprite:createWithSpriteFrameName("Resources/common/txt/zhanchetianfu.png")
        talent:setPosition(10,5)
        talent:setAnchorPoint(0,0)
        talentTitleBG:addChild(talent)

        h = h - talentTitleBG:getContentSize().height - 10
        
        local data = entity.talent.desc
        local data2 = entity2.talent.desc
        h = h - 30
        for i=1,#data2 do
            local item = require("advance.src.InfoList").new(data[i], data2[i])
            item:setPosition(26, h) 
            h = h - 30
            self.dynamic_c:addChild(item)
        end

        -- h = h - 55 -- 标题和内容的间隔
        -- 技能
        local skillTitleBg = ccui.ImageView:create()
        skillTitleBg:loadTexture("Resources/common/img/line.png",1)
        -- local skillTitleBg = cc.Sprite:createWithSpriteFrameName("Resources/common/img/biaoti.png")
        skillTitleBg:setPosition(10,h)
        skillTitleBg:setAnchorPoint(0,1)
        self.dynamic_c:addChild(skillTitleBg)
        h = h - skillTitleBg:getContentSize().height - 10

        local skill = cc.Sprite:createWithSpriteFrameName("Resources/common/txt/jinengtihuan.png")
        skill:setPosition(10,5)
        skill:setAnchorPoint(0,0)
        skillTitleBg:addChild(skill)

        h = h - 5    

        local commonSkillSign = cc.Sprite:createWithSpriteFrameName(entity.commonSkill.commonSign)
        commonSkillSign:setAnchorPoint(0,1)
        commonSkillSign:setPosition(3,h+8)
        self.dynamic_c:addChild(commonSkillSign)
        --local commonSkillDes = cc.Label:createWithSystemFont(entity.commonSkill.desc,nil,20,cc.size(230,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
         local commonSkillDes = cc.Label:createWithTTF(entity.commonSkill.desc,qy.res.FONT_NAME, 20.0,cc.size(420,0),0)
        commonSkillDes:setAnchorPoint(0,1)
        commonSkillDes:setPosition(38,h)
        self.dynamic_c:addChild(commonSkillDes)
        h = h - commonSkillDes:getContentSize().height - 10

        local compatSkillSign = cc.Sprite:createWithSpriteFrameName(entity.compatSkill.compatSign)
        compatSkillSign:setAnchorPoint(0,1)
        compatSkillSign:setPosition(3,h+8)
        self.dynamic_c:addChild(compatSkillSign)
        --local compatSkillDes = cc.Label:createWithSystemFont(entity.compatSkill.desc,nil,20,cc.size(230,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
        local compatSkillDes = cc.Label:createWithTTF(entity.compatSkill.desc,qy.res.FONT_NAME, 20.0,cc.size(420,0),0)
        compatSkillDes:setAnchorPoint(0,1)
        compatSkillDes:setPosition(38,h)
        self.dynamic_c:addChild(compatSkillDes)
        h = h - compatSkillDes:getContentSize().height - 35

        local downChange = cc.Sprite:createWithSpriteFrameName("Resources/common/img/jiantou3.png")
        downChange:setRotation(90)
        downChange:setPosition(235, h)

        self.dynamic_c:addChild(downChange)

        h = h - 50


        local commonSkillSign2 = cc.Sprite:createWithSpriteFrameName(entity2.commonSkill.commonSign)
        commonSkillSign2:setAnchorPoint(0,1)
        commonSkillSign2:setPosition(3,h+8)
        self.dynamic_c:addChild(commonSkillSign2)
        --local commonSkillDes = cc.Label:createWithSystemFont(entity.commonSkill.desc,nil,20,cc.size(230,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
         local commonSkillDes2 = cc.Label:createWithTTF(entity2.commonSkill.desc,qy.res.FONT_NAME, 20.0,cc.size(420,0),0)
        commonSkillDes2:setAnchorPoint(0,1)
        commonSkillDes2:setPosition(38,h)
        self.dynamic_c:addChild(commonSkillDes2)
        h = h - commonSkillDes2:getContentSize().height - 10

        local compatSkillSign2 = cc.Sprite:createWithSpriteFrameName(entity2.compatSkill.compatSign)
        compatSkillSign2:setAnchorPoint(0,1)
        compatSkillSign2:setPosition(3,h+8)
        self.dynamic_c:addChild(compatSkillSign2)
        --local compatSkillDes = cc.Label:createWithSystemFont(entity.compatSkill.desc,nil,20,cc.size(230,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
        local compatSkillDes2 = cc.Label:createWithTTF(entity2.compatSkill.desc,qy.res.FONT_NAME, 20.0,cc.size(420,0),0)
        compatSkillDes2:setAnchorPoint(0,1)
        compatSkillDes2:setPosition(38,h)
        self.dynamic_c:addChild(compatSkillDes2)
        h = h - compatSkillDes2:getContentSize().height - 35

        self.info:setAnchorPoint(0,0)
        self.info:retain()
        self.info:getParent():removeChild(self.info)
        self.info_c:addChild(self.info)
        self.info:setPosition(0,-h - 210)
        self.info:release()

        self.dynamic_c:setContentSize(270,h)
        self.info_c:addChild(self.dynamic_c)
        self.dynamic_c:setPosition(0,-h)

        self.info_c:setContentSize(270,-h+380)
        
        self.bg1:setContentSize(cc.size(self.size.width, -h + 300))
        self:addChild(self.info_c)

        self.h = -h  --用于外部调整scrollview高度
        self:addFightAnimate()
        self:addJiantouAnimate()
    else
        -- self:clear()
    end
end

function TankInfoList2:clear()
    if tolua.cast(self.dynamic_c,"cc.Node") then
        self.dynamic_c:getParent():removeChild(self.dynamic_c)
    end
    -- self:setStar(0)
end

function TankInfoList2:setStar(value)
    for i = 1,7 do
        if i <= value then
            self["star"..i]:setVisible(true)
        else
            self["star"..i]:setVisible(false)
        end
    end
end

function TankInfoList2:addFightAnimate()
    local list = {
        ["1"] = {["x"] = 422.00, ["y"] = 157.50},
        ["2"] = {["x"] = 422.00, ["y"] = 130.50},
        ["3"] = {["x"] = 422.00, ["y"] = 105.50},
        ["4"] = {["x"] = 422.00, ["y"] = 70.50},
        ["5"] = {["x"] = 422.00, ["y"] = 43.50},
        ["6"] = {["x"] = 422.00, ["y"] = 15.50},
        ["7"] = {["x"] = 422.00, ["y"] = -11.50},
        ["8"] = {["x"] = 422.00, ["y"] = -39.50},
    }
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("advance/fx/ui_fx_jiantoutishi", function()
        for i = 1, 8 do
            local effect = ccs.Armature:create("ui_fx_jiantoutishi")
            self.info:addChild(effect,999)
            effect:setAnchorPoint(0.5,0.5)
            effect:setPosition(list[tostring(i)].x ,list[tostring(i)].y)
            effect:getAnimation():playWithIndex(0, 1, 1)
            table.insert(self.fightList, effect)
        end
        -- self.effect = ccs.Armature:create("ui_fx_jiantoutishi") 
        -- self.TankBg1:addChild(self.effect,999)
        -- self.effect:setAnchorPoint(0.5,0.5)
        -- self.effect:setPosition(50 ,160)
        -- self.effect:getAnimation():playWithIndex(0, 1, 0)
    end)
end

function TankInfoList2:addJiantouAnimate()
    for i = 1, 8 do
        local item = self["jiantou" .. i]
        local func0 = cc.DelayTime:create(0.2)

        local func1 = cc.CallFunc:create(function()
            item:setSpriteFrame("Resources/common/img/jiantou2.png")
        end)

        local func2 = cc.DelayTime:create(0.2)

        local func3 = cc.CallFunc:create(function()
            item:setSpriteFrame("Resources/common/img/jiantou3.png")
        end)

        local func4 = cc.DelayTime:create(0.2)

        local func5 = cc.CallFunc:create(function()
            item:setSpriteFrame("Resources/common/img/jiantou4.png")
        end)

        local func6 = cc.DelayTime:create(0.2)

        local func7 = cc.CallFunc:create(function()
            item:setSpriteFrame("Resources/common/img/jiantou1.png")
        end)

        local seq = cc.Sequence:create(func0, func1, func2, func3, func4, func5, func6, func7)

        self["jiantou" .. i]:runAction(cc.RepeatForever:create(seq))
    end
end

function TankInfoList2:onExit()
end

-- 销毁
function TankInfoList2:onCleanup()
    print("TankInfoList:onCleanup")
    -- qy.tank.utils.cache.CachePoolUtil.removePlist("Resources/garage/garage",1)
end

return TankInfoList2
