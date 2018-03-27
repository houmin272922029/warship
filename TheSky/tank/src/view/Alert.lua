--弹框提示 add by kaien lian
--[[

###### 用法1 #######
alert弹框使用方法1，内容为不换行文本：
    其中：
        title可以是一个字符串，也可以是一个对象.例如 "这是一个字符串"    或者  {"这是alert title" ,{255,0,255} }
        alertMesg可以是一个richText，也可以是一个字符串

        具体用法的代码如下：
            function callBack(flag)
                print(flag)
            end
            local extendObj = {

            }
            local alertMesg = {
                {id=1,color={255,255,255},alpha=255,text="这里是中文This color is white.",font="Arial",size=20},
                {id=2,color={255,255,0},alpha=255,text="And this is yellow. 中文中文",font="Arial",size=20},
                {id=3,color={0,0,255},alpha=255,text="This one is blue. 中文中文.",font="Arial",size=20},
                {id=4,color={0,255,0},alpha=255,text="And 中文中文 green..",font="Arial",size=20},
                {id=5,color={255,255,255},alpha=255,text="Last one is red 中文中文 .",font="Arial",size=20}
            }
            -- alertMesg = "aaaa"
            qy.alert:show({"这是alert title" ,{255,0,255} }  ,  alertMesg , cc.size(500 , 400) ,{{"ok" , 1} , {"cancel" , 1}  , {"close" , 2}} ,callBack ,extendObj)

###### 用法2 #######
alert弹框使用方法2，内容为换行文本，图文混排等用户自定义内容
    具体用法的代码如下：
        local testAlertNode = qy.tank.view.alert.TestAlertNode.new()
        qy.alert:showWithNode({"这是alert title" ,{192, 125, 45} }  ,  testAlertNode , 420 , 260 ,{{"关闭" , 3} , {"确认" , 2} } ,callBack ,extendObj)

]]
local Alert = qy.class("Alert", qy.tank.view.BaseView)

function Alert:ctor()
    Alert.super.ctor(self)
end

--[[
    必填写参数：
        title 标题。title可以是一个字符串，也可以是一个对象.例如 "这是一个字符串"    或者  {"这是alert title" ,{255,0,255} }
        content 可以是一个richText，也可以是一个字符串
        size    cc.size（宽度，高度）
        flags 按钮组设置，例如  {{"关闭" , 3} , {"确认" , 2} } , 该实例由两个按钮组成，每组的由 按钮名称 和 按钮样式索引组成
    选填参数：
        btnClickFunc  按钮点击回调
        extendObj     扩展对象
]]
function Alert:show( title , content ,size , flags , btnClickFunc , extendObj)
    assert(content,"content不能为空")
    assert(title , "title不能为空")
    assert(size , "size不能为空")
    --print("---------!!!!!!!!!---->"..size.width)
    self.extendObj = extendObj
    self.baseAlert = qy.tank.view.BaseAlert.new(
        {
            ["onClose"] = function()
                self.baseAlert:removeFrom(self)
            end ,
            ["title"] = title ,
            ["content"] = content ,
            ["width"] = size.width,
            ["height"] = size.height,
            ["flags"] = flags ,
            ["btnClickFunc"] = btnClickFunc ,
            ["extendObj"] = self.extendObj
        }
    )
    self.baseAlert:addTo(self)
    self.baseAlert:show()

end

--[[
    必填写参数：
        title 标题。title可以是一个字符串，也可以是一个对象.例如 "这是一个字符串"    或者  {"这是alert title" ,{255,0,255} }
        contentNode 内容为换行文本，图文混排等用户自定义内容.必须直接或间接继承自Node
        size    cc.size（宽度，高度）
        flags 按钮组设置，例如  {{"关闭" , 3} , {"确认" , 2} } , 该实例由两个按钮组成，每组的由 按钮名称 和 按钮样式索引组成
    选填参数：
        btnClickFunc  按钮点击回调
        extendObj     扩展对象
]]
function Alert:showWithNode( title , contentNode , size , flags , btnClickFunc , extendObj)
    assert(contentNode,"contentNode不能为空")
    assert(title , "title不能为空")
    assert(size , "size不能为空")
    self.extendObj = extendObj

    self.baseAlert = qy.tank.view.BaseAlert.new(
        {
            ["onClose"] = function()
                self.baseAlert:removeFrom(self)
            end ,
            ["title"] = title ,
            ["contentNode"] = contentNode ,
            ["width"] = size.width,
            ["height"] = size.height,
            ["flags"] = flags ,
            ["btnClickFunc"] = btnClickFunc ,
            ["extendObj"] = self.extendObj
        }
    )
    self.baseAlert:addTo(self)
    self.baseAlert:showWithNode()
end

--[[--
--显示tip
--]]
function Alert:showTip(contentNode)
    self.layout = ccui.Layout:create()
    self.layout:setContentSize(qy.winSize.width, qy.winSize.height)
    self.layout:setBackGroundColor(cc.c3b(0, 0, 0))
    self.layout:setBackGroundColorOpacity(0)
    self.layout:setTouchEnabled(true)
    contentNode:addChild(self.layout, -1)

    self:OnClick(self.layout, function()
        print("之前的啊")
        self:removeChild(contentNode)
    end, {["isScale"] = false})
    self:addChild(contentNode)
end
function Alert:showTip1(contentNode)
    self.layout1 = ccui.Layout:create()
    self.layout1:setContentSize(qy.winSize.width+1000, qy.winSize.height+1000)
    self.layout1:setBackGroundColor(cc.c3b(0, 0, 0))
    self.layout1:setBackGroundColorOpacity(0)
    self.layout1:setTouchEnabled(true)
    self.layout1:setPosition(cc.p(-900,-800))
    contentNode:addChild(self.layout1, -1)

    self:OnClick(self.layout1, function()
        self:removeChild(contentNode)
    end, {["isScale"] = false})
    self:addChild(contentNode,999,999)
end
function Alert:showTip2(contentNode)
    self.layout1 = ccui.Layout:create()
    self.layout1:setContentSize(qy.winSize.width+1800, qy.winSize.height+1800)
    self.layout1:setBackGroundColor(cc.c3b(0, 0, 0))
    self.layout1:setBackGroundColorOpacity(0)
    self.layout1:setTouchEnabled(true)
    self.layout1:setPosition(cc.p(-900,-800))
    contentNode:addChild(self.layout1, -1)

    self:OnClick(self.layout1, function()
        self:removeChild(contentNode)
    end, {["isScale"] = false})
    self:addChild(contentNode,999,999)
end
function Alert:removeTip(  )
    if self:getChildByTag(999) then
        self:removeChildByTag(999,true)
    end
end

return Alert
