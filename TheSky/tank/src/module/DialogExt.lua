local DialogExt = class("DialogExt")

function DialogExt:show()
    qy.App.runningScene:showDialog(self)
end

function DialogExt:onDismiss(sender)
    qy.App.runningScene:dismissDialog()
end

return DialogExt
