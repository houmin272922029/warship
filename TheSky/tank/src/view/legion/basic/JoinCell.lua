--[[
	加入cell
	Author: H.X.Sun
]]

local JoinCell = qy.class("JoinCell", qy.tank.view.BaseView, "legion/ui/basic/JoinCell")

function JoinCell:ctor(delegate)
    JoinCell.super.ctor(self)
    self:InjectView("light")
    self:InjectView("btn_txt")
    self:InjectView("rank_pic")
    self:InjectView("rank_txt")
    self:InjectView("name")
    self:InjectView("level")
    self:InjectView("num")
    self:InjectView("leader")
    self:InjectView("full_icon")
    self:InjectView("join_btn")
    self:InjectView("bg_cell")

    self.delegate = delegate

    self.model = qy.tank.model.LegionModel
    if delegate.type == self.model.IS_OPERATE then
        self.rank_txt:setPosition(30, 67)
        self.name:setPosition(197, 84)
        self.level:setPosition(197,50)
        self.num:setPosition(326, 67)
        self.leader:setPosition(460,67)
    else
        self.rank_txt:setPosition(50, 67)
        self.rank_pic:setPosition(88,68)
        self.name:setPosition(247, 84)
        self.level:setPosition(247,50)
        self.num:setPosition(406, 67)
        self.leader:setPosition(571,67)
    end

    local service = qy.tank.service.LegionService
    self:OnClick("join_btn",function()
        if self.entity.is_apply then
            service:applyCancel(self.entity, function(data)
                qy.hint:show(qy.TextUtil:substitute(50045))
                if delegate.updateList then
                    delegate.updateList()
                end
            end)
        else
            service:apply(self.entity, function(data)
                qy.hint:show(qy.TextUtil:substitute(50046))
                if delegate.updateList then
                    delegate.updateList()
                end
            end)
        end

    end)
end

function JoinCell:setSelected()
    self.light:setVisible(true)
end

function JoinCell:removeSelected()
    self.light:setVisible(false)
end

function JoinCell:render(entity)
    self.entity = entity
    if self.delegate.type == self.model.IS_WATCH then
        self.join_btn:setVisible(false)
        self.full_icon:setVisible(false)
        if entity.id == self.model:getCommanderEntity().legion_id then
            cc.SpriteFrameCache:getInstance():addSpriteFrames("legion/res/basic/legion_basic.plist")
            self.bg_cell:loadTexture("legion/res/basic/kuang2.png",1)
        else
            cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/img/common_img.plist")
            self.bg_cell:loadTexture("Resources/common/img/kuang1.png",1)
        end
    elseif entity:isFull() then
        self.join_btn:setVisible(false)
        self.full_icon:setVisible(true)
    else
        self.join_btn:setVisible(true)
        self.full_icon:setVisible(false)
        if entity.is_apply then
            self.join_btn:loadTextureNormal("Resources/common/button/btn_4.png",1)
            self.join_btn:loadTexturePressed("Resources/common/button/anniulan02.png",1)
            self.btn_txt:setSpriteFrame("legion/res/basic/shenqingzhong.png")
        else
            self.join_btn:loadTextureNormal("Resources/common/button/btn_3.png",1)
            self.join_btn:loadTexturePressed("Resources/common/button/anniuhong02.png",1)
            self.btn_txt:setSpriteFrame("legion/res/basic/jiaru.png")
        end
        self.join_btn:setContentSize(cc.size(132,55))
    end
    self.rank_pic:setSpriteFrame(entity:getRankIcon())
    self.rank_txt:setString(entity:getRankDesc())
    self.name:setString(entity.name)
    self.level:setString("Lv." .. entity.level)
    self.num:setString(entity:getCountDesc())
    self.num:setTextColor(entity:getCountColor())
    self.leader:setString(entity.boss_name)
end

return JoinCell
