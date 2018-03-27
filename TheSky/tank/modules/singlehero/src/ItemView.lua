local ItemView = qy.class("ItemView", qy.tank.view.BaseView, "singlehero.ui.ItemView")

local model = qy.tank.model.SingleHeroModel
local service = qy.tank.service.SingleHeroService
function ItemView:ctor(delegate, idx)
   	ItemView.super.ctor(self)

    -- local style = qy.tank.view.style.ViewStyle1.new({
    --     titleUrl = "Resources/activity/title_legion_escort.png", 
    --     showHome = false,
    --     ["onExit"] = function()
    --         delegate.viewStack:pop()
    --     end
    -- })
    -- self:addChild(style)

   	self:InjectView("Image_1")
   	self:InjectView("Id")
    self:InjectView("Name")
    self:InjectView("Level")
    self:InjectView("First_fight")
    self:InjectView("Num")
    self:InjectView("CheckBox_1")
    self:InjectView("CheckBox_2")
    self:InjectView("Btn_list")
    self:InjectView("Btn_attack")
    self:InjectView("Text_1_2")
    self:InjectView("Lose")
    self:InjectView("autoFightBtn")

    
    -- self.list = {}

    self:OnClick("CheckBox_1", function()
        self.CheckBox_2:setSelected(false)
    end,{["isScale"] = false})

    self:OnClick("CheckBox_2", function()
        self.CheckBox_1:setSelected(false)
    end,{["isScale"] = false})

    self:OnClick("Btn_list", function()
        service:getList(self.entity.checkpoint_id, function()
            local dialog = require("singlehero.src.HowToPlayDialog").new(self.entity)
            dialog:show()
        end)
    end,{["isScale"] = false})

    self:OnClick("Btn_attack", function()
        if tonumber(self.entity.checkpoint_id) > tonumber(model.current) then
            qy.hint:show(qy.TextUtil:substitute(62002))
        else
            local multiple = self.CheckBox_1:isSelected() and 10 or self.CheckBox_2:isSelected() and 100 or 1
            service:attack(self.entity.checkpoint_id, multiple, function(data)
                qy.tank.manager.ScenesManager:pushBattleScene()
                -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
                -- delegate:update()
            end)
        end
    end,{["isScale"] = false})


    self:OnClick(self.autoFightBtn, function()
        if tonumber(self.entity.checkpoint_id) > tonumber(model.complete) then
            qy.hint:show(qy.TextUtil:substitute(90290))
        else
            if self.CheckBox_1:isSelected() or self.CheckBox_2:isSelected() then
                qy.hint:show(qy.TextUtil:substitute(90289))
            else
                service:sweep(self.entity.checkpoint_id,function(data)
                    require("singlehero.src.AutoFightDialog").new(data):show(self)
                    qy.Event.dispatch("SINGLE_HERO")
                end) 
            end
        end
    end,{["isScale"] = false})
end

function ItemView:setData(data)
    self.Name:setString(data.name)
    self.Level:setString("Lv." .. data.level)
    
    self.First_fight:setVisible(tonumber(data.checkpoint_id) >= tonumber(model.current) and tonumber(model.complete) < tonumber(model.current))
    self.Lose:setVisible(tonumber(data.checkpoint_id) <= tonumber(model.complete))
    self.Id:setString(qy.TextUtil:substitute(62003) .. data.checkpoint_id)
    local num = self.First_fight:isVisible() and data.first_num or data.num
    self.Num:setString(num)

    local info = self.First_fight:isVisible() and qy.TextUtil:substitute(62004) or qy.TextUtil:substitute(62005)
    self.Text_1_2:setString(info)

    local color = data.checkpoint_id <= model.current and cc.c3b(255, 255, 255) or cc.c3b(150, 150, 150)

    self.Image_1:setColor(color)

    self.Btn_list:setBright(data.checkpoint_id <= model.current)
    self.Btn_attack:setBright(data.checkpoint_id <= model.current)
    self.autoFightBtn:setBright(data.checkpoint_id <= model.current)

    self.CheckBox_2:setVisible(not self.First_fight:isVisible())
    self.CheckBox_1:setVisible(not self.First_fight:isVisible())

    self.entity = data

    -- self.Name:setString(data.name)
end

return ItemView
