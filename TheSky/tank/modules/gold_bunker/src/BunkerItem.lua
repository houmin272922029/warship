local BunkerItem = qy.tank.module.BaseUI.class("BunkerItem", "gold_bunker.ui.BunkerItem")

local Model = require("gold_bunker.src.Model")

function BunkerItem:ctor()
    BunkerItem.super.ctor(self)

    self.ui.Backgroup:setPositionX(display.cx)

    local levelLabel = ccui.TextAtlas:create("300", "gold_bunker/fx/level_number.png", 26, 25, '0')
    levelLabel:setPosition(165.50, -2)
    levelLabel:addTo(self.ui.Backgroup)

    self.ui.level = levelLabel
end

function BunkerItem:setLevel(idx, level_count)
    local zero = idx == 0
    if zero or idx > level_count then
        self:setNull(zero)
    else
        local levelData = Model:getLevels()[idx]
        self.ui.tank:setSpriteFrame(levelData.tank_icon)
        self.ui.level:setString(levelData.checkpoint_id)
        self.ui.name:setString(levelData.name)
        self.ui.shadow:setVisible(true)
        self.ui.level:setVisible(true)
        self.ui.notopen:setVisible(false)
    end

    -- BOSS
    self:setBoss(idx)
end

function BunkerItem:setNull(zero)
    self.ui.shadow:setVisible(false)
    if zero then
        self.ui.level:setString("0")
    end

    self.ui.level:setVisible(zero)
    self.ui.notopen:setVisible(not zero)
end

function BunkerItem:setBoss(idx)
    if idx ~= 0 and idx % 10 == 0 then
        if not self.ui.fx then
            self.ui.fx = ccs.Armature:create("ui_fx_dboos")
            self.ui.fx:setPosition(223, 0)
            self.ui.fx:setScale(1.5)
            self.ui.fx:addTo(self.ui.shadow)
        end
        self.ui.fx:getAnimation():playWithIndex(0)
    elseif self.ui.fx then
        self.ui.fx:removeSelf()
        self.ui.fx = nil
    end
end

local Cell = class("Cell", cc.TableViewCell)

function Cell:ctor()
    self._item = BunkerItem.new()
    self._item:addTo(self)
end

function Cell:setLevel(idx, level_count)
    self:setLocalZOrder(0 - idx)
    self._item:setLevel(idx, level_count)
    return self
end

return Cell
