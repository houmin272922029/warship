local InfoDialog = qy.class("InfoDialog", qy.tank.view.BaseDialog, "inter_service_escort.ui.InfoDialog")

local model = qy.tank.model.InterServiceEscortModel
local service = qy.tank.service.InterServiceEscortService
function InfoDialog:ctor(delegate, idx, mainview)
   	InfoDialog.super.ctor(self)

    self:setCanceledOnTouchOutside(true)
   	self:InjectView("Name_player")
   	self:InjectView("Img")
    self:InjectView("Lv")
    self:InjectView("Img_goods")
    self:InjectView("Name_goods")
   	self:InjectView("Btn_harray")
    
   	self:OnClick("Btn_harray", function()
        local kid = qy.tank.model.UserInfoModel.userInfoEntity.kid
        if (self.data.kid and kid == self.data.kid) then
            qy.hint:show(qy.TextUtil:substitute(44010))
        else
            if model.status == 3 then
                qy.hint:show(qy.TextUtil:substitute(44012))
            else
                service:plunder(self.data._id,function(data)    
                    local tips = require("inter_service_escort.src.TipsDialog").new()
                    if data.fight_result["end"].is_win == 1 then
                    print(data.award)
                    print(#data.award)
                        tips:addList({qy.TextUtil:substitute(90322)..self.data.server..self.data.nickname..qy.TextUtil:substitute(90323)..(data.award[1].num)})                          
                        table.remove(model.list, idx)
                        mainview:update()                     
                    else
                        mainview:update() 
                        tips:addList({qy.TextUtil:substitute(90321)})
                    end
                    self:dismiss()
                    tips:show()
                end)
            end
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_close", function()
       	self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:setData(delegate)
end

function InfoDialog:setData(data)
  	self.Name_player:setString("【"..data.server.."】" .. data.nickname)
    local UserResUtil = qy.tank.utils.UserResUtil
    self.Img:setTexture(UserResUtil.getRoleIconByHeadType(data.headicon))
  	self.Lv:setString("Lv"..data.level)  	

    self.Img_goods:loadTexture("inter_service_escort/res/" .. ((data.goods_id - 1) % 5 + 1) .. ".png", 1)
    self.Name_goods:setString(model:atRescours((data.goods_id - 1) % 5 + 1, data.level).name)

    self.Btn_harray:setBright(model.status ~= 3)

    self.data = data
end

return InfoDialog
