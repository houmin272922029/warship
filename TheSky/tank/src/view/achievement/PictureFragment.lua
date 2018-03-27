--[[
--图鉴
--Author: mingming
--Date:
]]

local PictureFragment = qy.class("PictureFragment", qy.tank.view.BaseView, "view/achievement/PictureFragment")

function PictureFragment:ctor(delegate)
    PictureFragment.super.ctor(self)
	local data = delegate.data
    for i = 1, 3 do
        -- data[i].callback = function()
        --     self.delegate.callback(data[i].entity)
        -- end
    	self:InjectCustomView("Item" .. i, qy.tank.view.common.TankItem2, {
                ["params"] = data[i],
                ["callback"] = function(entity)
                    delegate.callback(entity)
                end
            })
    	self["Item" .. i]:setVisible(false)
    end

    self:setData(data)
end

function PictureFragment:setData(data)
	for i = 1, 3 do
		self["Item" .. i]:setVisible(data[i] and true or false)
        self["Item" .. i]:update(data[i])
	end
end


return PictureFragment