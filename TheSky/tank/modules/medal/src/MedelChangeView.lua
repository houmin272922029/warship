

local MedelChangeView = qy.class("MedelChangeView", qy.tank.view.BaseDialog, "medal/ui/MedelChangeView")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel

function MedelChangeView:ctor(delegate)
    MedelChangeView.super.ctor(self)
    self.delegate = delegate
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(850,570),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "medal/res/shilianzhuanhua.png",--

        ["onClose"] = function()
            self:dismiss()
        end
    })
    style:setPositionY(-10)
    self:addChild(style,-10)
    for i=1,3 do
        self:InjectView("box"..i)--锁定
        self:InjectView("boxchild"..i)--锁定duihao
    end
    self:InjectView("quxiaoBt")
    self:InjectView("quedingBt")
    self.quxiaoBt:setVisible(false)
    self:OnClickForBuilding1("box1",function ( sender )
        if self.box1flag == 0 then
            self.box1flag = 1--存本地
            self.boxchild1:setVisible(true)
        else
            self.box1flag = 0--存本地
            self.boxchild1:setVisible(false)
        end
    end)
    self:OnClickForBuilding1("box2",function ( sender )
        if self.box2flag == 0 then
            self.box2flag = 1--存本地
            self.boxchild2:setVisible(true)
        else
            self.box2flag = 0--存本地
            self.boxchild2:setVisible(false)
        end
    end)
    self:OnClickForBuilding1("box3",function ( sender )
        if self.box3flag == 0 then
            self.box3flag = 1--存本地
            self.boxchild3:setVisible(true)
        else
            self.box3flag = 0--存本地
            self.boxchild3:setVisible(false)
        end
    end)
    self:OnClick("quedingBt",function ( sender )
        local parm = {}
        if self.box1flag == 1 then
            table.insert(parm,2)
        end
        if self.box2flag == 1 then
            table.insert(parm,3)
        end
        if self.box3flag == 1 then
            table.insert(parm,4)
        end
        service:directDecomposeColour(parm,function (  )
           qy.hint:show("设置完成")
        end)
    end)
    self:OnClick("quxiaoBt",function ( sender )
       
    end)
    self.box1flag = 0 --存服务器的
    self.box2flag = 0
    self.box3flag = 0
    self:Update()
end
function MedelChangeView:onEnter()
    
end

function MedelChangeView:Update()
    local list = model.changelist
    for k,v in pairs(list) do
        if v == 2 then
             self.box1flag = 1
            break
        end
    end
    for k,v in pairs(list) do
        if v == 3 then
             self.box2flag = 1
            break
        end
    end
      for k,v in pairs(list) do
        if v == 4 then
             self.box3flag = 1
            break
        end
    end
    if self.box1flag == 0 then
        self.boxchild1:setVisible(false)
    else
        self.boxchild1:setVisible(true)
    end
    if self.box2flag == 0 then
        self.boxchild2:setVisible(false)
    else
        self.boxchild2:setVisible(true)
    end
    if self.box3flag == 0 then
        self.boxchild3:setVisible(false)
    else
        self.boxchild3:setVisible(true)
    end

end
function MedelChangeView:onExit()
    
end


return MedelChangeView
