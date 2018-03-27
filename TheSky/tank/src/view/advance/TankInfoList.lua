--[[
	坦克信息列表通用组件
	Author: Aaron Wei
	Date: 2015-11-09 11:19:09
]]

local TankInfoList = qy.class("TankInfoList", qy.tank.view.BaseView, "view/advance/TankInfoList")

local model = qy.tank.model.AdvanceModel
function TankInfoList:ctor(size)
	self.size = size
    self.talentMap = {qy.TextUtil:substitute(3001),qy.TextUtil:substitute(3002),qy.TextUtil:substitute(3003),qy.TextUtil:substitute(3004),qy.TextUtil:substitute(3005),qy.TextUtil:substitute(3006),qy.TextUtil:substitute(3007)} 
    self.selectIdx = 1

    self:InjectView("info")
    self:InjectView("bg1")

    local list = {"seal","tankName","tankLevel","tankType","attack","defense","blood","hit","dodge","crit","wear","antiWear","attackAdd","defenseAdd","bloodAdd","hitAdd","dodgeAdd","critAdd","wearAdd","antiWearAdd","fight1","fight2","fight3","fight4","fight5","fight6","fight7","fight8",}
    for i = 1,#list do
        self:InjectView(list[i])
    end

    for i = 1,7 do
        self:InjectView("star"..i)
    end
end

