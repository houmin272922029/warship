--[[
--tip
--Author: H.X.Sun
--Date: 2015-07-17
]]

local TankTip = qy.class("TankTip", qy.tank.view.BaseDialog, "view/tip/TankTip")

function TankTip:ctor(entity)
    TankTip.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/img/common_img.plist")
    self.entity = entity

	local style = qy.tank.view.style.DialogStyle5.new({
		size = cc.size(610,450),
        position = cc.p(0,0),
        offset = cc.p(0,0),

		-- ["onClose"] = function() end
	})
	self:addChild(style, -1)

	self:InjectView("panel")
	self:InjectView("scrollView")
	self:InjectView("btn_comment")
	self:InjectView("btn_ok")

	self.btn_comment:setVisible(true)
	self.btn_ok:setVisible(true)
	-- self:InjectView("attack")
	-- self:InjectView("defense")
	-- self:InjectView("blood")
	-- self:InjectView("costIngfoBg")
	-- for i = 1, 6 do
	-- 	self:InjectView("star" .. i)
	-- end

	-- self.card = qy.tank.view.common.ItemCard.new({
	-- 	["entity"] = entity,
	-- 	-- ["frame"] = entity:getCardFrame(),
	-- 	-- ["name"] = entity.name,
	-- 	["bgScale"] = 0.8
	-- })
	-- self.card:setPosition(150,278)
	-- self.scrollView:addChild(self.card)

	-- self.tankName:setString(entity.name)
	-- self.tankName:setColor(entity:getFontColor())
	-- -- 战车类型
	-- self.tankType:setString(entity.typeName)
	-- -- 战车星级
	-- self:setStar(entity.star)
	-- -- 攻击力
	-- self.attack:setString(tostring(entity:getInitialAttack()))
	-- -- 防御力
	-- self.defense:setString(tostring(entity:getInitialDefense()))
	-- -- 生命力
	-- self.blood:setString(tostring(entity:getInitialBlood()))

	self:OnClick("btn_ok", function()
        --qy.QYPlaySound.stopMusic()
        self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("btn_comment", function()
        --qy.QYPlaySound.stopMusic()
    	self:dismiss()
    	qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TANK_COMMENT, entity)
    	-- qy.tank.service.AchievementService:getCommentList(entity.tank_id, function()
     --   		qy.tank.view.achievement.CommentDialog.new(entity):show()
     --   	end)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})


	if not tolua.cast(self.dynamic_c,"cc.Node") then
		self.dynamic_c = cc.Layer:create()
		self.dynamic_c:setAnchorPoint(0,1)
		self.dynamic_c:setTouchEnabled(false)
	end

	self.card = qy.tank.view.common.ItemCard.new({
		["entity"] = entity,
		-- ["frame"] = entity:getCardFrame(),
		-- ["name"] = entity.name,
		["bgScale"] = 0.8
	})
	self.card:setPosition(130,-100)
	self.dynamic_c:addChild(self.card)

	local bs_info = qy.tank.view.tip.TankTipCell.new(entity)
	bs_info:setPosition(280,-215)
	self.dynamic_c:addChild(bs_info)

	local h = 220

	-- self.costIngfoBg:retain()
 --    self.costIngfoBg:getParent():removeChild(self.costIngfoBg)
 --    self.dynamic_c:addChild(self.costIngfoBg)
 --    self.costIngfoBg:setPosition(0,0)
 --    self.costIngfoBg:release()

	local bg1 = cc.Sprite:createWithSpriteFrameName("Resources/common/img/biaoti.png")
	bg1:setPosition(0,-h)
 	bg1:setAnchorPoint(0,1)
	self.dynamic_c:addChild(bg1)
	local basisTitle = cc.Label:createWithTTF(qy.TextUtil:substitute(36015),qy.res.FONT_NAME, 20.0,cc.size(0,0),1)
	basisTitle:setAnchorPoint(0.5,1)
	basisTitle:setTextColor(cc.c4b(255,255,255,255))
	basisTitle:setPosition(qy.InternationalUtil:getTankTipBasisTitleX(),35)
	basisTitle:enableOutline(cc.c4b(0,0,0,255),1)
	bg1:addChild(basisTitle)

	h = h + bg1:getContentSize().height

    self:__createList({
		{qy.TextUtil:substitute(36016) .. " ", entity.wear}, {qy.TextUtil:substitute(36017) .. " ", tostring(entity.hit).."%"}, {qy.TextUtil:substitute(36018) .. " ", (entity:getInitialCritDoubleRate() *100) .. "%"},
		{qy.TextUtil:substitute(36019) .. " ", entity.anti_wear}, {qy.TextUtil:substitute(36020) .. " ", tostring(entity.dodge).."%"}, {qy.TextUtil:substitute(36021) .. " ", (entity:getInitialCritRate()).."%"}
		}, -h)

	h = h + 70

	local bg2 = cc.Sprite:createWithSpriteFrameName("Resources/common/img/biaoti.png")
	bg2:setPosition(0, -h)
    bg2:setAnchorPoint(0,1)
   	self.dynamic_c:addChild(bg2)
    local talentTitle = cc.Label:createWithTTF(qy.TextUtil:substitute(36022),qy.res.FONT_NAME, 20.0,cc.size(0,0),1)
    talentTitle:setAnchorPoint(0.5,1)
    talentTitle:setTextColor(cc.c4b(255,255,255,255))
    talentTitle:setPosition(qy.InternationalUtil:getTankTipTalentTitleX(),35)
	talentTitle:enableOutline(cc.c4b(0,0,0,255),1)
    bg2:addChild(talentTitle)
    h = h + bg2:getContentSize().height

	local data = entity.talent.desc
	local talentArr = {}
	local talentMap = qy.tank.model.GarageModel:getTalentMap()
	for i=1,#data do
		local _data = {}
		_data[1] = talentMap[tonumber(data[i].name)] ..":  "
		_data[2] = tostring(data[i].level)
		table.insert(talentArr, _data)
	end
	self:__createList(talentArr, -h)
	h = h + math.ceil(#talentArr / 3) * 30 + 10

	-- 技能
	local bg3 = cc.Sprite:createWithSpriteFrameName("Resources/common/img/biaoti.png")
	bg3:setPosition(0,-h)
	bg3:setAnchorPoint(0,1)
	self.dynamic_c:addChild(bg3)
	local skillTitle = cc.Label:createWithTTF(qy.TextUtil:substitute(36023),qy.res.FONT_NAME, 20.0,cc.size(0,0),1)
	skillTitle:setAnchorPoint(0.5,1)
	skillTitle:setTextColor(cc.c4b(255,255,255,255))
	skillTitle:setPosition(qy.InternationalUtil:getTankTipTalentTitleX(),35)
	skillTitle:enableOutline(cc.c4b(0,0,0,255),1)
	bg3:addChild(skillTitle)
	h = h + bg3:getContentSize().height

	local commonSkillSign = cc.Sprite:createWithSpriteFrameName(entity.commonSkill.commonSign)
	commonSkillSign:setAnchorPoint(0,1)
	commonSkillSign:setPosition(0,-h)
	self.dynamic_c:addChild(commonSkillSign)
	local commonSkillDes = cc.Label:createWithTTF(entity.commonSkill.desc,qy.res.FONT_NAME_2, 20.0,cc.size(440,0),0)
	commonSkillDes:setAnchorPoint(0,1)
	commonSkillDes:setPosition(40,-h - 8)
	commonSkillDes:enableOutline(cc.c4b(0,0,0,255),1)
	self.dynamic_c:addChild(commonSkillDes)
	h = h + commonSkillDes:getContentSize().height + 10

	local compatSkillSign = cc.Sprite:createWithSpriteFrameName(entity.compatSkill.compatSign)
	compatSkillSign:setAnchorPoint(0,1)
	compatSkillSign:setPosition(0,-h)
	self.dynamic_c:addChild(compatSkillSign)
	local compatSkillDes = cc.Label:createWithTTF(entity.compatSkill.desc,qy.res.FONT_NAME_2, 20.0,cc.size(440,0),0)
	compatSkillDes:setAnchorPoint(0,1)
	compatSkillDes:setPosition(40,-h - 8)
	compatSkillDes:enableOutline(cc.c4b(0,0,0,255),1)
	self.dynamic_c:addChild(compatSkillDes)
	h = h + compatSkillDes:getContentSize().height + 20

	-- local bg6 = cc.Sprite:createWithSpriteFrameName("Resources/common/img/biaoti.png")
	-- local bg6 = ccui.ImageView:create("Resources/common/img/biaoti2.png", ccui.TextureResType.plistType)
	-- bg6:setPosition(150,-h + 2)
	-- bg6:setAnchorPoint(0,1)
	-- self.dynamic_c:addChild(bg6)
	-- local advanceCheckTitle = cc.Label:createWithTTF("进阶预览",qy.res.FONT_NAME, 20.0,cc.size(0,0),1)
	-- advanceCheckTitle:setAnchorPoint(0.5,1)
	-- advanceCheckTitle:setTextColor(cc.c4b(255,255,255,255))
	-- advanceCheckTitle:setPosition(80,33)
	-- advanceCheckTitle:enableOutline(cc.c4b(0,0,0,255),1)
	-- bg6:addChild(advanceCheckTitle)

	-- self:OnClick(bg6, function()
 --        --qy.QYPlaySound.stopMusic()
 --        print("进阶预览")
 --        -- qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(self.idx == 1 and 6 or 7)):show(true)
 --    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

	local advanceModel = qy.tank.model.AdvanceModel
	if advanceModel:testEsxit(entity) then
		local bg5 = cc.Sprite:createWithSpriteFrameName("Resources/common/img/biaoti.png")
		bg5:setPosition(0,-h)
		bg5:setAnchorPoint(0,1)
		self.dynamic_c:addChild(bg5)
		local advanceTitle = cc.Label:createWithTTF(qy.TextUtil:substitute(36024),qy.res.FONT_NAME, 20.0,cc.size(0,0),1)
		advanceTitle:setAnchorPoint(0.5,1)
		advanceTitle:setTextColor(cc.c4b(255,255,255,255))
		advanceTitle:setPosition(qy.InternationalUtil:getTankTipTalentTitleX(),35)
		advanceTitle:enableOutline(cc.c4b(0,0,0,255),1)
		bg5:addChild(advanceTitle)
		h = h + bg5:getContentSize().height + 10

	    local advanceData = qy.tank.model.AdvanceModel:atScepcailList(entity)
		local num = self:__createAdvanceList(advanceData, h)
		h = h + (table.nums(advanceData) + num) * 30
	end

	 -- 介绍
	local bg4 = cc.Sprite:createWithSpriteFrameName("Resources/common/img/biaoti.png")
	bg4:setPosition(0,-h)
	bg4:setAnchorPoint(0,1)
	self.dynamic_c:addChild(bg4)
	local desTitle = cc.Label:createWithTTF(qy.TextUtil:substitute(36025),qy.res.FONT_NAME, 20.0,cc.size(0,0),1)
	desTitle:setAnchorPoint(0.5,1)
	desTitle:setTextColor(cc.c4b(255,255,255,255))
    desTitle:setPosition(qy.InternationalUtil:getTankDesTitleX(),35)
	desTitle:enableOutline(cc.c4b(0,0,0,255),1)
    bg4:addChild(desTitle)
    h = h + bg4:getContentSize().height + 10

    local des = cc.Label:createWithTTF(entity.des or "",qy.res.FONT_NAME_2, 20.0,cc.size(480,0),0)
    des:setAnchorPoint(0,1)
    des:setTextColor(cc.c4b(255,255,255,255))
    des:setPosition(0,-h)
	des:enableOutline(cc.c4b(0,0,0,255),1)
    self.dynamic_c:addChild(des)
    h = h + des:getContentSize().height + 5

	self.dynamic_c:setContentSize(480,h)
	self.dynamic_c:setPosition(0,h)
	self.scrollView:addChild(self.dynamic_c)

	self.scrollView:setInnerContainerSize(cc.size(480,h))
	self.scrollView:setPositionY(self.scrollView:getPositionY() + 30)
end

function TankTip:__createList(data, h)
	local arr = {}
	local cell = nil
	for i = 1, #data do
		cell = qy.tank.view.tip.DescribeCell.new(data[i])
		table.insert(arr, cell)
		self.dynamic_c:addChild(cell)
	end
	qy.tank.utils.TileUtil.arrange(arr, 3, 160 ,30,cc.p(0,h))
end

-- function TankTip:__createAdvanceList(data, h)
-- 	local arr = {}
-- 	for i = 1, table.nums(data) do
-- 		data[tostring(i)].idx = i
-- 		data[tostring(i)].idx = i
-- 		data[tostring(i)].star = self.entity.star
-- 		data[tostring(i)].advance_level = self.entity.advance_level
-- 		local cell = qy.tank.view.tip.DescribeCell.new(data[tostring(i)])
-- 		table.insert(arr, cell)
-- 		cell:setPosition(0, -1 * (h + (i - 1) * 30 + 20))
-- 		self.dynamic_c:addChild(cell)
-- 	end

-- 	if data[tostring(6)].type == 9 and self.entity.is_tujian == 1 then
-- 		self:createAdvanceButton(h)
-- 	end
-- 	-- qy.tank.utils.TileUtil.arrange(arr, 1, 480 ,30,cc.p(0,h))
-- end


function TankTip:__createAdvanceList(data, h)
	local arr = {}
	local num = 0
	for i = 1, table.nums(data) do
		data[tostring(i)].idx = i
		data[tostring(i)].star = self.entity.star
		data[tostring(i)].advance_level = self.entity.advance_level

		local cell = qy.tank.view.tip.DescribeCell.new(data[tostring(i)])
		table.insert(arr, cell)

		cell:setPosition(0, -1 * (h + (i - 1 + num) * 30 + 20))

		--烦！！
		if data[tostring(i)].name and data[tostring(i)].desc then
			if string.len(data[tostring(i)].name) > 50 or string.len(data[tostring(i)].desc) > 50 then
				num = num + math.floor(string.len(data[tostring(i)].name) / 50) + math.floor(string.len(data[tostring(i)].desc) / 50)
			end
		end
		
		self.dynamic_c:addChild(cell)
	end
	-- qy.tank.utils.TileUtil.arrange(arr, 1, 480 ,30,cc.p(0,h))

	if data[tostring(6)].type == 9 and self.entity.is_tujian == 1 then
		self:createAdvanceButton(h)
	end

	return num
end

function TankTip:createAdvanceButton(h)
	local bg6 = ccui.ImageView:create("Resources/common/button/biaoti3.png", ccui.TextureResType.plistType)
	bg6:setPosition(qy.InternationalUtil:getTankBgX(), (-1 * (h + qy.InternationalUtil:getTankBgY())))
	bg6:setAnchorPoint(0,1)
	self.dynamic_c:addChild(bg6)
	local advanceCheckTitle = cc.Label:createWithTTF(qy.TextUtil:substitute(36026),qy.res.FONT_NAME, (qy.InternationalUtil:getTankTipFontSize()),cc.size(0,0),1)
	advanceCheckTitle:setAnchorPoint(0.5,1)
	advanceCheckTitle:setTextColor(cc.c4b(255,255,255,255))
	advanceCheckTitle:setPosition(qy.InternationalUtil:getTankTipAdvanceCheckTitleX(),40)
	advanceCheckTitle:enableOutline(cc.c4b(0,0,0,255),1)
	bg6:addChild(advanceCheckTitle)

	self:OnClick(bg6, function()
        --qy.QYPlaySound.stopMusic()

       	qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ADVANCE, {["entity"] = self.entity, ["isTips"] = true})
       	-- self:dismissAll()
       	self:removeSelf()
       	qy.App.runningScene.dialogStack:clean()
        -- qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(self.idx == 1 and 6 or 7)):show(true)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end

-- function TankTip:setStar(value)
--     for i = 1,6 do
--         if i <= value then
--             self["star"..i]:setVisible(true)
--         else
--             self["star"..i]:setVisible(false)
--         end
--     end
-- end

return TankTip
