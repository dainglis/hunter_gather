Tree = {x = 0, y = 0, r = 1, cut = false}

function Tree:setPosition(x, y)
    self.x = x
    self.y = y
end

function Tree:setSize(r)
    self.r = r
end

function Tree:chop()
    self.cut = true
end