function TankInfoList:render(entity, ltype)
    self:clear()

    self.entity = entity
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
        -- self.tankName:setString(entity.name)
        -- 坦克等级
        self.tankLevel:setString("LV."..entity.level)
        -- 战车类型
        self.tankType:setString(entity.typeName)
        -- 战车星级
        self:setStar(entity.star)
        -- 攻击力
        self.attack:setString(self.entity:getInitialAttack())
        -- 防御力
        self.defense:setString(self.entity:getInitialDefense())
        -- 生命力
        self.blood:setString(self.entity:getInitialBlood())
        -- 穿深值
        self.wear:setString(tostring(entity:getInitialWear()))
        -- 穿深抵抗值
        self.antiWear:setString(tostring(entity:getInitialAntiWear()))

         -- 命中
        self.hit:setString(tostring(self.entity:getInitialHit()).."%")
        -- 闪避
        self.dodge:setString(tostring(self.entity:getInitialDodgeRate()).."%")
        -- 暴击率
        self.crit:setString(tostring(self.entity:getInitialCritRate()).."%")

        -- 动态容器
        if not tolua.cast(self.dynamic_c,"cc.Node") then
            -- self.dynamic_c = cc.LayerColor:create(cc.c4b(255,0,0,125))
            self.dynamic_c = cc.Layer:create()
        end

         -- 天赋
        
        local tankCard =  qy.tank.view.common.ItemCard.new({
            ["entity"] = entity,
        })
        tankCard:setScale(0.8)
        tankCard:setPosition(135, 280)
        self.dynamic_c:addChild(tankCard)

        local h = -255
        local talentTitleBG = ccui.ImageView:create()
        talentTitleBG:loadTexture("Resources/common/img/line.png",1)
        talentTitleBG:setAnchorPoint(0,1)
        talentTitleBG:setPosition(0,h)
        self.dynamic_c:addChild(talentTitleBG)

        local talent = cc.Sprite:createWithSpriteFrameName("Resources/common/txt/zhanchetianfu.png")
        talent:setPosition(0,5)
        talent:setAnchorPoint(0,0)
        talentTitleBG:addChild(talent)

        h = h - talentTitleBG:getContentSize().height - 10
        
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
            local t_level = cc.Label:createWithTTF(tostring(data[i].level),qy.res.FONT_NAME, (qy.InternationalUtil:gettLevelHeight()),cc.size(0,0),1)
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
        -- layout:setSize(cc.size(275,math.ceil(#data/2)*32))

        h = h - 55 -- 标题和内容的间隔
        -- 技能
        local skillTitleBg = ccui.ImageView:create()
        skillTitleBg:loadTexture("Resources/common/img/line.png",1)
        -- local skillTitleBg = cc.Sprite:createWithSpriteFrameName("Resources/common/img/biaoti.png")
        skillTitleBg:setPosition(0,h)
        skillTitleBg:setAnchorPoint(0,1)
        self.dynamic_c:addChild(skillTitleBg)
        h = h - skillTitleBg:getContentSize().height - 10

        local skill = cc.Sprite:createWithSpriteFrameName("Resources/common/txt/jinengtihuan.png")
        skill:setPosition(0,5)
        skill:setAnchorPoint(0,0)
        skillTitleBg:addChild(skill)

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
        h = h - compatSkillDes:getContentSize().height - 35


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
        
        -- self.bg1:setCapInsets(cc.rect(80,80,50,50))
        self.bg1:setContentSize(cc.size(self.size.width, -h + 300))
        -- self.bg1:setPositionY(-90)
        self:setAddVisible2(ltype)
        self:addChild(self.info_c)

        self.h = -h  --用于外部调整scrollview高度
    else
        -- self:clear()
    end
end

function TankInfoList:clear()
    if tolua.cast(self.dynamic_c,"cc.Node") then
        self.dynamic_c:getParent():removeChild(self.dynamic_c)
    end
    -- self:setStar(0)
end

function TankInfoList:setStar(value)
    for i = 1,7 do
        if i <= value then
            self["star"..i]:setVisible(true)
        else
            self["star"..i]:setVisible(false)
        end
    end
end

function TankInfoList:setAddVisible2(ltype)
    for i = 1, 8 do
        self["fight" .. i]:setVisible(ltype)
    end

    self.attackAdd:setVisible(ltype)
    self.defenseAdd:setVisible(ltype)
    self.bloodAdd:setVisible(ltype)

    self.hitAdd:setVisible(ltype)
    self.dodgeAdd:setVisible(ltype)
    self.critAdd:setVisible(ltype)
    self.wearAdd:setVisible(ltype)
    self.antiWearAdd:setVisible(ltype)
end

function TankInfoList:setAddVisible(ltype)
    local data = model:atSpecailAttr(self.entity)
    local data2 = model:atCommonAttr(self.entity.advance_level + 1)
    -- "attackAdd","defenseAdd","bloodAdd","hitAdd","dodgeAdd","critAdd","wearAdd","antiWearAdd"
    self.attackAdd:setVisible(ltype)
    self.defenseAdd:setVisible(ltype)
    self.bloodAdd:setVisible(ltype)

    self.hitAdd:setVisible(ltype)
    self.dodgeAdd:setVisible(ltype)
    self.critAdd:setVisible(ltype)
    self.wearAdd:setVisible(ltype)
    self.antiWearAdd:setVisible(ltype)

    for i = 1, 8 do
        self["fight" .. i]:setVisible(not ltype)
    end

    self.attackAdd:setPositionX(self.attack:getPositionX() + self.attack:getContentSize().width)
    self.defenseAdd:setPositionX(self.defense:getPositionX() + self.defense:getContentSize().width)
    self.bloodAdd:setPositionX(self.blood:getPositionX() + self.blood:getContentSize().width)
    self.hitAdd:setPositionX(self.hit:getPositionX() + self.hit:getContentSize().width)
    self.dodgeAdd:setPositionX(self.dodge:getPositionX() + self.dodge:getContentSize().width)
    self.critAdd:setPositionX(self.crit:getPositionX() + self.crit:getContentSize().width)
    self.wearAdd:setPositionX(self.wear:getPositionX() + self.wear:getContentSize().width)
    self.antiWearAdd:setPositionX(self.antiWear:getPositionX() + self.antiWear:getContentSize().width)

    self.attackAdd:setString("+" .. data2.attack_plus)
    self.defenseAdd:setString("+" .. data2.defense_plus)
    self.bloodAdd:setString("+" .. data2.blood_plus)

    self.hitAdd:setString("")
    self.dodgeAdd:setString("")
    self.critAdd:setString("")
    self.wearAdd:setString("")
    self.antiWearAdd:setString("")

    if ltype then
        if data.type == 1 then
            self.attackAdd:setString("+" .. data2.attack_plus + data.param)
        elseif data.type == 2 then
            self.defenseAdd:setString("+" .. data2.defense_plus + data.param)
        elseif data.type == 3 then
            self.bloodAdd:setString("+" .. data2.blood_plus + data.param)
        elseif data.type == 4 then
            self.wearAdd:setString("+" .. data.param)
        elseif data.type == 5 then
            self.antiWearAdd:setString("+" .. data.param)
        elseif data.type == 6 then
            self.dodgeAdd:setString("+" .. data.param / 10 .. "%")
        elseif data.type == 7 then
            self.hitAdd:setString("+" .. data.param / 10 .. "%")
        elseif data.type == 8 then
            self.critAdd:setString("+" .. data.param / 10 .. "%")
        end
    else
        self.attack:setString(self.entity.basic_attack + data2.attack_plus)
        self.defense:setString(self.entity.basic_defense + data2.defense_plus)
        self.blood:setString(self.entity.basic_blood + data2.blood_plus)

        if data.type == 1 then
            self.attack:setString(self.entity.basic_attack + data2.attack_plus + data.param)
        elseif data.type == 2 then
            self.defense:setString(self.entity.basic_defense + data2.defense_plus + data.param)
        elseif data.type == 3 then
            self.blood:setString(self.entity.basic_blood + data2.blood_plus + data.param)
        elseif data.type == 4 then
            self.wear:setString(self.entity.wear + data.param)
        elseif data.type == 5 then
            self.antiWear:setString(self.entity.anti_wear + data.param)
        elseif data.type == 6 then
            self.dodge:setString((self.entity.dodge + data.param) / 10 .. "%")
        elseif data.type == 7 then
            self.hit:setString((self.entity.hit + data.param) / 10 .. "%")
        elseif data.type == 8 then
            self.crit:setString((self.entity.basic_crit_hurt + data.param) / 10 .. "%")
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
