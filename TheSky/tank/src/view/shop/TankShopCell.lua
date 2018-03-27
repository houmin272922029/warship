--[[
	军需商店道具&装备cell
	Author: Aaron Wei
	Date: 2015-10-29 16:58:50
]]

local TankShopCell = qy.class("TankShopCell", qy.tank.view.BaseView, "view/shop/TankShopCell")

function TankShopCell:ctor(delegate)
    TankShopCell.super.ctor(self)
    self.currencyMap = {["orange_iron"] = qy.TextUtil:substitute(31012),["blue_iron"] = qy.TextUtil:substitute(31013),["purple_iron"] = qy.TextUtil:substitute(31014)}
    self.talentMap = {qy.TextUtil:substitute(31015),qy.TextUtil:substitute(31016),qy.TextUtil:substitute(31017),qy.TextUtil:substitute(31018),qy.TextUtil:substitute(31019),qy.TextUtil:substitute(31020),qy.TextUtil:substitute(31021)}
	self:InjectView("bg")
	self:InjectView("commentBtn")
	self:InjectView("exchangeBtn")
	self:InjectView("priceIcon")
	self:InjectView("price")
    self:InjectView("price_node_1")
    self:InjectView("price_node_3")
    self:InjectView("orange_iron_num")
    self:InjectView("reputation_num")

    self.userInfo = qy.tank.model.UserInfoModel
    local model = qy.tank.model.TankShopModel
    self.delegate = delegate
    self.price_node_1:setVisible(delegate.view_idx == 1)
    self.price_node_3:setVisible(delegate.view_idx == 3)

    --兑换坦克
    self:OnClick("exchangeBtn", function (sendr)
        local status = model:getStatusCanBeExchanged(self.entity,delegate.view_idx)
        -- 0:资源足够，可以兑换
		-- 1：第一种物资不足
		-- 2：第二种物资不足
        if status == 0 then
            local content
            if delegate.view_idx == 1 then
                -- 普通兑换
                content = qy.tank.view.shop.TankShopTip.new(self.entity)
            else
                -- 声望坦克兑换
                content = qy.tank.view.shop.ReputationTankTip.new(self.entity)
            end

            qy.alert:showWithNode(qy.TextUtil:substitute(31022), content, cc.size(560,250), {{qy.TextUtil:substitute(31023) , 4},{qy.TextUtil:substitute(31024) , 5} },function(flag)
                if flag == qy.TextUtil:substitute(31024) then
                    local service = qy.tank.service.ShopService
                    local id = self.entity.id
                    service:exchangeTank(delegate.view_idx,id,function(data)
                        delegate:updateResource()
                        if data and data.consume then
                            -- qy.hint:show("购买成功!消费"..self.currencyMap[data.consume.type].."x"..data.consume.num)
                        end
                        qy.tank.command.AwardCommand:add(data.award)
                        qy.tank.command.AwardCommand:show(data.award)
                    end)
                end
            end,"")
        elseif status == 1 then
            if self.entity.type == 1 then
                qy.hint:show(qy.TextUtil:substitute(31025))
            elseif self.entity.type == 2 then
                qy.hint:show(qy.TextUtil:substitute(31026))
            elseif self.entity.type == 3 then
                qy.hint:show(qy.TextUtil:substitute(31027))
            else
                qy.hint:show(qy.TextUtil:substitute(31027))
            end
        else
            qy.hint:show("声望不足")
        end
    end)

    self:OnClick("commentBtn", function (sendr)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TANK_COMMENT, self.entity.tank, 2)
    end,{["hasAudio"] = false})
end

