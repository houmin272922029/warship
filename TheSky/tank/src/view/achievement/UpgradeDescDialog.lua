--[[
    成就升级说明
    Author: mingming
    Date: 2015-08-21 16:28:15
]]

local UpgradeDescDialog = qy.class("UpgradeDescDialog", qy.tank.view.BaseDialog, "view/achievement/UpgradeDescDialog")

local model = qy.tank.model.AchievementModel
function UpgradeDescDialog:ctor(delegate)
    UpgradeDescDialog.super.ctor(self)

    self:setCanceledOnTouchOutside(true)
    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(441, 331),
        position = cc.p(0, 0),
        offset = cc.p(0, 0),

        -- ["onClose"] = function()
        --     self:dismiss()
        -- end
    })
    self:addChild(style)
    style:setLocalZOrder(-1)
    self.style = style

    self:InjectView("Text_1")
    self:InjectView("Text_2")
    self:InjectView("Text_3")
    self:InjectView("Text_4")
    self:InjectView("Text_5")
    self:InjectView("Text_6")
    self:InjectView("Price_num")
    self:InjectView("Price")

    self:OnClick("Btn_upgrade", function(sender)
        if model:testUpgade(self.entity) then
            if delegate and delegate.upgrade then
                delegate.upgrade(self)
            end
        else
            qy.hint:show(qy.TextUtil:substitute(1023))
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

    self:setData(delegate.entity)
end

function UpgradeDescDialog:setData(entity)
    self.entity = entity
    self:update()
end

function UpgradeDescDialog:update()
    local data1 = model:getAttributeByLevel(self.entity.id, self.entity.level)
    local data2 = model:getAttributeByLevel(self.entity.id, self.entity.level + 1)
    if data1 then
        for i = 1, 3 do
            if tonumber(data1["shuxing" .. i .. "_type"]) ~= 0 then
                if data1["shuxing" .. i .. "_type"] == 6 or data1["shuxing" .. i .. "_type"] == 7 then
                    self["Text_" .. i]:setString(model.attrTypes[tostring(data1["shuxing" .. i .. "_type"])] .. "+" .. data1["shuxing" .. i .. "_val"] / 10 .. "%")
                else
                    self["Text_" .. i]:setString(model.attrTypes[tostring(data1["shuxing" .. i .. "_type"])] .. "+" .. data1["shuxing" .. i .. "_val"])
                end
            else
                self["Text_" .. i]:setString("")
            end
        end
        -- self.Text_2:setString(model.attrTypes[tostring(data1.shuxing2_type)] .. "+" .. data1.shuxing2_val)
        -- self.Text_3:setString(model.attrTypes[tostring(data1.shuxing3_type)] .. "+" .. data1.shuxing3_val)
        self.Price_num:setString(data1.up_val)
        self.Price:setTexture(qy.tank.utils.AwardUtils.getAwardIconByType(data1.up_type))
    else
        self.Text_1:setString(qy.TextUtil:substitute(1024))
        self.Text_2:setString(qy.TextUtil:substitute(1025))
        self.Text_3:setString(qy.TextUtil:substitute(1026))
    end

    if data2 then
        for i = 1, 3 do
            if tonumber(data2["shuxing" .. i .. "_type"]) ~= 0 then
                if data2["shuxing" .. i .. "_type"] == 6 or data2["shuxing" .. i .. "_type"] == 7 then
                    self["Text_" .. i + 3]:setString(model.attrTypes[tostring(data2["shuxing" .. i .. "_type"])] .. "+" .. data2["shuxing" .. i .. "_val"] / 10 .. "%")
                else
                    self["Text_" .. i + 3]:setString(model.attrTypes[tostring(data2["shuxing" .. i .. "_type"])] .. "+" .. data2["shuxing" .. i .. "_val"])
                end
            else
                self["Text_" .. i + 3]:setString("")
            end
        end
        -- self.Text_4:setString(model.attrTypes[tostring(data2.shuxing1_type)] .. "+" .. data2.shuxing1_val)
        -- self.Text_5:setString(model.attrTypes[tostring(data2.shuxing2_type)] .. "+" .. data2.shuxing2_val)
        -- self.Text_6:setString(model.attrTypes[tostring(data2.shuxing3_type)] .. "+" .. data2.shuxing3_val)
    else
        self.Price_num:setString(0)
        if data1 then
            for i = 1, 3 do
                if tonumber(data1["shuxing" .. i .. "_type"]) ~= 0 then
                    if data1["shuxing" .. i .. "_type"] == 6 or data1["shuxing" .. i .. "_type"] == 7 then
                        self["Text_" .. i + 3]:setString(model.attrTypes[tostring(data1["shuxing" .. i .. "_type"])] .. "+" .. data1["shuxing" .. i .. "_val"] / 10 .. "%")
                    else
                        self["Text_" .. i + 3]:setString(model.attrTypes[tostring(data1["shuxing" .. i .. "_type"])] .. "+" .. data1["shuxing" .. i .. "_val"])
                    end
                else
                    self["Text_" .. i + 3]:setString("")
                end
            end
            -- self.Text_4:setString(model.attrTypes[tostring(data1.shuxing1_type)] .. "+" .. data1.shuxing1_val)
            -- self.Text_5:setString(model.attrTypes[tostring(data1.shuxing2_type)] .. "+" .. data1.shuxing2_val)
            -- self.Text_6:setString(model.attrTypes[tostring(data1.shuxing3_type)] .. "+" .. data1.shuxing3_val)
        else
            self.Text_4:setString(qy.TextUtil:substitute(1024))
            self.Text_5:setString(qy.TextUtil:substitute(1025))
            self.Text_6:setString(qy.TextUtil:substitute(1026))
            print("数据出错")
        end
    end
end

function UpgradeDescDialog:play()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_shengjichenggong",function()
        local effect = ccs.Armature:create("ui_fx_shengjichenggong")
        effect:getAnimation():playWithIndex(0,-1,0)
        -- effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        --     if movementType == ccs.MovementEventType.complete then
        --         effect:getParent():removeChild(self.effect)
        --         local dialog = require("iron_mine.src.InfoDialog").new(self, type)
        --         dialog:show()
        --     end
        -- end)
        self:addChild(effect)
        effect:setPosition(display.width / 2, display.height / 2)
    end)
end

return UpgradeDescDialog
