local RecordItemView = qy.class("RecordItemView", qy.tank.view.BaseView, "inter_service_escort.ui.RecordItemView2")

local _MineService = qy.tank.service.MineService
local model = qy.tank.model.InterServiceEscortModel
function RecordItemView:ctor(delegate)
   	RecordItemView.super.ctor(self)

   	self:InjectView("BG")
   	self:InjectView("Img")

   	-- self:OnClick("BG", function()
    --     print("我去")
    --     -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ADVANCE, {["entity"] = self.entity, ["isTips"] = true})
    -- end,{["isScale"] = false})
end

function RecordItemView:setData(idx, data)
    if idx % 2 == 1 then
        self.BG:setVisible(false)
    else
        self.BG:setVisible(true)
    end

    if self.richText then
        self.richText:removeSelf()
    end

    self.richText = ccui.RichText:create()

    local color = cc.c3b(203, 188, 153)

    local time = os.date("%Y.%m.%d %H:%M", data.time)

    self.richText:pushBackElement(self:makeText(time, cc.c3b(255, 255, 255)))
    if data.type == 1 then
        local info1 = self:makeText(qy.TextUtil:substitute(44021) , color)
        self.richText:pushBackElement(info1)    
    elseif data.type == 2 then
        local params = {
            ["text"] = "【"..data.server.."】"..data.plunder_nickname,
            ["callback"] = function()
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, data.plunder_kid)
            end
        }

        local plunder_nickname = qy.tank.widget.RichUnderlineText.new(params):getRichElement()
        self.richText:pushBackElement(plunder_nickname)
        -- local plunder_nickname = self:makeText(" " .. data.plunder_nickname, cc.c3b(216, 197, 157))
        if data.is_win == 1 then            
            local info1 = self:makeText(qy.TextUtil:substitute(90317), color)
            self.richText:pushBackElement(info1)

            if data.is_over == 1 then
                local txt = self:makeText(qy.TextUtil:substitute(90318), color)
                self.richText:pushBackElement(txt)
            end

            if data.combat_id and data.combat_id > 0 then
                local params = {
                    ["text"] = qy.TextUtil:substitute(69016),
                    ["type"] = 2,
                    ["color"] = cc.c3b(235, 54, 27),
                    ["callback"] = function()
                        _MineService:showCombat(data.combat_id, function (data)
                            qy.tank.manager.ScenesManager:pushBattleScene()
                        end)
                    end
                }

                local fight1 = qy.tank.widget.RichUnderlineText.new(params):getRichElement()
                self.richText:pushBackElement(fight1)
            end     
        else            
            local info1 = self:makeText(qy.TextUtil:substitute(44037), color)
            self.richText:pushBackElement(info1)

            if data.combat_id and data.combat_id > 0 then
                local params = {
                    ["text"] = qy.TextUtil:substitute(69016),
                    ["type"] = 2,
                    ["color"] = cc.c3b(235, 54, 27),
                    ["callback"] = function()
                        _MineService:showCombat(data.combat_id, function (data)
                            qy.tank.manager.ScenesManager:pushBattleScene()
                        end)
                    end
                }

                local fight1 = qy.tank.widget.RichUnderlineText.new(params):getRichElement()
                self.richText:pushBackElement(fight1)
            end    
        end    
    elseif data.type == 3 then
        if data.is_win == 1 then            
            local info1 = self:makeText(qy.TextUtil:substitute(44022), color)
            local params = {
                ["text"] = "【"..data.server.."】"..data.robed_nickname,
                ["callback"] = function()
                    qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, data.robed_kid)
                end
            }

            local name1 = qy.tank.widget.RichUnderlineText.new(params):getRichElement()
            self.name1 = name1
            -- local name1 = self:makeText(data.nickname1, cc.c3b(216, 197, 157))
            local info2 = self:makeText("，" .. qy.TextUtil:substitute(44024) .. model:atRescoursById(data.goods_id).rob_award[1].num .. qy.TextUtil:substitute(44025), color)
            self.richText:pushBackElement(info1)
            self.richText:pushBackElement(name1)
            self.richText:pushBackElement(info2)

            if data.combat_id and data.combat_id > 0 then
                local params = {
                    ["text"] = qy.TextUtil:substitute(69016),
                    ["type"] = 2,
                    ["color"] = cc.c3b(235, 54, 27),
                    ["callback"] = function()
                        _MineService:showCombat(data.combat_id, function (data)
                            qy.tank.manager.ScenesManager:pushBattleScene()
                        end)
                    end
                }

                local fight1 = qy.tank.widget.RichUnderlineText.new(params):getRichElement()
                self.richText:pushBackElement(fight1)
            end
        else            
            local info1 = self:makeText(qy.TextUtil:substitute(44028), color)
            local params = {
                ["text"] = "【"..data.server.."】"..data.robed_nickname,
                ["callback"] = function()
                    qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, data.robed_kid)
                end
            }

            local name1 = qy.tank.widget.RichUnderlineText.new(params):getRichElement()
            -- local name1 = self:makeText(data.nickname1, cc.c3b(216, 197, 157))
            local info2 = self:makeText(qy.TextUtil:substitute(44029) .."。", color)

            self.richText:pushBackElement(info1)
            self.richText:pushBackElement(name1)
            self.richText:pushBackElement(info2)

            if data.combat_id and data.combat_id > 0 then
                local params = {
                    ["text"] = qy.TextUtil:substitute(69016),
                    ["type"] = 2,
                    ["color"] = cc.c3b(235, 54, 27),
                    ["callback"] = function()
                        _MineService:showCombat(data.combat_id, function (data)
                            qy.tank.manager.ScenesManager:pushBattleScene()
                        end)
                    end
                }

                local fight1 = qy.tank.widget.RichUnderlineText.new(params):getRichElement()
                self.richText:pushBackElement(fight1)
            end
        end
    end

    self.richText:ignoreContentAdaptWithSize(false)
    self.richText:setContentSize(cc.size(800, 70))

    local idx = (data.type == 1 or data.type == 4) and 1 or 2
    self.Img:setSpriteFrame("inter_service_escort/res/shouhuo" .. idx .. ".png")

    -- local params = {
    --     ["text"] = "名字",
    -- }

    -- local underLineText = qy.tank.widget.RichUnderlineText.new(params):getRichElement()
    -- self.richText:pushBackElement(underLineText)

    self.richText:setPosition(550, 50)
    self:addChild(self.richText)
end

function RecordItemView:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME, 22)
end

return RecordItemView