function TankShopCell:render(entity)
	self.entity = entity
	self:clear()
    if entity and type(entity) == "table" then
    	self.bg:loadTexture(entity.bg,1)
        if self.delegate.view_idx == 3 then
            self.orange_iron_num:setString(entity.orange_iron)
            self.reputation_num:setString(entity.reputation)
        else
            self.priceIcon:setTexture(entity.priceIcon)
            self.price:setString(tostring(entity.number))
        end

    	-- 坦克卡
    	if not tolua.cast(self.tankCard,"cc.Node") then
	        self.tankCard =  qy.tank.view.common.ItemCard.new({
	            ["entity"] = entity.tank,
	        })
	        self:addChild(self.tankCard)
	        self.tankCard:setPosition(165,500)
	        self.tankCard:setScale(0.95)
    	else
	    	self.tankCard:update({
	            ["entity"] = entity.tank,
	        })
    	end

        self:OnClickForBuilding(self.tankCard.fatherSprite, function (sendr)
            if not self.delegate:isTouchMoved() then
                qy.alert:showTip(qy.tank.view.tip.TankTip.new(entity.tank))
            end
        end)


        -- 动态容器
        if not tolua.cast(self.container,"cc.Node") then
            -- self.container = cc.LayerColor:create(cc.c4b(255,0,0,125))
            self.container = cc.Layer:create()
        end

        if not tolua.cast(self.dynamic,"cc.Node") then
            self.dynamic = cc.Node:create()
            self.container:addChild(self.dynamic)
        end

        -- 天赋
        local xpos,h = 10,0
        local talentTitle = cc.Label:createWithTTF(qy.TextUtil:substitute(31028),qy.res.FONT_NAME, 24.0,cc.size(0,0),1)
        talentTitle:enableShadow(cc.c4b(0, 0, 0, 255), cc.size(-1, -1), 0)
        talentTitle:setAnchorPoint(0,1)
        talentTitle:setTextColor(cc.c4b(255,255,255,255))
        talentTitle:setPosition(xpos,h)
        self.dynamic:addChild(talentTitle)

        h = h - talentTitle:getContentSize().height - 5

        local data = entity.tank.talent.desc
        local px = 10
        for i=1,#data do
            local t_name = cc.Label:createWithTTF(self.talentMap[tonumber(data[i].name)],qy.res.FONT_NAME, 20.0,cc.size(0,0),1)
            t_name:setAnchorPoint(0,1)
            t_name:setTextColor(cc.c4b(254, 228, 144,255))
            t_name:setPosition(px,h)
            self.dynamic:addChild(t_name)

            local t_level = cc.Label:createWithTTF(tostring(data[i].level),qy.res.FONT_NAME, 20.0,cc.size(0,0),1)
            t_level:setAnchorPoint(0,1)
            t_level:setTextColor(cc.c4b(255, 255, 255,255))
            t_level:setPosition(px+t_name:getContentSize().width,h)
            self.dynamic:addChild(t_level)

            if i%2 == 1 then
                px = 130
            elseif i ~= #data then
                px = 10
                h = h - 30
            end
        end

        h = h - 30 -- 标题和内容的间隔
        -- 技能
        local skillTitle = cc.Label:createWithTTF(qy.TextUtil:substitute(31029),qy.res.FONT_NAME, 24.0,cc.size(0,0),1)
        skillTitle:enableShadow(cc.c4b(0, 0, 0, 255), cc.size(-1, -1), 0)
        skillTitle:setAnchorPoint(0,1)
        skillTitle:setTextColor(cc.c4b(255,255,255,255))
        skillTitle:setPosition(xpos,h)
        self.dynamic:addChild(skillTitle)

        h = h - skillTitle:getContentSize().height - 5

        local commonSkillSign = cc.Sprite:createWithSpriteFrameName(entity.tank.commonSkill.commonSign)
        commonSkillSign:setAnchorPoint(0,1)
        commonSkillSign:setPosition(xpos-3,h+5)
        self.dynamic:addChild(commonSkillSign)

         local commonSkillDes = cc.Label:createWithTTF(entity.tank.commonSkill.desc,qy.res.FONT_NAME_2, 20.0,cc.size(270,0),0)
        commonSkillDes:setAnchorPoint(0,1)
        commonSkillDes:setPosition(xpos+37,h)
        self.dynamic:addChild(commonSkillDes)
        h = h - commonSkillDes:getContentSize().height - 10

        local compatSkillSign = cc.Sprite:createWithSpriteFrameName(entity.tank.compatSkill.compatSign)
        compatSkillSign:setAnchorPoint(0,1)
        compatSkillSign:setPosition(xpos-3,h+5)
        self.dynamic:addChild(compatSkillSign)

        local compatSkillDes = cc.Label:createWithTTF(entity.tank.compatSkill.desc,qy.res.FONT_NAME_2, 20.0,cc.size(270,0),0)
        compatSkillDes:setAnchorPoint(0,1)
        compatSkillDes:setPosition(xpos+37,h)
        self.dynamic:addChild(compatSkillDes)
        h = h - compatSkillDes:getContentSize().height - 10

        -- 介绍
        local desTitle = cc.Label:createWithTTF(qy.TextUtil:substitute(31030),qy.res.FONT_NAME, 24.0,cc.size(0,0),1)
        desTitle:enableShadow(cc.c4b(0, 0, 0, 255), cc.size(-1, -1), 0)
        desTitle:setAnchorPoint(0,1)
        desTitle:setTextColor(cc.c4b(255,255,255,255))
        desTitle:setPosition(xpos,h)
        self.dynamic:addChild(desTitle)

        h = h - desTitle:getContentSize().height -10

        local des = cc.Label:createWithTTF(entity.tank.des,qy.res.FONT_NAME_2, 20.0,cc.size(310,0),0)
        des:setAnchorPoint(0,1)
        des:setTextColor(cc.c4b(255,255,255,255))
        des:setPosition(xpos,h)
        self.dynamic:addChild(des)
        h = h - des:getContentSize().height

        self.dynamic:setPosition(0,-h)
        self.container:setContentSize(310,-h)

        -- ScrollView
        if not tolua.cast(self.infoList,"cc.Node") then
            self.infoList = cc.ScrollView:create()
            self:addChild(self.infoList)
            self.infoList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
            self.infoList:ignoreAnchorPointForPosition(false)
            self.infoList:setClippingToBounds(true)
            self.infoList:setBounceable(true)
            self.infoList:setAnchorPoint(0,1)
            if self.delegate.view_idx == 1 then
                self.infoList:setPosition(5,355)
                self.infoList:setViewSize(cc.size(310,200))
            else
                self.infoList:setPosition(5,355)
                self.infoList:setViewSize(cc.size(310,175))
            end
            self.infoList:setContainer(self.container)
        end

        self.infoList:updateInset()
        self.infoList:setDelegate()
        self.infoList:setContentOffset(cc.p(0,self.infoList:getViewSize().height-self.container:getContentSize().height),false)
    else
        -- self:clearInfoList()
    end
end

function TankShopCell:clear()
    if tolua.cast(self.dynamic,"cc.Node") then
        self.dynamic:removeAllChildren()
    end
end

return TankShopCell
