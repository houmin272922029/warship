--[[
	坦克信息列表通用组件
	Author: Aaron Wei
	Date: 2015-11-09 11:19:09
]]

local TankInfoList = qy.class("TankInfoList", qy.tank.view.BaseView, "view/common/TankInfoList")

function TankInfoList:ctor(size)
	self.size = size
    self.talentMap = {qy.TextUtil:substitute(8033),qy.TextUtil:substitute(8034),qy.TextUtil:substitute(8035),qy.TextUtil:substitute(8036),qy.TextUtil:substitute(8037),qy.TextUtil:substitute(8038),qy.TextUtil:substitute(8039)}
    self.selectIdx = 1

    self:InjectView("info")

    local list = {"seal","tankName","tankLevel","tankType","attack","defense","blood","hit","dodge","crit","wear","antiWear", "crit_reduction"}
    for i = 1,#list do
        self:InjectView(list[i])
    end

    for i = 1,7 do
        self:InjectView("star"..i)
    end
end

function TankInfoList:render(entity)
    self:clear()

    if entity and type(entity) == "table" then
        -- 总容器
        if not self.info_c then
            -- self.info_c = cc.LayerColor:create(cc.c4b(0,255,255,125))
            self.info_c = cc.Layer:create()
        end

        local layout = nil
        -- 基础信息
        self.seal:loadTexture(entity:getSealIcon(),1)
        -- 战车名称
        self.tankName:setColor(entity:getFontColor())
        if entity.advance_level and entity.advance_level > 0 then
            self.tankName:setString(entity.name .. "  +" .. entity.advance_level)
        else
            self.tankName:setString(entity.name)
        end
        -- 坦克等级
        self.tankLevel:setString("LV."..entity.level)
        -- 战车类型
        self.tankType:setString(entity.typeName)
        -- 战车星级
        self:setStar(entity.star)
        -- 攻击力
        self.attack:setString(tostring(entity:getTotalAttack()))
        -- 防御力
        self.defense:setString(tostring(entity:getTotalDefense()))
        -- 生命力
        self.blood:setString(tostring(entity:getTotalBlood()))
        -- 穿深值
        self.wear:setString(tostring(entity:getWear()))
        -- 穿深抵抗值
        self.antiWear:setString(tostring(entity:getAnti_wear()))
        -- 命中
        self.hit:setString(tostring(entity:getHit()).."%")
        -- 闪避
        self.dodge:setString(tostring(entity:getDodgeRate()).."%")
        -- 暴击率
        self.crit:setString(tostring(entity:getTotalCritRate()).."%")
        -- 暴击减免
        self.crit_reduction:setString(tostring(entity:getTotalCritReductionRate()).."%")


        -- 动态容器
        if not tolua.cast(self.dynamic_c,"cc.Node") then
            -- self.dynamic_c = cc.LayerColor:create(cc.c4b(255,0,0,125))
            self.dynamic_c = cc.Layer:create()
        end

        -- 天赋
        local h = -5

        local talentTitleBG = ccui.ImageView:create()
        talentTitleBG:loadTexture("Resources/common/img/biaoti.png",1)
        talentTitleBG:setAnchorPoint(0,1)
        talentTitleBG:setPosition(0,h)
        self.dynamic_c:addChild(talentTitleBG)

        local talent = cc.Sprite:createWithSpriteFrameName("Resources/garage/z2.png")
        talent:setPosition(30,13)
        talent:setAnchorPoint(0,0)
        talentTitleBG:addChild(talent)

        h = h - talentTitleBG:getContentSize().height - 10

        local talentBG = ccui.ImageView:create()
        talentBG:ignoreContentAdaptWithSize(false)
        talentBG:loadTexture("Resources/common/bg/xinxidi1.png",0)
        talentBG:setScale9Enabled(true)
        talentBG:setCapInsets(cc.rect(85,19,90,22))
        talentBG:setAnchorPoint(0,1)
        talentBG:setPosition(0,h+5)
        self.dynamic_c:addChild(talentBG)
        layout = ccui.LayoutComponent:bindLayoutComponent(talentBG)


        local data = entity.talent.desc
        local px = 20
        for i=1,#data do
            -- local t_name = cc.Label:createWithSystemFont(self.talentMap[tonumber(data[i].name)],nil,20,cc.size(0,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
            local t_name = cc.Label:createWithTTF(self.talentMap[tonumber(data[i].name)],qy.res.FONT_NAME, 20.0,cc.size(0,0),1)
            t_name:setAnchorPoint(0,1)
            t_name:setTextColor(cc.c4b(254, 228, 144,255))
            t_name:setPosition(px,h)
            self.dynamic_c:addChild(t_name)

            -- local t_level = cc.Label:createWithSystemFont(tostring(data[i].level),nil,20,cc.size(0,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
            local t_level = cc.Label:createWithTTF(tostring(data[i].level),qy.res.FONT_NAME, 20.0,cc.size(0,0),1)
            t_level:setAnchorPoint(0,1)
            t_level:setTextColor(cc.c4b(255, 255, 255,255))
            t_level:setPosition(px+t_name:getContentSize().width,h)
            self.dynamic_c:addChild(t_level)
            if qy.language == "cn" then
                if i%2 == 1 then
                    px = 130
                elseif i ~= #data then
                    px = 20
                    h = h - 30
                end
            else
                px = 20
                    h = h - 30
            end
        end
        layout:setSize(cc.size(275,math.ceil(#data/qy.InternationalUtil:getTankInfoListLayoutHeight())*32))

        h = h - 35 -- 标题和内容的间隔
        -- 技能
        local skillTitleBg = cc.Sprite:createWithSpriteFrameName("Resources/common/img/biaoti.png")
        skillTitleBg:setPosition(0,h)
        skillTitleBg:setAnchorPoint(0,1)
        self.dynamic_c:addChild(skillTitleBg)
        h = h - skillTitleBg:getContentSize().height - 10

        local skill = cc.Sprite:createWithSpriteFrameName("Resources/garage/z3.png")
        skill:setPosition(30,13)
        skill:setAnchorPoint(0,0)
        skillTitleBg:addChild(skill)

        local skillBG = ccui.ImageView:create()
        skillBG:ignoreContentAdaptWithSize(false)
        skillBG:loadTexture("Resources/common/bg/xinxidi1.png",0)
        skillBG:setScale9Enabled(true)
        skillBG:setCapInsets(cc.rect(85,19,90,22))
        skillBG:setAnchorPoint(0,1)
        skillBG:setPosition(0,h+5)
        self.dynamic_c:addChild(skillBG)
        layout = ccui.LayoutComponent:bindLayoutComponent(skillBG)

        h = h - 5

        local commonSkillSign = cc.Sprite:createWithSpriteFrameName(entity.commonSkill.commonSign)
        commonSkillSign:setAnchorPoint(0,1)
        commonSkillSign:setPosition(3,h+8)
        self.dynamic_c:addChild(commonSkillSign)
        --local commonSkillDes = cc.Label:createWithSystemFont(entity.commonSkill.desc,nil,20,cc.size(230,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
         local commonSkillDes = cc.Label:createWithTTF(entity.commonSkill.desc,qy.res.FONT_NAME, 20.0,cc.size(230,0),0)
        commonSkillDes:setAnchorPoint(0,1)
        commonSkillDes:setPosition(38,h)
        self.dynamic_c:addChild(commonSkillDes)
        h = h - commonSkillDes:getContentSize().height - 10

        local compatSkillSign = cc.Sprite:createWithSpriteFrameName(entity.compatSkill.compatSign)
        compatSkillSign:setAnchorPoint(0,1)
        compatSkillSign:setPosition(3,h+8)
        self.dynamic_c:addChild(compatSkillSign)
        --local compatSkillDes = cc.Label:createWithSystemFont(entity.compatSkill.desc,nil,20,cc.size(230,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
        local compatSkillDes = cc.Label:createWithTTF(entity.compatSkill.desc,qy.res.FONT_NAME, 20.0,cc.size(230,0),0)
        compatSkillDes:setAnchorPoint(0,1)
        compatSkillDes:setPosition(38,h)
        self.dynamic_c:addChild(compatSkillDes)
        h = h - compatSkillDes:getContentSize().height - 15

        layout:setSize(cc.size(275,commonSkillDes:getContentSize().height+compatSkillDes:getContentSize().height+30))

        -- 介绍
        local desTitleBg = cc.Sprite:createWithSpriteFrameName("Resources/common/img/biaoti.png")
        desTitleBg:setPosition(3,h)
        desTitleBg:setAnchorPoint(0,1)
        self.dynamic_c:addChild(desTitleBg)
        h = h - desTitleBg:getContentSize().height -10

        local desTitle = cc.Sprite:createWithSpriteFrameName("Resources/garage/zhanchexinxi.png")
        desTitle:setAnchorPoint(0,0)
        desTitleBg:addChild(desTitle)
        desTitle:setPosition(30,13)

        local desBG = ccui.ImageView:create()
        desBG:ignoreContentAdaptWithSize(false)
        desBG:loadTexture("Resources/common/bg/xinxidi1.png",0)
        desBG:setScale9Enabled(true)
        desBG:setCapInsets(cc.rect(85,19,90,22))
        desBG:setAnchorPoint(0,1)
        desBG:setPosition(0,h+5)
        self.dynamic_c:addChild(desBG)
        layout = ccui.LayoutComponent:bindLayoutComponent(desBG)

        local des = cc.Label:createWithTTF(entity.des,qy.res.FONT_NAME, 20.0,cc.size(250,0),0)
        des:setAnchorPoint(0,1)
        des:setTextColor(cc.c4b(255,255,255,255))
        des:setPosition(10,h)
        self.dynamic_c:addChild(des)
        h = h - des:getContentSize().height
        layout:setSize(cc.size(275,des:getContentSize().height+10))


        self.info:setAnchorPoint(0,0)
        self.info:retain()
        self.info:getParent():removeChild(self.info)
        self.info_c:addChild(self.info)
        self.info:setPosition(0,-h)
        self.info:release()

        self.dynamic_c:setContentSize(270,h)
        self.info_c:addChild(self.dynamic_c)
        self.dynamic_c:setPosition(0,-h)

        self.info_c:setContentSize(270,-h+405)

        -- ScrollView
        if not tolua.cast(self.infoList,"cc.Node") then
            self.infoList = cc.ScrollView:create()
            self:addChild(self.infoList)
            self.infoList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
            self.infoList:ignoreAnchorPointForPosition(false)
            self.infoList:setClippingToBounds(true)
            self.infoList:setBounceable(true)
            self.infoList:setAnchorPoint(0,1)
            self.infoList:setPosition(0,0)
            self.infoList:setViewSize(self.size)
            self.infoList:setContainer(self.info_c)
        end

        self.infoList:updateInset()
        self.infoList:setDelegate()
        self.infoList:setContentOffset(cc.p(0,self.infoList:getViewSize().height-self.info_c:getContentSize().height),false)
    else
        -- self:clear()
    end
end

function TankInfoList:clear()
    -- self.tankName:setString("未选中坦克")
    -- self.tankType:setString("未选中坦克")
    -- self.attack:setString("未选中坦克")
    -- self.defense:setString("未选中坦克")
    -- self.blood:setString("未选中坦克")
    -- self.hit:setString("未选中坦克")
    -- self.dodge:setString("未选中坦克")
    -- self.crit:setString("未选中坦克")
    -- self.wear:setString("未选中坦克")
    -- self.antiWear:setString("未选中坦克")
    if tolua.cast(self.dynamic_c,"cc.Node") then
        self.dynamic_c:getParent():removeChild(self.dynamic_c)
    end
    -- self:setStar(0)
end

function TankInfoList:setStar(value)
    --print("TankInfoList:setStar star="..value)
    for i = 1,7 do
        if i <= value then
            self["star"..i]:setVisible(true)
        else
            self["star"..i]:setVisible(false)
        end
    end
end

function TankInfoList:onExit()
end

-- 销毁
function TankInfoList:onCleanup()
    print("TankInfoList:onCleanup")
    -- qy.tank.utils.cache.CachePoolUtil.removePlist("Resources/garage/garage",1)
end

return TankInfoList
