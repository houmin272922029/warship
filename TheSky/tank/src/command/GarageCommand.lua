--[[
	车库通讯类
	Author: Aaron Wei
	Date: 2015-04-07 20:42:56
]]

local GarageCommand = qy.class("GarageCommand", qy.tank.command.BaseCommand)

function GarageCommand:showGarageView()
	-- local service = qy.tank.service.GarageService
 --    service:getMainData(nil,function(data)
        if self.controller == nil or tolua.cast(self.controller,"cc.Node") == nil then
            self.controller = qy.tank.controller.GarageController.new()
        end
    	-- service = nil
    	self:startController(self.controller)
        qy.GuideManager:nextTiggerGuide()
    -- end)
end

--[[
    type:1所有战车，2已上阵的战车，3未上阵的战车 4:远征没上阵 5未上阵的战车加所有战车碎片
    update:true刷新数据，false不刷新数据
]]
function GarageCommand:showTankListDialog(type,update,callback)
    function showTankList(type)
        self.tankList = qy.tank.view.garage.TankSelectDialog.new({
            ["type"] = type,
            ["choose"] = function(uid)
                if callback then
                    callback(uid)
                end
            end
        })
        self.tankList:show(true,true)
    end

    if update then
        local service = qy.tank.service.GarageService
        service:getMainData(nil,function(data)
            service = nil
            showTankList(type)
        end)
    else
        showTankList(type)
    end
end

function GarageCommand:showAllTankListDialog(update,callback)
    self:showTankListDialog(1,update,callback)
end

function GarageCommand:showSelectedTankListDialog(upadte,callback)
    self:showTankListDialog(2,update,callback)
end

function GarageCommand:showUnselectedTankListDialog(update,callback)
    self:showTankListDialog(3,update,callback)
end

function GarageCommand:showFightJapanUnselectedTankListDialog(update,callback)
    self:showTankListDialog(4,update,callback)
end

function GarageCommand:showUnselectedAndFragmentTankListDialog(update,callback)
    self:showTankListDialog(5,update,callback)
end

function GarageCommand:hideTankListDialog()
    if tolua.cast(self.tankList,"cc.Node") then
        self.tankList:dismiss()
    end
end

function GarageCommand:showFormationDialog(data)
    -- local formation = qy.tank.view.garage.EmbattleDialog.new({
    --     ["adjust"] = function(uid)
    --         if callback then
    --             callback()
    --         end
    --     end
    -- })
    local _data = nil
    if data then
        _data = data
    else
        _data = qy.tank.model.GarageModel.formation
    end
    local formation = qy.tank.view.garage.EmbattleDialog.new(_data)
    formation:show(true,true)
end
--鼠式坦克晋升
function GarageCommand:showPromotionDialog(id,ddate,garageself)
    local service = qy.tank.service.GarageService
    service:Promotion(id,function( )
        local formation = qy.tank.view.garage.PromotionDialog.new(id,ddate,garageself):show()        
    end)
    
   --require("view.garage.PromotionDialog").new():show() 
   --self.controller:addChild(formation)
end

function GarageCommand:getMainData(callback)
	local service = qy.tank.service.GarageService
    service:getMainData(nil,function(data)
    	if callback then
    		callback(data)
    	end
    end)
end

return GarageCommand
