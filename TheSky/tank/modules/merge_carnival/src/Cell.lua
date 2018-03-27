

local Cell = qy.class("Cell", qy.tank.view.BaseView, "merge_carnival/ui/Cell")


function Cell:ctor(delegate)
    Cell.super.ctor(self)
    self.model = qy.tank.model.MergeCarnialModel
    local service = qy.tank.service.MergeCarnialService
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
            service:getaward(id, function ( data )
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
    local num = 0
    for i=1,#data.award do
        local item = qy.tank.view.common.AwardItem.createAwardView(data.award[i] ,1)
        self.list:addChild(item)
        item:setPosition(40 + 100*(i - 1), 50)
        item:setScale(0.75)
        item.name:setVisible(false)
    end
    -- print("renwuid=======",self.value)
    -- print("shuzu",json.encode(self.model.tasklist))
    local task_id = self.data[self.index].task_id
    if data.type == 16 or data.type == 18 then
        self.jindu:setVisible(false)
    else
        self.jindu:setVisible(true)
        num =self.model.tasklist[task_id..""].progress--某个任务完成的情况，服务器返回
        num = num > tonumber(data.param) and tonumber(data.param) or num
        self.jindu:setString(num.."/"..data.param)
        if tonumber(data.param) >= 100000 then
            self.jindu:setPosition(cc.p(450,117))
        else
            self.jindu:setPosition(cc.p(497,117))
        end
    end
    -- print("=============11111111",task_id)
    --  print("------------------00",json.encode(self.model.tasklist[task_id..""]))
    local status = self.model.tasklist[task_id..""].status
    if status == - 1 then
        self.yilingqu:setVisible(true)
        self.lingquBt:setVisible(false)
        if data.jump_id == 67 then
            self.jindu:setVisible(false)
        end
        if  data.type == 18 then
            self.yilingqu:loadTexture("Resources/common/img/yigoumai.png",1)
        else
            self.yilingqu:loadTexture("Resources/common/img/D_12.png",1)
        end
    elseif status == 0 then
        self.yilingqu:setVisible(false)
        self.lingquBt:setVisible(true)
        if data.type == 16 or data.type == 18 then
            self.jindu:setVisible(false)
        else
            self.jindu:setVisible(true)
        end
        if data.jump_id == 0 then
            self.lingquBt:setTitleText("领取")
            self.lingquBt:setEnabled(false)
            self.jump_id = 0
            self.lingquBt:loadTextureNormal("Resources/common/button/btn_3.png",1)
            self.lingquBt:loadTexturePressed("Resources/common/button/anniuhong02.png",1)
        else
            if data.jump_id == 67 then
                self.lingquBt:setTitleText("去充值")
            else
                self.lingquBt:setTitleText("前往")
            end
            self.lingquBt:setEnabled(true)
            self.jump_id = data.jump_id
            self.lingquBt:loadTextureNormal("Resources/common/button/btn_4.png",1)
            self.lingquBt:loadTexturePressed("Resources/common/button/anniulan02.png",1)
        end
    elseif status == 1 then
        if data.type == 16 or data.type == 18 then
            self.jindu:setVisible(false)
        else
            self.jindu:setVisible(true)
        end
        self.yilingqu:setVisible(false)
        self.lingquBt:setVisible(true)
        self.lingquBt:setEnabled(true)
        if data.type == 18 then
            self.lingquBt:setTitleText("购买")
        else
            self.lingquBt:setTitleText("领取")
        end
        self.jump_id = 0
        self.lingquBt:loadTextureNormal("Resources/common/button/btn_3.png",1)
        self.lingquBt:loadTexturePressed("Resources/common/button/anniuhong02.png",1)
    else
        self.lingquBt:setTitleText("已过期")
        if data.jump_id == 67 then
            self.jindu:setVisible(false)
        end
        self.lingquBt:setEnabled(false)
        self.jump_id = 0
        self.lingquBt:loadTextureNormal("Resources/common/button/btn_3.png",1)
        self.lingquBt:loadTexturePressed("Resources/common/button/anniuhong02.png",1)
    end
 
 
end

return Cell
