--[[
	军团基础的顶部
	Author: H.X.Sun
]]

local HeadCell = qy.class("HeadCell", qy.tank.view.BaseView, "legion_war/ui/HeadCell")

function HeadCell:ctor(params)
    HeadCell.super.ctor(self)
    self:InjectView("left")
    self:InjectView("right")
    self:InjectView("title")
    self:InjectView("silver_num")
    self:InjectView("diamond_num")
    self.userModel = qy.tank.model.UserInfoModel
    self.left:setPosition(0,qy.winSize.height)
	self.right:setPosition(qy.winSize.width,qy.winSize.height)

    self:InjectView("exitBtn")
    self:OnClick("exitBtn", function(sender)
        if params and params.onExit then
            params.onExit()
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})
end

function HeadCell:updateResource()
    self.silver_num:setString(self.userModel.userInfoEntity:getSilverStr())
end

function HeadCell:updateRecharge()
    self.diamond_num:setString(self.userModel.userInfoEntity:getDiamondStr())
end

function HeadCell:onEnter()
    self:updateResource()
    self:updateRecharge()
    --用户资源数据更新
    self.resListener = qy.Event.add(qy.Event.USER_RESOURCE_DATA_UPDATE,function(event)
        self:updateResource()
    end)
    --用户充值数据更新
    self.recListener = qy.Event.add(qy.Event.USER_RECHARGE_DATA_UPDATE,function(event)
        self:updateRecharge()
    end)
end

function HeadCell:onExit()
    qy.Event.remove(self.resListener)
    qy.Event.remove(self.recListener)
    self.resListener = nil
    self.recListener = nil
end

return HeadCell
