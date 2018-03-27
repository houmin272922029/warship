

local Cell = qy.class("Cell", qy.tank.view.BaseView, "christmas_sevendays/ui/Cell")


function Cell:ctor(delegate)
    Cell.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService
    self:InjectView("title")
    self:InjectView("jindu")--进度
    self:InjectView("lingquBt")--
    self:InjectView("yilingqu")
    self:InjectView("bg")
    self:InjectView("list")
    self.yilingqu:setVisible(false)
    self.data = delegate.data
    self.value = delegate.value--任务id
    self.jump_id = 0
    self:OnClick("lingquBt", function(sender)
        if self.jump_id == 0 then
            local id = self.data[self.index].task_id
            print("任务id",id)
            service:getaward(1,id, function ( data )
                delegate:callback()
            end)
        else
            print("跳转操作")
            qy.tank.utils.ModuleUtil.viewRedirectByViewId(self.jump_id,function ()
                delegate:dismiss()
            end)
        end
    end)
  
end

function Cell:render(_idx)
    self.index = _idx
    local data = self.data[_idx]
    self.title:setString(data.desc)
    self.list:removeAllChildren()
    self.awardList = qy.AwardList.new({
        ["award"] = data.award,
        ["cellSize"] = cc.size(100,80),
        ["type"] = 2,
        ["itemSize"] = 2,
        ["hasName"] = false,
        ["len"] = 4
    })
    local num = 0
    if #data.award == 1 then
        self.awardList:setPosition(-95,130)
    elseif #data.award == 2 then
        self.awardList:setPosition(-50,130)
    elseif #data.award == 3 then
        self.awardList:setPosition(-5,130)
    else
        self.awardList:setPosition(40,130)
    end
    
    self.list:addChild(self.awardList)
    print("renwuid=======",self.value)
    print("shuzu",json.encode(self.model.tasklist))
    if self.model.tasklist[tostring(self.value)] then
        num = self.model.tasklist[tostring(self.value)]
    end
    num = num>data.param and data.param or num
    self.jindu:setString(num.."/"..data.param)
    if data.param >= 100000 then
        self.jindu:setPosition(cc.p(cc.p(450,117)))
    else
        self.jindu:setPosition(cc.p(497,117))
    end
    if num < data.param then
        if data.jump_id == 0 then
            self.lingquBt:setTitleText("领取")
            self.lingquBt:setEnabled(false)
            self.jump_id = 0
            self.lingquBt:loadTextureNormal("Resources/common/button/btn_3.png",1)
            self.lingquBt:loadTexturePressed("Resources/common/button/anniuhong02.png",1)
        else
            self.lingquBt:setTitleText("前往")
            self.lingquBt:setEnabled(true)
            self.jump_id = data.jump_id
            self.lingquBt:loadTextureNormal("Resources/common/button/btn_4.png",1)
            self.lingquBt:loadTexturePressed("Resources/common/button/anniulan02.png",1)
        end
    else
        self.lingquBt:setEnabled(true)
        self.lingquBt:setTitleText("领取")
        self.jump_id = 0
        self.lingquBt:loadTextureNormal("Resources/common/button/btn_3.png",1)
        self.lingquBt:loadTexturePressed("Resources/common/button/anniuhong02.png",1)
    end
    local id = self.data[_idx].task_id
    print("sssss--------",json.encode(self.model.awardlist))
    self.falg = 1
    if self.model.awardlist == null then
        self.lingquBt:setVisible(true)
        self.yilingqu:setVisible(false)
    else
        for i=1,#self.model.awardlist do
            if self.model.awardlist[i] == id then
                self.yilingqu:setVisible(true)
                self.lingquBt:setVisible(false)
                break
            else
                 self.yilingqu:setVisible(false)
                self.lingquBt:setVisible(true)
            end

        end
    end

 
end

return Cell
