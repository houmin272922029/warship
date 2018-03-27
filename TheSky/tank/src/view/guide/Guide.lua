--[[--
--引导页
--Author: H.X.Sun
--Date: 2015-06-25
--]]--

local Guide = qy.class("Guide", qy.tank.view.BaseView)

function Guide:ctor()
    Guide.super.ctor(self)
end

-- function Guide:showDialogueGuide()
-- 	if self.clickGuide then
-- 		self:remove(self.clickGuide)
-- 		self.clickGuide = nil
-- 	end
-- 	if self.dialogueGuide then
-- 		self.dialogueGuide = qy.tank.view.guide.noviceGuide.DialogueGuide.new()
-- 		self:addChild(self.dialogueGuide)
-- 	end
-- end

-- function Guide:showClickGuide()
-- 	if self.dialogueGuide then
-- 		self:remove(self.dialogueGuide)
-- 		self.dialogueGuide = nil
-- 	end
-- 	if self.clickGuide then
-- 		self.clickGuide = qy.tank.view.guide.noviceGuide.ClickGuide.new()
-- 		self:addChild(self.clickGuide)
-- 	end
-- end

function Guide:onEnter( )

end

function Guide:remove()
	-- body
end

return Guide