--[[
    抽卡控制类（军火商店）
]]
local ResolveController = qy.class("ResolveController", qy.tank.controller.BaseController)

local model = qy.tank.model.ResolveModel
function ResolveController:ctor(data)
    ResolveController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    local delegate = {
        ["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["selectItem"] = function(entity, idx, sender)
            if idx == 1 then
                -- local status = model:testResolve(entity)

                -- if status == 1 then
                --     -- sender:changeStatus()
                -- elseif status == 2 then
                --     -- self:tips()
                --     qy.hint:show(qy.TextUtil:substitute(80010))
                -- elseif status == 3 then
                --     -- self:tips()
                --     qy.hint:show(qy.TextUtil:substitute(80010))
                -- elseif status == 4 then
                --     self:tips()
                -- end
                model:select(entity)
            elseif idx == 2 then
                model:select(entity)
            end
            sender:changeStatus()
        end,
        ["showTips"] = function(idx, node)
            qy.tank.view.resolve.RewardDialog.new({
                ["data"] = model:getRewardData(idx),
                ["resolve"] = function(callback)
                    qy.tank.service.ResolveService:resolve(idx, function(data)
                        model:update()
                        node:update()
                        node:reloadData()
                        callback()
                        if data then
                            qy.tank.command.AwardCommand:add(data.award)
                            qy.tank.command.AwardCommand:show(data.award)
                        end
                        if idx == 1 then
                            --红点需要，纪录分解状态
                            qy.tank.model.RedDotModel:setResolveStatus(true)
                        end
                    end)
                end
            }):show()
            -- qy.hint:show("确认要分解吗？")
        end,
        ["selectAll"] = function(idx, callback)
            model:selectAll(idx)
            callback()
        end,
        ["selectAll1"] = function(idx,list, callback)
            model:selectAll1(idx,list)
            callback()
        end
    }

    model:init(function()
        self.viewStack:push(qy.tank.view.resolve.ResolveView.new(delegate))
    end)
end

function ResolveController:tips()
    local fontName = qy.language == "tw" and "res/Resources/font/ttf/black_body_2.TTF" or "Arial"
    qy.alert:show(
        {qy.TextUtil:substitute(9004) ,{255,255,255} } ,
        {{id=1,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(80014),font=fontName,size=20}} ,
        cc.size(533 , 250) ,{{qy.TextUtil:substitute(4012) , 5} } ,
        function(flag)
            if qy.TextUtil:substitute(4012) == flag then
            
            end
    end ,"")
end

return ResolveController
