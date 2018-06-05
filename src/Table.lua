function tableContains(tb, word)
    for i = 1, table.getn(tb) do
        if tb[i] == word then
            return true
        end
    end
    return false
end
