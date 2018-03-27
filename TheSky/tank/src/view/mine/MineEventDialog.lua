--[[
    特殊事件 dialog
    Author: H.X.Sun
    Date: 2015-07-25
--]]
local MineEventDialog = qy.class("MineEventDialog", qy.tank.view.BaseDialog, "view/mine/MineEventDialog")

function MineEventDialog:ctor(delegate)
    MineEventDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
     -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(640,400),
        position = cc.p(0,0),
        offset = cc.p(0,0),

        -- ["onClose"] = function()
        --     self:dismiss()
        -- end
    })
    self:addChild(style, -1)

	local _awardData = delegate.award
	self.model = qy.tank.model.MineModel
	-- self:InjectView("txt")
	-- self:InjectView("titleTxt")
	self:InjectView("container")
	self:InjectView("percent")
	-- qy.tank.utils.TextUtil:autoChangeLine(self.txt , cc.size(440 , 70))
	-- self.txt:enableOutline(cc.c4b(0,0,0,255),1)

	self:OnClick("closeBtn", function (sendr)
		self:dismiss()
	end)
	-- if #_awardData == 1 t
	self.awardList = qy.AwardList.new({
        ["award"] = _awardData,
        ["cellSize"] = cc.size(160,180)
    })
    self.awardList:setPosition(-160,155)
    self.container:addChild(self.awardList)

    if #_awardData == 1 then
        local _per = self.model:getSilverCoefficient() * 100
        self.awardList.list[1]:updateTitle(self.awardList.list[1]:getTitle() .. "(+" .. _per .. "%)")
    end

    local data = self.model:getEventTitleAndInfo()

    local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(false)
    local _w = 510
    richTxt:setContentSize(_w, 70)
    richTxt:setAnchorPoint(0,0.5)
    local stringTxt
    local conStr = ""
    for i = 1, 2 do
        if i == 1 then
            stringTxt = ccui.RichElementText:create(i, cc.c3b(234,201,70), 255, data.event_name .. " :  " , qy.res.FONT_NAME_2, 24)
        else
            if delegate.type == 1 then
                conStr = data.description
            else
                conStr = data.description_1
            end
            stringTxt = ccui.RichElementText:create(i, cc.c3b(255, 255, 255), 255, conStr, qy.res.FONT_NAME_2, 24)
        end
        richTxt:pushBackElement(stringTxt)
    end
    self.container:addChild(richTxt)
    richTxt:setPosition(-_w/2, 70)
end

return MineEventDialog
