--lijian ren  自己用的
local BaseAlert3 = qy.class("BaseAlert3", qy.tank.widget.PopupWindowWrapper, "view/alert/BaseAlert")

function BaseAlert3:ctor(delegate)
    BaseAlert3.super.ctor(self)

    self.delegate = delegate
    self:InjectView("alertPanel")
    self:InjectView("closeBtn")
    self:InjectView("titleTxt")
    self:InjectView("txtBg")
    self:InjectView("Title")
    self:InjectView("background")
    self:InjectView("borderImage")

    self.isCanceledOnTouchOutside = true

    self.bolderX = 40
    self.bolderY = 20
    self.btnSpaceWidth = 40  --btn间距

    -- 点击透明区域可关闭
    self:OnClick(self.mask, function()
        if self.isCanceledOnTouchOutside then
            self.delegate:onClose()
        end
    end,{["isScale"] = false})

    if self.alertPanel then
        self.alertPanel:setPosition(qy.winSize.width / 2 ,( qy.winSize.height ) * 0.55)
    else
        assert(self.alertPanel,"alertPanel容易为空")
        return
    end

    --背景图片尺寸
    self.background:setContentSize(self.delegate.width-16,self.delegate.height-16)
    self.borderImage:setContentSize(self.delegate.width,self.delegate.height)
    self.flags = delegate.flags
    self.btnClickFunc = delegate.btnClickFunc
    self.extendObj = delegate.extendObj
end

function BaseAlert3:show()
    self:setTitle()

    self:createBtns()

    self:createRichText()

    self:toShowPopupEffert()
end

function BaseAlert3:showWithNode()
    self:setTitle()

    self:createBtns()

    self:addWithNode()

    self:toShowPopupEffert()
end

function BaseAlert3:addWithNode()
    self.contentNode = self.delegate.contentNode
    if self.extendObj and self.extendObj.contentX and self.extendObj.contentY then
        self.contentNode:setPosition(self.extendObj.contentX, self.extendObj.contentY)
    else
        self.contentNode:setPositionY(self.titleTxt:getPositionY() - self.titleTxt:getContentSize().height/2 - 20)
    end
    self.alertPanel:addChild(self.contentNode)
end

function BaseAlert3:setBackgroundWithColor()

end

--设置title的内容和坐标
function BaseAlert3:setTitle()
    if type(self.delegate.title) == "string" then
        self.titleTxt:setString(self.delegate.title)
        self.titleTxt:setColor(cc.c3b(255,255,255))
    else
        self.titleTxt:setString(self.delegate.title[1])
        self.titleTxt:setColor(cc.c3b(self.delegate.title[2][1],self.delegate.title[2][2],self.delegate.title[2][3]))

    end
    self.titleTxt:setPositionY((self.delegate.height - self.titleTxt:getContentSize().height)/2 - self.bolderY)
    self.txtBg:setPositionY((self.delegate.height - self.titleTxt:getContentSize().height)/2 - self.bolderY)

    if self.delegate and self.delegate.extendObj then
        local url = self.delegate.extendObj.titleUrl
        if url then
            self.Title:setVisible(true)
            self.titleTxt:setVisible(false)
            self.Title:setSpriteFrame(url)
        else
            self.Title:setVisible(false)
            self.titleTxt:setVisible(true)
        end
    else
        self.Title:setVisible(false)
    end
end

--content内容，富媒体文本
function BaseAlert3:createRichText()

    self.richTxt = ccui.RichText:create()
    if qy.cocos2d_version ~= qy.COCOS2D_3_7_1 then
        self.richTxt:setAnchorPoint(1,0.5)
    end

    self.richTxt:ignoreContentAdaptWithSize(false)
    self.richTxt:setContentSize(self.delegate.width-self.bolderX*3, 100)

    if type(self.delegate.content) == "string" then
        local fontName = qy.language == "tw" and "res/Resources/font/ttf/black_body_2.TTF" or "Arial"
        local stringTxt = ccui.RichElementText:create( 1, cc.c3b(255, 255, 255), 255, self.delegate.content , fontName, 20 )
        self.richTxt:pushBackElement(stringTxt)
        else if(self.delegate.content~= nil) then
            local rTxt = self.delegate.content
            for i=1,#rTxt do
                local reK = ccui.RichElementText:create(rTxt[i].id,cc.c3b(rTxt[i].color[1],rTxt[i].color[2],rTxt[i].color[3]),rTxt[i].alpha,rTxt[i].text,rTxt[i].font,rTxt[i].size)
                self.richTxt:pushBackElement(reK)
            end
        end
    end
    self.alertPanel:addChild(self.richTxt)
    self.richTxt:setPositionX(self.richTxt:getContentSize().width / 2)
    self.richTxt:setPositionY((self.delegate.height - self.titleTxt:getContentSize().height*3 - self.richTxt:getContentSize().height)/2 - self.bolderY)
