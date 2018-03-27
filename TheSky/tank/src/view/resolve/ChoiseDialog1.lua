


local ChoiseDialog = qy.class("ChoiseDialog", qy.tank.view.BaseDialog, "view/resolve/ChoiseDialog1")
local model = qy.tank.model.ResolveModel

function ChoiseDialog:ctor(idx,delegate,refresh)
    ChoiseDialog.super.ctor(self)

	self:InjectView("closeBt")
	self:InjectView("cancelBt")

    self:OnClick("closeBt",function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("cancelBt",function()
        self:removeSelf()
    end,{["isScale"] = false})

    for i=1,4 do
        self:InjectView("bt"..i)
        self:InjectView("btbg"..i)
        self["btbg"..i]:setVisible(false)
    end

    self:OnClick("bt1",function()
        if self.choose1 == 0 then
            self.choose1 = 1
        else
            self.choose1 = 0
        end
        self.btbg1:setVisible(self.choose1 == 1)
    end,{["isScale"] = false})
    self:OnClick("bt2",function()
        if self.choose2 == 0 then
            self.choose2 = 1
        else
            self.choose2 = 0
        end
        self.btbg2:setVisible(self.choose2 == 1)
    end,{["isScale"] = false})
    self:OnClick("bt3",function()
        if self.choose3 == 0 then
            self.choose3 = 1
        else
            self.choose3 = 0
        end
        self.btbg3:setVisible(self.choose3 == 1)
    end,{["isScale"] = false})
    self:OnClick("bt4",function()
        if self.choose4 == 0 then
            self.choose4 = 1
        else
            self.choose4 = 0
        end
        self.btbg4:setVisible(self.choose4 == 1)
    end,{["isScale"] = false})

    self.choose1 = 0
    self.choose2 = 0
    self.choose3 = 0
    self.choose4 = 0

    self:OnClick("okBt",function()
        if self.choose3 == 0 and self.choose2 == 0 and self.choose1 == 0 and self.choose4 == 0 then
            qy.hint:show("请勾选要分解的品质")
            return
        end
        local list = {}
        if self.choose1 == 1 then
            table.insert(list,2)
        end
        if self.choose2 == 1 then
            table.insert(list,3)
        end
        if self.choose3 == 1 then
            table.insert(list,4)
        end
        if self.choose4 == 1 then
            table.insert(list,5)
        end
        
        delegate.selectAll1(idx,list, function()--让对勾看的到
            refresh:update()
            refresh:reloadData()
           
        end)

        if table.nums(model.selectList) > 0 then
            delegate.showTips(idx, refresh)
            refresh:update()
            refresh:reloadData()
        else
            if idx == 1 then
                qy.hint:show(qy.TextUtil:substitute(28001))
            else
                qy.hint:show(qy.TextUtil:substitute(28002))
            end
            
        end
    end,{["isScale"] = false})

end


return ChoiseDialog
