local BuyDialog = qy.class("BuyDialog", qy.tank.view.BaseDialog, "servicewar.ui.BuyDialog")


local model = qy.tank.model.ServiceWarModel
local service = qy.tank.service.ServiceWarService
function BuyDialog:ctor(delegate)
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

    self:update()

    self:OnClick("Btn_buy", function()
        service:BuyBattleNum(100, function(data)
            -- self.tankViewList:reloadData()
            -- self:update(model:getCurrentIdx(self.idx))
            -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
            model.userinfo.remaining = data.remaining
            self:update()
            delegate:update()
            -- qy.Event.dispatch("SINGLE_HERO")
        end)
    end,{["isScale"] = false})

    -- self.idx = idx

    -- self:initCar()
    -- self:setData(delegate)
    
end

function BuyDialog:update()
    self.Times:setString(qy.TextUtil:substitute(90001) .. model.userinfo.remaining .. qy.TextUtil:substitute(59007))
    self.Num:setString(model.consume)
end

return BuyDialog
