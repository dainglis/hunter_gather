-- Command.lua
-- Contains functions and tables for console commands

Commands = {
    ["on"] = {"on", "true", "enable", "active", "-t"},
    ["off"] = {"off", "false", "disable", "inactive", "-f"},
    ["close"] = {"close", "quit", "exit"},
    ["reset"] = {"reset", "clear"},
    ["cut"] = {"cut"},
    ["toggle"] = {"toggle"},
    ["time"] = {"time", "day", "night"},
    ["debug"] = {"debug"},
    ["night"] = {"night"},
    ["cagalog"] = {"catalog", "catalogue"},
    ["treebug"] = {"treebug"}  
}

-- promptCommand
-- input: string (cmd)
-- output: nil
--   the given string cmd is tokenized into a table 'args'. the first element is taken as the input commnand
--     and the remaining elements are flags. if the command is valid, it is performed; otherwise an error
--     message is printed to console stating that the command is invalid.
function promptCommand(cmd)
    local args = tokenizeString(cmd)
    local argmax = table.getn(args)

    if table.getn(args) ~= 0 then
        local rebuiltString = table.concat(args, " ")
        Console:push(rebuiltString)
    end

    -- RESET command
    if tableContains(Commands["reset"], args[1]) then
        if table.getn(args) == 1 then
            init()
        else
            throwIncorrectUsage(args[1])
        end
    -- CLOSE window command
    elseif tableContains(Commands["close"], args[1]) then
        w.close()
    -- toggle DEBUGFLAG commands
    elseif tableContains(Commands["debug"], args[1]) then
        if table.getn(args) ~= 2 then
            throwIncorrectUsage(args[1])
        elseif tableContains(Commands["on"], args[2]) then
            DEBUG = true
        elseif tableContains(Commands["off"], args[2]) then
            DEBUG = false
        else
            throwIncorrectUsage(args[1])
        end
    -- togle NIGHT overlay
    elseif tableContains(Commands["night"], args[1]) then
        if table.getn(args) ~= 2 then
            throwIncorrectUsage(args[1])
        elseif tableContains(Commands["on"], args[2]) then
            nightActive = true
        elseif tableContains(Commands["off"], args[2]) then
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
    local incorrect = "incorrect use of the '" .. cmd .. "' command"
    print(incorrect)
    Console:push(incorrect)
end

-- throwUnknownCommand
-- input: string (cmd)
-- output: nil
--   prints a message to console indicating that the text entered is not a valid command
function throwUnknownCommand(cmd)
    if cmd then
        local unknown = "'" .. cmd .. "' is not a valid command"
        print(unknown)
        Console:push(unknown)
    end
end

-- toggleBoolean
-- input: boolean (bool)
-- output: boolean
--   switches the state of the given boolean variable
function toggleBoolean(bool)
    return not bool
end

-- tokenizeString
-- input: string (str)
-- output: table (tokens)
--   all tokens of string delimited by the space character, %s
function tokenizeString(str)
    local tokens = {} 
    for word in string.gmatch(str, "([^%s]+)") do
        table.insert(tokens, word)
    end
    return tokens
end

--listCommands
--input: nil
--output: nil
--  prints to console all of the available text commands and their aliases
function listCommands()
    for k in pairs(Commands) do
        print("command: '" .. k .. "', aliases: '" .. table.concat(Commands[k], "', '") .. "'")
    end
end
