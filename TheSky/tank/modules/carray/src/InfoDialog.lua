local InfoDialog = qy.class("InfoDialog", qy.tank.view.BaseDialog, "carray.ui.InfoDialog")

local model = qy.tank.model.CarrayModel
local service = qy.tank.service.CarrayService
function InfoDialog:ctor(delegate, idx, mainview)
   	InfoDialog.super.ctor(self)

    self:setCanceledOnTouchOutside(true)
   	self:InjectView("Name1")
   	self:InjectView("Name2")
   	self:InjectView("ArmyName")
   	self:InjectView("ResourceName1")
    self:InjectView("ResourceName2")
    self:InjectView("ResourceName_0")
   	self:InjectView("HarrayName")
   	self:InjectView("Btn_harray")
   	self:InjectView("HarrayName")
    self:InjectView("Image_7")
    
    self.Image_7:setPositionX(display.width / 2)
   	self:OnClick("Btn_harray", function()
        -- if model.status == 3 then
        --     qy.hint:show("正在押运中")
        -- else
        local kid = qy.tank.model.UserInfoModel.userInfoEntity.kid
        if (self.data.kid1 and kid == self.data.kid1) or (self.data.kid2 and kid == self.data.kid2) then
            qy.hint:show(qy.TextUtil:substitute(44010))
        else
            if model.legion.legion_id == self.data.legion_id then
                qy.hint:show(qy.TextUtil:substitute(44011))
            else
                if model.status == 3 then
                    qy.hint:show(qy.TextUtil:substitute(44012))
                else
                    service:plunder({
                          ["id"] = self.data._id
                    },function(data)    
                        local tips = require("carray.src.TipsDialog").new()
                        if data.is_win then
                            tips:addList({qy.TextUtil:substitute(44013) .. data.silver .. qy.TextUtil:substitute(44014)})                          
                            table.remove(model.list, idx)
                            mainview:update()                     
                        else
                            mainview:update() 
                            tips:addList({qy.TextUtil:substitute(44015)})
                        end
                        self:dismiss()
                        tips:show()
                    end)
                end
            end
        end
            
        -- end
       	
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_close", function()
       	self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:setData(delegate)
end

function InfoDialog:setData(data)
  	self.Name1:setString("Lv." .. data.level1 .. " " .. data.nickname1)
    if data.level2 > 0 then
        self.Name2:setString("Lv." .. data.level2 .. " " .. data.nickname2)
    else
        self.Name2:setString("")
    end
  	self.ArmyName:setString(data.legion_name)

  	local resourceName1 = (data.quality1 and data.quality1 > 0) and model:atRescours(data.quality1).name or ""
  	local resourceName2 = (data.quality2 and data.quality2 > 0) and model:atRescours(data.quality2).name or ""
  	local resourceName = resourceName2 ~= "" and  resourceName1 .. "+" .. resourceName2 or resourceName1

    self.ResourceName_0:setVisible(false)
    if resourceName1 == "" then
        self.ResourceName1:setString(resourceName2)
        self.ResourceName2:setString("")
        self.ResourceName1:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality2))
    elseif resourceName2 == "" then
        self.ResourceName1:setString(resourceName1)
        self.ResourceName2:setString("")
        self.ResourceName1:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality1))
    elseif resourceName1 ~= "" and resourceName2 ~= "" then
        self.ResourceName1:setString(resourceName1)
        self.ResourceName2:setString(resourceName2)
        self.ResourceName1:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality1))
        self.ResourceName2:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality2))
        self.ResourceName_0:setVisible(true)
    end
  	

    local myLegionId = model.legion.legion_id
    self.Btn_harray:setBright(model.status ~= 3 and myLegionId ~= data.legion_id)

    local quality = data.quality1 > data.quality2 and data.quality1 or data.quality2
    local level = data.quality1 > data.quality2 and data.level1 or data.level2
    local num = model:atRescours(quality).award[1].num * level

    self.HarrayName:setString(qy.TextUtil:substitute(44016) .. num)

    self.data = data
end

return InfoDialog
