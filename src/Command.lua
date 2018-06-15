-- Command.lua
-- Contains functions and tables for console commands
on = {"on", "true", "enable", "active", "-t"}
off = {"off", "false", "disable", "inactive", "-f"}

close = {"close", "quit", "exit"}
reset = {"reset", "clear"}
cut = {"cut"}
toggle = {"toggle"}
time = {"time", "day", "night"}
debug = {"debug"}
night = {"night"}
treebug = {"treebug"}

-- promptCommand
-- input: string (cmd)
-- output: nil
--   the given string cmd is tokenized into a table 'args'. the first element is taken as the input commnand
--     and the remaining elements are flags. if the command is valid, it is performed; otherwise an error
--     message is printed to console stating that the command is invalid.
function promptCommand(cmd)
    local args = tokenizeString(cmd)
    local argmax = table.getn(args)

    -- RESET command
    if tableContains(reset, args[1]) then
        if table.getn(args) == 1 then
            init()
        else
            throwIncorrectUsage(args[1])
        end
    -- CLOSE window command
    elseif tableContains(close, args[1]) then
        w.close()
    -- toggle DEBUG menu
    elseif tableContains(debug, args[1]) then
        if table.getn(args) ~= 2 then
            throwIncorrectUsage(args[1])
        elseif tableContains(on, args[2]) then
            DEBUG = true
        elseif tableContains(off, args[2]) then
            DEBUG = false
        else
            throwIncorrectUsage(args[1])
        end
    -- togle NIGHT overlay
    elseif tableContains(night, args[1]) then
        if table.getn(args) ~= 2 then
            throwIncorrectUsage(args[1])
        elseif tableContains(on, args[2]) then
            nightActive = true
        elseif tableContains(off, args[2]) then
            nightActive = false
        else
            throwIncorrectUsage(args[1])
        end

    else
        throwUnknownCommand(args[1])
    end

    --[[ prints arguments to console
    for i=1, argmax do
        print("argument " .. tostring(i) .. ": " .. args[1])
        table.remove(args, 1)
    end
    ]]--
end

-- throwIncorrectUsage
-- input: string (cmd)
-- output: nil
--   prints a message to console indicating that the command entered is in incorrect format
function throwIncorrectUsage(cmd)
    print("Incorrect usage of the '" .. cmd .. "' command")
end

-- throwUnknownCommand
-- input: string (cmd)
-- output: nil
--   prints a message to console indicating that the text entered is not a valid command
function throwUnknownCommand(cmd)
    if cmd then
        print("'" .. cmd .. "' is not a valid command")
    end
end

-- toggleBoolean
-- input: boolean (bool)
-- output: boolean
--   switches the state of the given boolean variable
function toggleBoolean(bool)
    return not bool
end

--tokenizeString
--input:
--  string str
--output:
--  table tokens
--    all tokens of string delimited by the space character, %s
function tokenizeString(str)
    local tokens = {} 
    for word in string.gmatch(str, "([^%s]+)") do
        table.insert(tokens, word)
    end
    return tokens
end

--pushConsole
--
function pushConsole(obj, line)
    local args = tokenizeString(line)
    table.insert(obj, 1, table.concat(args, " "))
    if (table.getn(obj) > obj.memory) then
        table.remove(obj)
    end
    for i=1,table.getn(obj) do
        print("Console " .. i .. ": " .. obj[i])
    end
end
