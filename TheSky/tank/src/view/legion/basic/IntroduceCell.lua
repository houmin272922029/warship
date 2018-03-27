--[[
	军团介绍
	Author: H.X.Sun
]]

local IntroduceCell = qy.class("IntroduceCell", qy.tank.view.BaseView, "legion/ui/basic/IntroduceCell")

function IntroduceCell:ctor(delegate)
    IntroduceCell.super.ctor(self)
    self:InjectView("name")
    self:InjectView("num")
    self:InjectView("level")
    self:InjectView("bar")
    self:InjectView("bar_num")
    self:InjectView("tip_txt")
    self:InjectView("announce")
    self:InjectView("changgeBt")

    self.model = qy.tank.model.LegionModel
    self.isModify = delegate and delegate.isModify or false
    self:OnClick("modify_btn", function()
        if delegate and delegate.isModify then
            if self.model:getCommanderEntity():canModify() then
                qy.tank.view.legion.basic.TipsDialog.new({
                    ["type"] = self.model.TIPS_MOD,
                    ["height"] = 100,
                    ["callback"] = function()
                        self:render(self.entity)
                    end,
                }):show(true)
            end
        end
    end)
    self:OnClick("changgeBt", function()
        qy.tank.view.legion.basic.ChangeName.new({
            ["callback"] = function ( name )
                self.entity.name = name
                self.name:setString(self.entity.name)
                delegate.callback()
            end
            }):show()
    end)

end

function IntroduceCell:render(entity)
    self.entity = entity
    if entity then
        local user_score = qy.tank.model.LegionModel:getCommanderEntity().user_score
        self.changgeBt:setVisible((user_score == 1 or user_score == 2 or user_score == 3) and self.isModify == true)
        self.name:setString(entity.name)
        self.num:setString(entity:getCountDesc())
        self.num:setTextColor(entity:getCountColor())
        self.bar:setPercent(entity:getExpPerNum())
        self.bar_num:setString(entity:getExpPerDesc())
        local str = entity.notice
        self.announce:setString(entity.notice)
        self.level:setString("Lv."..entity.level)

        if self.isModify and self.model:getCommanderEntity():canModify() then
            self.tip_txt:setVisible(true)
        else
            self.tip_txt:setVisible(false)
        end

    end
end

return IntroduceCell
