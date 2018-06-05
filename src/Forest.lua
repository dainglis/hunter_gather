Forest = {trees = {}}

function Forest:addTree(t)
    table.insert(self.trees, t)
end

function Forest:newTree(t_x, t_y, t_r)
    tree = {x = t_x, y = t_y, r = t_r, cut = false}
    table.insert(self.trees, tree)
end

function Forest:size()
    return table.getn(self.trees)
end
