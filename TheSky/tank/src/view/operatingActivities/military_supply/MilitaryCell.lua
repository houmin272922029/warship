--[[
	军资整备
	Author: H.X.Sun
]]
local MilitaryCell = qy.class("MilitaryCell", qy.tank.view.BaseView, "military_supply/ui/MilitaryCell")

local ColorMapUtil = qy.tank.utils.ColorMapUtil

function MilitaryCell:ctor(param)
   	MilitaryCell.super.ctor(self)
    self:InjectView("txt_1")
    self:InjectView("txt_2")
    self:InjectView("num_1")
    self:InjectView("num_2")
    self:InjectView("num_3")
    self:InjectView("icon")
    self:InjectView("bg")
    self:InjectView("btn")
    self:InjectView("get_icon")
    self:InjectView("btn_txt")
    self:InjectView("info_node")

    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService

    self:OnClick("btn",function()
        if self.tab_idx == 2 and self.status == 0 then
            -- 充值豪礼-前往充值列表
            param.callback()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
        elseif self.tab_idx == 3 and self.status == 0 then
            -- 整备行动-前往任务
            qy.tank.utils.ModuleUtil.viewRedirectByViewId(self.data.view_id,function ()
                param.callback()
            end)
        else
            service:doMilitaryAction({
                ["type"] = self.tab_idx,
                ["id"] = self.data.id or self.data.day
            },function(data)
                qy.tank.command.AwardCommand:show(data.award)
                param.updateList()
            end)
        end
    end)
end

function MilitaryCell:render(tab_idx,cell_idx)
    self.tab_idx = tab_idx
    self.data = self.model:getMilitaryDataByIdx(tab_idx,cell_idx)
    local max_num = self.model:getMilitaryMaxNumByIdx(tab_idx,cell_idx)
    self.txt_2:setString("")
    self.num_3:setString("")
    self.icon:setVisible(false)
    self.num_1:setString(self.data.has_num or 0)
    self.num_2:setTextColor(ColorMapUtil.qualityMapColor(10))

    self:showBtn(self.data.status)
    if tab_idx == 1 then
        self.txt_1:setString(qy.TextUtil:substitute(90104)..self.data.day..qy.TextUtil:substitute(90105))
        self.num_2:setString("/ "..self.data.day)
    elseif tab_idx == 2 then
        self.txt_1:setString(qy.TextUtil:substitute(90106))
        self.txt_2:setString(self.data.diamond ..qy.TextUtil:substitute(90107))
        self.num_2:setString("/ "..max_num)
    elseif tab_idx == 3 then
        self.txt_1:setString(self.data.content)
        self.num_2:setString("/ "..max_num)
    else
        self.txt_1:setString(self.data.title)
        self.num_1:setString("")
        self.icon:setVisible(true)
        self.num_2:setString(max_num)
        self.num_2:setTextColor(ColorMapUtil.qualityMapColor())
        local remain = (self.data.num-self.data.has_num) .. "/"..self.data.num
        if self.data.shop_type == 1 then
            self.num_3:setString(qy.TextUtil:substitute(90108) .. remain)
        elseif self.data.shop_type == 2 then
            self.num_3:setString(qy.TextUtil:substitute(90109) .. remain)
        elseif self.data.shop_type == 3 then
            self.num_3:setString(qy.TextUtil:substitute(90110) .. remain)
        end
    end

    self.bg:removeAllChildren()
    self.award_list = qy.AwardList.new({
        ["award"] = self.data.award,
        ["hasName"] = true,
        ["type"] = 1,
        ["len"] = 4,
        ["cellSize"] = cc.size(117,180),
        ["itemSize"] = 2,
    })
    self.bg:addChild(self.award_list)
    self.award_list:setPosition(80,255)
end

-- 0: 未达成
-- 1：可领取
-- 2：已领取
function MilitaryCell:showBtn(_status)
    self.status = _status
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/img/common_img.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/txt/common_txt.plist")
    self.info_node:setVisible(true)
    self.get_icon:setVisible(false)
    self.btn:setBright(true)
    self.btn:setTouchEnabled(true)
    self.btn_txt:setScale(1)
    if _status == 0 then
        -- 未达成/前往/购买
        if self.tab_idx == 1 then
            -- 未达成
            self.btn:setBright(false)
            self.btn:setTouchEnabled(false)
            self.btn_txt:setSpriteFrame("Resources/common/txt/weidacheng.png")
        elseif self.tab_idx == 4 then
            -- 购买
            self.btn_txt:setSpriteFrame("Resources/common/txt/goumai.png")
        elseif self.tab_idx == 2 then
            self.btn_txt:setSpriteFrame("Resources/common/txt/quchongzhi.png")
            self.btn_txt:setScale(0.7)
        else
            -- 前往
            self.btn_txt:setSpriteFrame("Resources/common/txt/qianwang.png")
        end
    elseif _status == 1 then
        -- 可领取
        if self.tab_idx == 4 then
            -- 购买
            self.btn_txt:setSpriteFrame("Resources/common/txt/goumai.png")
        else
            -- 领取
            self.btn_txt:setSpriteFrame("Resources/common/txt/lingqu.png")
        end
    else
        -- 已领取/已购买/已售罄
        if _status == 3 then
            -- 售罄
            self.btn:setBright(false)
            self.btn:setTouchEnabled(false)
            -- cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/fight_japan/fight_japan.plist")
            -- self.get_icon:setSpriteFrame("Resources/fight_japan/09.png")
        elseif self.tab_idx == 4 then
            -- 已购买
            self.btn:setBright(false)
            self.btn:setTouchEnabled(false)
            -- self.get_icon:setSpriteFrame("Resources/common/img/ygmc.png")
        else
            -- 已领取
            self.info_node:setVisible(false)
            self.get_icon:setVisible(true)
            self.get_icon:setSpriteFrame("Resources/common/img/D_12.png")
        end
    end
end

return MilitaryCell
