--[[
	加入cell
	Author: H.X.Sun
]]

local JoinCell = qy.class("JoinCell", qy.tank.view.BaseView, "legion/ui/mobilize/JoinCell")

local UserResUtil = qy.tank.utils.UserResUtil
local ColorMapUtil = qy.tank.utils.ColorMapUtil
local service = qy.tank.service.LeMobilizeService
local UserInfoModel = qy.tank.model.UserInfoModel

function JoinCell:ctor(delegate)
    JoinCell.super.ctor(self)
    self.delegate = delegate
    self.model = qy.tank.model.LeMobilizeModel

    self:InjectView("bg")
    self:InjectView("c_name")
    self:InjectView("c_initiate")
    self:InjectView("c_join")
    self:InjectView("join_btn")
    self:InjectView("btn_txt")
    self:InjectView("icon_head")
    self:InjectView("c_title")
    self:InjectView("t_title")
    for i = 1, 3 do
        self:InjectView("c_target_"..i)
    end
    self:OnClick("join_btn", function(sender)
        if self.entity.status == 2 then
            service:getAward(self.entity.unique_id,function()
                local silver,legion_exp
                if UserInfoModel.userInfoEntity.kid == self.entity.user_id then
                    silver = self.data.create_silver
                    legion_exp = self.data.create_legion_exp
                else
                    silver = self.data.join_silver
                    legion_exp = self.data.join_legion_exp
                end
                local msg = {
                    {id=1,color={255,255,255},alpha=255,text = qy.TextUtil:substitute(52001, legion_exp, silver) ,font=qy.res.FONT_NAME_2,size=24},
                }
                qy.alert:show({qy.TextUtil:substitute(52004) ,{255,183,0} }  ,  msg , cc.size(550 , 260),{{qy.TextUtil:substitute(52005) , 5}} ,function()end,"")
                delegate.callForAward()
            end)
        else
            local _status = self.model:getJoinStatus(self.data.id)
            if _status == self.model.NOT_CREATE_JOIN then
                qy.hint:show(qy.TextUtil:substitute(52006))
            else
                self:joinLogic()
            end
            -- elseif _status == self.model.SELECT_JOIN then
            --     qy.tank.view.legion.mobilize.TipsDialog.new({
            --         ["callBack"] = function()
            --             self:joinLogic()
            --         end,
            --         ["id"] = self.data.id,
            --     }):show(true)
            -- else
            --
            -- end
        end
    end)

end

function JoinCell:joinLogic()
    service:join(self.entity.unique_id,function()
        -- self.model:updateJoinId()
        self.delegate.callForJoin()
    end)
end

function JoinCell:render(entity)
    self.entity = entity
    cc.SpriteFrameCache:getInstance():addSpriteFrames("legion/res/mobilize/mobilize.plist")
    if not entity:isJoin() then
        if entity.status == 0 then
            --响应
            self.btn_txt:setSpriteFrame("legion/res/mobilize/xiangying.png")
            self.btn_txt:setScale(1)
        else
            --领取
            self.btn_txt:setSpriteFrame("legion/res/mobilize/lingqu.png")
            self.btn_txt:setScale(1.2)
        end
        self.join_btn:setTouchEnabled(true)
        self.join_btn:setBright(true)
    else
        self.btn_txt:setSpriteFrame("legion/res/mobilize/jinxingzhong.png")
        self.btn_txt:setScale(1)
        self.join_btn:setTouchEnabled(false)
        self.join_btn:setBright(false)
    end

    self.c_name:setString(entity.name)
    local data = self.model:getConfigById(entity.id)
    self.data = data

    if data then
        self.c_target_1:setString(data.describe .. ",(")
        if entity:isComplete() then
            self.c_target_2:setString(entity.num .. "/" .. data.params)
            self.c_target_3:setString(")")
            self.c_target_2:setTextColor(cc.c4b(52,255,0,255))
        else
            self.c_target_2:setString(entity.num)
            self.c_target_3:setString("/" .. data.params ..")")
            self.c_target_2:setTextColor(cc.c4b(219,2,1,255))
        end
        self.c_initiate:setString(qy.TextUtil:substitute(52007, data.create_silver, data.create_legion_exp))
        self.c_join:setString(qy.TextUtil:substitute(52007, data.join_silver, data.join_legion_exp))
        self.icon_head:setTexture(UserResUtil.getRoleIconByHeadType(entity.headicon))
        self.c_title:setString(data.title)
        self.c_title:setTextColor(ColorMapUtil.qualityMapColor(tostring(data.quality)))
        local t1x = self.c_name:getPositionX()
        local t1y = self.c_name:getPositionY()
        local t1w = self.c_name:getContentSize().width + t1x + 20
        self.t_title:setPosition(t1w, t1y)
        local t2w = self.t_title:getContentSize().width + t1w + 5
        self.c_title:setPosition(t2w, t1y)
    end

    local p1x = self.c_target_1:getPositionX()
    local p1y = self.c_target_1:getPositionY()
    local w1 = self.c_target_1:getContentSize().width
    local p2x = p1x + w1
    self.c_target_2:setPosition(p2x, p1y)
    local w2 = self.c_target_2:getContentSize().width
    self.c_target_3:setPosition(p2x + w2, p1y)
end

return JoinCell