end

--创建btn按钮组
function BaseAlert3:createBtns()
    if(self.flags==nil) then return end

    local startY = 0
    local disWidth = self.btnSpaceWidth
    local btnArr = {}

    for k,v in pairs(self.flags) do
        local btn = self:getBtnStyleById(v[2])
        btn:setName(v[1])
        if v[3] then
            local sprite = cc.Sprite:createWithSpriteFrameName(v[3])
            sprite:setPosition(77, 31)
            btn.Button_1:addChild(sprite)
            btn:setTitleText("")
        else
            btn:setTitleText(v[1])
        end
        btnArr[k] = btn
    end
    local len = #btnArr
    local btnWidth = 152

    local fixX = (self.delegate.width - btnWidth * len - 16) / (len + 1)  -- 152 是按钮的宽度

    local btnX , btnY
    for k,btn in pairs(btnArr) do
        self.background:addChild(btn)
        btnX = fixX * k + btnWidth / 2 + btnWidth * (k -1)
        btnY = startY + 43

        btn:setPosition(btnX, btnY)
        self:OnClick1(btn.Button_1, function()
           if self.delegate.btnClickFunc~=nil then
                self.delegate.btnClickFunc(btn:getName())
           end
           self.delegate:onClose()
        end)
    end
end

--btn按钮样式工厂
function BaseAlert3:getBtnStyleById(id)
    local btn
    if(id == 1) then
        -- btn = ccui.Button:create(
        --     "Resources/common/button/btn_3.png",
        --     "Resources/common/button/anniuhong02.png",
        --     "Resources/common/button/anniuhui.png"
        -- )
        return qy.tank.view.common.Button1.new()
    end

    if(id == 2) then
        -- btn = ccui.Button:create(
        --     "Resources/common/button/btn_3.png",
        --     "Resources/common/button/anniuhong02.png",
        --     "Resources/common/button/anniuhui.png"
        -- ):setTitleFontSize(24)
        -- return btn
        return qy.tank.view.common.Button2.new()
    end

    if(id == 3) then
        -- btn = ccui.Button:create(
        --     "Resources/common/button/btn_3.png",
        --     "Resources/common/button/anniuhong02.png",
        --     "Resources/common/button/anniuhui.png"
        -- ):setTitleFontSize(24)
        -- return btn
        return qy.tank.view.common.Button1.new()
    end

    if(id == 4) then
        -- btn = ccui.Button:create(
        --     "Resources/common/button/btn_3.png",
        --     "Resources/common/button/anniuhong02.png",
        --     "Resources/common/button/anniuhui.png"
        -- ):setTitleFontSize(24)
        -- btn:setScale(1)
        -- return btn
        return qy.tank.view.common.Button2.new()
    end

    if(id == 5) then
        -- btn = ccui.Button:create(
        --     "Resources/common/button/btn_4.png",
        --     "Resources/common/button/anniulan02.png",
        --     "Resources/common/button/anniuhui.png"
        -- ):setTitleFontSize(24)
        -- btn:setScale(1)
        -- return btn
        return qy.tank.view.common.Button1.new()
    end

    --默认的btn样式
    -- btn = ccui.Button:create(
    --     "Resources/common/button/btn_3.png",
    --     "Resources/common/button/anniuhong02.png",
    --     "Resources/common/button/anniuhui.png"
    -- )
    -- return btn
    return qy.tank.view.common.Button1.new()
end

return BaseAlert3
