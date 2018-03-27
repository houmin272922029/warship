--[[--
    开发服选择后端分支，默认是 develop
    Author: H.X.Sun
--]]--
local SelectBranchView = qy.class("SelectBranchView", qy.tank.view.BaseView, "view/debug/SelectBranchView")

function SelectBranchView:ctor(delegate)
    SelectBranchView.super.ctor(self)

    local branch_arr = {}
    if qy.language == "cn" then
        branch_arr = {
            "develop",
            "1.0.0",
            "1.0.1",
            "1.0.2",
            "1.0.3",
            "1.0.4",
        }
    elseif qy.language == "en" then
        branch_arr = {
            "en"
        }
    end
    
    local model = qy.tank.model.UserInfoModel
    for i = 1, 6 do
        self:OnClick("branch_"..i,function()
            model:setDevelopBranch(branch_arr[i])
            delegate.showLogionView()
        end)
    end
end

return SelectBranchView
