--[[--
    军团界面的跳转
--]]

local LegionCommand = qy.class("LegionCommand", qy.tank.command.BaseCommand)

local moduleType = qy.tank.view.type.ModuleType
local LegionModel = qy.tank.model.LegionModel
local LeMobilizeModel = qy.tank.model.LeMobilizeModel
--[[--
    根据模块type界面跳转
    @param #string sType 模块type
    @extendData  扩展数据
--]]
function LegionCommand:viewRedirectByModuleType(sType, extendData)
    if moduleType.LE_MOB == sType then
        --军团动员
        local open_level = LeMobilizeModel:getMobiOpenLevel()
        local now_level = LegionModel:getHisLegion().level
        if now_level >= open_level then
            qy.tank.service.LeMobilizeService:get(function()
                self:startController(qy.tank.controller.LeMobilizeController.new())
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(70031, open_level))
        end
    elseif moduleType.LE_CLUB == sType then
        self:startController(qy.tank.controller.LeClubController.new())
    elseif moduleType.LE_WAR == sType then
        if qy.tank.model.LegionWarModel:isClosedWar() then
            qy.hint:show(qy.TextUtil:substitute(70033))
            return
        end

        qy.tank.model.LegionWarModel:init()
        qy.tank.service.LegionWarService:get(true,function()
            qy.tank.module.Helper:register("legion_war")
            qy.tank.module.Helper:start("legion_war",nil,function()
                self:startController(qy.tank.controller.LegionWarController.new(extendData))
            end)
            -- qy.tank.service.LegionWarService:groupWar(function()end)
        end)
    elseif moduleType.ATTACK_BERLIN == sType then 
        qy.tank.service.AttackBerlinService:get(function()
            qy.tank.module.Helper:register("attack_berlin")
            qy.tank.module.Helper:start("attack_berlin",self)
        end)
    elseif sType == "AttackBerlin1" then
            qy.tank.module.Helper:register("attack_berlin")
            qy.tank.module.Helper:start("attack_berlin",self)
    elseif moduleType.WAR_GROUP == sType then
        --群战(军团战 还有以后可能的 跨服战)
        -- qy.tank.model.WarGroupModel:initForLocal()
        
        if extendData ~= nil and extendData.results_list then  --fq 2016年08月25日20:03:23
            qy.tank.model.WarGroupModel:initWarData(extendData)
            qy.tank.module.Helper:register("war_group")
            qy.tank.module.Helper:start("war_group",nil,function()
                self:startController(qy.tank.controller.WarGroupController.new(extendData))
            end)
            return
        elseif extendData == nil or extendData.war_key == nil then
            qy.hint:show(qy.TextUtil:substitute(70034))
            return        
        end

        qy.tank.service.WarGroupService:groupWar(extendData.war_key,function()
            qy.tank.module.Helper:register("war_group")
            qy.tank.module.Helper:start("war_group",nil,function()
                self:startController(qy.tank.controller.WarGroupController.new(extendData))
            end)
        end)
    elseif "WAR_GROUP1" == sType then
        qy.tank.model.WarGroupModel:initWarData(extendData)
            qy.tank.module.Helper:register("war_group")
            qy.tank.module.Helper:start("war_group",nil,function()
                self:startController(qy.tank.controller.WarGroupController.new(extendData))
        end)
    end
end

return LegionCommand
