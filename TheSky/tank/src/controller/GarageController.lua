--[[
	战车系统
	Author: Aaron Wei
	Date: 2015-03-18 15:37:32
]]

local GarageController = qy.class("GarageController", qy.tank.controller.BaseController)

function GarageController:ctor(delegate)
    GarageController.super.ctor(self)

	print("GarageController:ctor")

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.tag = "GarageController"
    self.model = qy.tank.model.GarageModel

    self.view = qy.tank.view.garage.GarageView.new({
        ["showTankList"] = function(idx)
            -- command用法
            -- qy.tank.command.GarageCommand:showUnselectedTankListDialog(false,function(uid)
            --     local service = qy.tank.service.GarageService
            --     local param = {}
            --     for i=1,#self.model.formation do
            --         if self.model.formation[i] == 0 then
            --             param["p_"..i] = self.model.formation[i]
            --         elseif self.model.formation[i] ~= -1 then
            --             param["p_"..i] = self.model.formation[i].unique_id
            --         end
            --     end
            --     param["p_"..self.view.selectIdx] = uid

            --     service:adjust(param,function()
            --         self.view:update()
            --         qy.tank.command.GarageCommand:hideTankListDialog()
            --     end)
            -- end)

            -- qy.tank.command.GarageCommand:showUnselectedTankListDialog(false,function(uid)
            --     local service = qy.tank.service.GarageService
            --     service:lineup(1,1,"p_"..idx,uid,function()
            --         qy.Event.dispatch(qy.Event.LINEUP_SUCCESS)
            --         qy.tank.command.GarageCommand:hideTankListDialog()
            --     end)
            -- end)

            qy.tank.command.GarageCommand:showUnselectedAndFragmentTankListDialog(false,function(uid)
                local service = qy.tank.service.GarageService
                service:lineup(1,1,"p_"..idx,uid,function()
                    qy.Event.dispatch(qy.Event.LINEUP_SUCCESS)
                    qy.tank.command.GarageCommand:hideTankListDialog()
                end)
            end)


            -- 普通用法
            -- self.tankList = qy.tank.view.garage.TankSelectDialog.new({
            --     ["type"] = 3,
            --     ["choose"] = function(uid)
            --         local service = qy.tank.service.GarageService
            --         local param = {}
            --         for i=1,#self.model.formation do
            --             if self.model.formation[i] == 0 then
            --                 param["p_"..i] = self.model.formation[i]
            --             elseif self.model.formation[i] ~= -1 then
            --                 param["p_"..i] = self.model.formation[i].unique_id
            --             end
            --         end
            --         param["p_"..self.view.selectIdx] = uid

            --         service:adjust(param,function()
            --             self.view:update()
            --             self.tankList:dismiss()
            --         end)
            --     end
            -- })
            -- self.tankList:show(true,true)
        end,

        ["showFormation"] = function()
            qy.tank.command.GarageCommand:showFormationDialog(nil)
        end,
        --鼠式坦克晋升
        ["showPromotion"] = function(data,garageself)
            qy.tank.command.GarageCommand:showPromotionDialog(data,self,garageself)
        end,

        ["dismiss"] = function()
            --self.viewStack:pop()
            --self.viewStack:removeFrom(self)
            self:finish()
        end,

        ["enterTraining"] = function()
            local service = qy.tank.service.TrainingService
            service:getTrainInfo(nil,function(data)
                qy.tank.view.training.TrainingView.new( {
                        ["updateUserData"] = function()
                        end
                }):show(true)
            end)
        end,

        ["clickEquip"] = function(view, sType, nSelectTankUid)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EQUIP,{
                ["type"] = sType,
                ["selectTankUid"] = nSelectTankUid,
            })
                -- if qy.tank.model.EquipModel:getEquipListLength(sType) > 0 then
                --     qy.tank.view.equip.EquipDialog.new( {
                --         type = sType,
                --         selectTankUid = nSelectTankUid,
                --         ["updateUserData"] = function ()
                --             view:updateEquipView()
                --         end
                --     }):show(true)
                -- else
                --     qy.hint:show("你当前没有任何装备")
                -- end
        end,
        ["showAdvance"] = function(param)
            if qy.tank.model.UserInfoModel.userInfoEntity.level >= 40 then
                self:showAdvance(param)
            else
                qy.hint:show(qy.TextUtil:substitute(40049))
            end
        end
    })
    self.viewStack:push(self.view)
    -- self.view:addTo(self)
end

-- 开始进阶
function GarageController:showAdvance(delegate)
    self.entity = delegate.entity

    qy.tank.module.Helper:register("advance")
    qy.tank.module.Helper:start("advance", self)
end

function GarageController:onCleanup()
    -- display.removeSpriteFrames("Resources/plist/ui_login.plist", "Resources/plist/ui_login.png")
    -- display.removeImage("shine")
    -- display.removeImage("play_enable")
    -- display.removeImage("play_background")
end


return GarageController
