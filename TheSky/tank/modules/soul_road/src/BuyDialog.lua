local BuyDialog = qy.class("BuyDialog", qy.tank.view.BaseDialog, "soul_road.ui.BuyDialog")


local model = qy.tank.model.SoulRoadModel
local service = qy.tank.service.SoulRoadService
function BuyDialog:ctor(delegate, idx, node)
   	BuyDialog.super.ctor(self)

   	self:InjectView("Num")
   	self:InjectView("Times")
   	-- self:InjectView("Done")
   	-- self:InjectView("Color")
   	-- self:InjectView("Name")
   	-- self:InjectView("Light")
   	-- self:InjectView("Block")
   	-- self:InjectView("star1_6")
    -- self:InjectView("star1_7")
   	-- self:InjectView("Resource1")
   	-- self:InjectView("Resource2")
   	-- self:InjectView("IsMy")
   	-- self:InjectView("Name")
   	-- self:InjectView("NameBg")
   	-- self:InjectView("Btn_view")

    self:OnClick("Btn_close", function()
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick("Btn_buy", function()
        service:buy(function(data)
            -- self.tankViewList:reloadData()
            -- self:update(model:getCurrentIdx(self.idx))
            -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
            self:update()
            delegate:update()
        end)
    end,{["isScale"] = false})

    -- self.idx = idx

    -- self:initCar()
    -- self:setData(delegate)
    self:update()
end

function BuyDialog:update()
    self.Times:setString(qy.TextUtil:substitute(67008) .. model.left_free_times + model.left_buy_times .. qy.TextUtil:substitute(67009))
    self.Num:setString(model:getFreeNum())
end

return BuyDialog
