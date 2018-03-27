--[[
	加入cell
	Author: H.X.Sun
]]

local PostCell = qy.class("PostCell", qy.tank.view.BaseView, "legion/ui/basic/PostCell")

local NumberUtil = qy.tank.utils.NumberUtil
local UserInfoModel = qy.tank.model.UserInfoModel

function PostCell:ctor(delegate)
    PostCell.super.ctor(self)
    self:InjectView("u_name")
    self:InjectView("u_level")
    self:InjectView("login_time")
    self:InjectView("post")
    self:InjectView("contribution")
    self:InjectView("op_btn")
    self:InjectView("light")
    self:InjectView("btn_txt")
    self:InjectView("bg_cell")

    local service = qy.tank.service.LegionService
    self:OnClick("op_btn",function()
        if self.user_score == 1 or self.user_score == 2 then
            --司令调职
            qy.tank.view.legion.basic.TransferDialog.new({
                ["entity"] = self.entity,
                ["updateJob"] = delegate.updateJob,
                ["user_score"] = self.user_score,
            }):show(true)
        end
    end)
end

function PostCell:setSelected()
    self.light:setVisible(true)
end

function PostCell:removeSelected()
    self.light:setVisible(false)
end

function PostCell:render(entity)
    self.user_score = qy.tank.model.LegionModel:getCommanderEntity().user_score
    self.entity = entity
    self.u_name:setString(entity.name)
    self.u_level:setString("Lv."..entity.level)
    self.post:setString(entity:getPostName())
    self.contribution:setString(entity:getContributionStr())

    if entity.kid == UserInfoModel.userInfoEntity.kid then
        cc.SpriteFrameCache:getInstance():addSpriteFrames("legion/res/basic/legion_basic.plist")
        self.bg_cell:loadTexture("legion/res/basic/kuang2.png",1)
    else
        cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/img/common_img.plist")
        self.bg_cell:loadTexture("Resources/common/img/kuang1.png",1)
    end

    if self.user_score == 1 then
        --司令不能T自己
        if entity.user_score == 1 then
            self.op_btn:setVisible(false)
        else
            self.op_btn:setVisible(true)
            -- self.btn_txt:setSpriteFrame("legion/res/basic/caozuo.png")
        end
    elseif self.user_score == 2 then
        --副司令不能T司令、副司令、参谋长
        if entity.user_score == 1 or entity.user_score == 2 or entity.user_score == 3 then
            self.op_btn:setVisible(false)
        else
            self.op_btn:setVisible(true)
            -- self.btn_txt:setSpriteFrame("legion/res/basic/tiren.png")
        end
    else
        --其他人不可T人
        self.op_btn:setVisible(false)
    end

    if entity.t > 60 then
		  local sTime = NumberUtil.secondsToTimeStr((entity.t), 7)
		  self.login_time:setString(qy.TextUtil:substitute(50039, sTime))
    else
      self.login_time:setString(qy.TextUtil:substitute(50040))
    end
end

return PostCell
