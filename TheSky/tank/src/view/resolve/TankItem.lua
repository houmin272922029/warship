--[[
--图鉴
--Author: mingming
--Date:
]]

local TankItem = qy.class("TankItem", qy.tank.view.BaseView, "view/resolve/TankItem")

function TankItem:ctor(delegate)
    TankItem.super.ctor(self)

    self:InjectView("Name")
    self:InjectView("Level")
    self:InjectView("star1")
    self:InjectView("star2")
    self:InjectView("star3")
    self:InjectView("star4")
    self:InjectView("star5")
    self:InjectView("star6")
    self:InjectView("star7")
    self:InjectView("Select")
    self:InjectView("Image_1")
    self:InjectView("Btn_select")
    self:InjectView("reform_num")
    self:InjectView("reform_bg")
    self:InjectView("levelTitle2")
    self:InjectView("reformlevel")
    self:InjectView("cleartext")

    self:InjectCustomView("Tank", qy.tank.view.common.TankItem)

    self:OnClickForBuilding("Btn_select", function()
        --qy.QYPlaySound.stopMusic()
        -- self:changeStatus()
        delegate.selected(self.entity, self)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    for i = 1, 7 do
		self["star" .. i]:setVisible(false)
	end

    self.Icon = qy.tank.view.common.ItemIcon.new()
    self.Icon:setPosition(150, 77)
    self:addChild(self.Icon)

    self.selected = false
    self.Select:setVisible(false)
    -- self.Image_1:setSwallowTouches(false)
    self.Btn_select:setSwallowTouches(false)
    self.Select:setSwallowTouches(false)
end

function TankItem:setData(data, ttype, selected)
    if qy.InternationalUtil:hasTankReform() then
        self.reform_bg:setVisible(false)
    end
    self.selected = selected
    self.Select:setVisible(self.selected)

    self.Tank:setVisible(ttype == 1)
    self.Icon:setVisible(ttype == 2)
    self.levelTitle2:setVisible(ttype == 2)
    self.reformlevel:setVisible(ttype == 2)
    self.cleartext:setVisible(ttype == 2)
    self.Level:setString("Lv." .. data.level)

    self.entity = data

    for i = 1, 7 do
        self["star" .. i]:setVisible(false)
    end

    if ttype == 1 then
    	local color = qy.tank.utils.ColorMapUtil.qualityMapColor(tostring(data.quality))
        local name = data.advance_level > 0 and data.name .. "   +" .. data.advance_level or data.name
        self.Name:setString(name)
    	self.Level:setString("Lv." .. data.level)
    	self.Name:setTextColor(color)
    	self.Level:setTextColor(color)

    	for i = 1, data.star do
    		self["star" .. i]:setVisible(true)
    	end

        self.Tank:update({
                ["callback"] = function()
                    qy.tank.view.tip.TankTip2.new(data):show()
                end,
                ["scale"] = 1,
                ["entity"] = data,
                ["namePos"] = 2
            })

        if qy.InternationalUtil:hasTankReform() then
    		if data.reform_stage == 0 then
    			self.reform_bg:setVisible(false)
    		else
    			self.reform_bg:setVisible(true)
                self.reform_num:setString(data.reform_stage)
    		end
        end
    else
        local color = qy.tank.utils.ColorMapUtil.qualityMapColor(tostring(data:getQuality()))
        self.Name:setTextColor(color)
        self.Level:setTextColor(color)
        data.type = 12
        local param = qy.tank.view.common.AwardItem.getItemData(data)
        param.namePos = 2
        self.Name:setString(data:getName())
        self.Icon:setData(param)
        self.Icon:showTitle(false)
        self.reformlevel:setString(data.reform_level)
        if data.addition_bad == 1 then
            self.cleartext:setString("(已损坏)")
        else
            if data:hasClear() then
                self.cleartext:setString("(已洗练)")
            else
                self.cleartext:setString("")
            end
        end
    end
end

function TankItem:changeStatus()
    self.selected = not self.selected
    self.Select:setVisible(self.selected)
end

return TankItem
