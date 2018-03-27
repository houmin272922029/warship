--[[
    关卡奖励预览界面
]]
local CheckpointAwardDialog = qy.class("CheckpointAwardDialog", qy.tank.view.BaseView, "view/campaign/CheckpointAwardDialog")

function CheckpointAwardDialog:ctor(is_true,delegate)
    CheckpointAwardDialog.super.ctor(self)

    self:InjectView("itemList")
    if is_true then
        local checkPointData = {}
        local exp = {}
        local awardType = qy.tank.view.type.AwardType
        if delegate.isFirstAttack == true  then
            exp.type = awardType.USER_EXP
            exp.num = delegate.checkPointData.first_exp
            table.insert(checkPointData , exp)
            print("delegate.checkPointData.first_award===",qy.json.encode(delegate.checkPointData.first_award))
            for i=1,#delegate.checkPointData.first_award do
                table.insert(checkPointData , delegate.checkPointData.first_award[i])
            end
            if delegate.checkPointData.drop_award ~=nil then
                for i=1,#delegate.checkPointData.drop_award do
                    table.insert(checkPointData , delegate.checkPointData.drop_award[i])
                end
            end
        else
            exp.type = awardType.USER_EXP
            exp.num = delegate.checkPointData.exp
            table.insert(checkPointData , exp)
            if delegate.checkPointData.award ~=nil then
                for i=1,#delegate.checkPointData.award do
                    table.insert(checkPointData , delegate.checkPointData.award[i])
                end
            end
            if delegate.checkPointData.drop_award ~=nil then
                for i=1,#delegate.checkPointData.drop_award do
                    table.insert(checkPointData , delegate.checkPointData.drop_award[i])
                end
            end
        end
        local awardItem
        local x = 0

        -- print(qy.json.encode(checkPointData))
        for i=1, #checkPointData do

            awardItem = qy.tank.view.common.AwardItem.createAwardView(checkPointData[i] ,1)
            self.itemList:addChild(awardItem)
            x = (awardItem:getWidth()+60)*(i-1)
            awardItem:setPosition(x +50,-50)
            awardItem:setScale(0.85)

            if i == #checkPointData and delegate.checkPointData.drop_rate ~= "" then
                local info = delegate.checkPointData.drop_rate < 100 and qy.TextUtil:substitute(6006) or delegate.checkPointData.drop_rate < 500 and qy.TextUtil:substitute(6007) or qy.TextUtil:substitute(6008)
                local label = cc.LabelTTF:create(info, qy.res.FONT_NAME_2, 20)
                label:setPosition(0, -90)
                label:setColor(cc.c4b(255, 255, 102,255))
                awardItem:addChild(label)
            end
       end
    else
        local checkPointData = {}
        local awardType = qy.tank.view.type.AwardType
            if delegate.checkPointData.award ~=nil then
                for i=1,#delegate.checkPointData.award do
                    table.insert(checkPointData , delegate.checkPointData.award[i])
                end
            end
            if delegate.checkPointData.drop_award ~=nil then
                for i=1,#delegate.checkPointData.drop_award do
                    table.insert(checkPointData , delegate.checkPointData.drop_award[i])
                end
            end
        local awardItem
        local x = 0
        print("CheckpointAwardDialog111",#checkPointData)
        for i=1, #checkPointData do

            awardItem = qy.tank.view.common.AwardItem.createAwardView(checkPointData[i] ,1)
            self.itemList:addChild(awardItem)
            x = (awardItem:getWidth()+60)*(i-1)
            awardItem:setPosition(x +50,-50)
            awardItem:setScale(0.85)

            if i == #checkPointData and delegate.checkPointData.drop_rate ~= "" then
                local info = delegate.checkPointData.drop_rate < 100 and qy.TextUtil:substitute(6006) or delegate.checkPointData.drop_rate < 500 and qy.TextUtil:substitute(6007) or qy.TextUtil:substitute(6008)
                local label = cc.LabelTTF:create(info, qy.res.FONT_NAME_2, 20)
                label:setPosition(0, -90)
                label:setColor(cc.c4b(255, 255, 102,255))
                awardItem:addChild(label)
            end
       end
    end   
end

return CheckpointAwardDialog
