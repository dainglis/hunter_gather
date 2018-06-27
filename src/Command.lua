-- Command.lua
-- Contains functions and tables for console commands

Commands = {
    ["on"] = {"on", "true", "enable", "active", "-t"},
    ["off"] = {"off", "false", "disable", "inactive", "-f"},

    ["help"] = {"help", "commands", usage="", tip="prints help page"},
    ["close"] = {"close", "quit", "exit", usage="", tip="exits the game"},
    ["reset"] = {"reset", usage="", tip="resets the game"},
    ["clear"] = {"clear"},
    ["cut"] = {"cut", usage="", tip="cuts a random tree"},
    ["toggle"] = {"toggle"},
    ["night"] = {"night", usage="[on | off]", tip="toggles night overlay"},
    ["cagalog"] = {"catalog", "catalogue", usage="", tip="shows the catalog"},

    ["debugflags"] = {"debug", "treebug", "waterbug", "echo", usage="[flag] [on | off]", tip="toggles various debug flags"}
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

    if table.getn(args) ~= 0 and debugFlagState["echo"] then
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
    -- closes the love window and background terminal
    elseif tableContains(Commands["close"], args[1]) then
        love.event.quit()
    -- toggle DEBUGFLAG commands
    elseif tableContains(Commands["debugflags"], args[1]) then
        if table.getn(args) ~= 2 then
            throwIncorrectUsage(args[1])
        elseif tableContains(Commands["on"], args[2]) then
            debugFlagState[args[1]] = true
        elseif tableContains(Commands["off"], args[2]) then
            debugFlagState[args[1]] = false
        else
            throwIncorrectUsage(args[1])
        end
    -- display HELP dialogue
    elseif tableContains(Commands["help"], args[1]) then
      if table.getn(args) == 1 then
          Console:clear()
          listCommands()
      else
          throwIncorrectUsage(args[1])
      end
       -- uses Console:push
    elseif tableContains(Commands["clear"], args[1]) then
        Console:clear()
    -- togle NIGHT overlay
    elseif tableContains(Commands["night"], args[1]) then
        if table.getn(args) ~= 2 then
            throwIncorrectUsage(args[1])
        elseif tableContains(Commands["on"], args[2]) then
            if nightFlag == false then
                Console:push("the sun sets")
            end

            nightFlag = true
        elseif tableContains(Commands["off"], args[2]) then
            if nightFlag == true then
                Console:push("the sun rises")
            end

            nightFlag = false
        else
            throwIncorrectUsage(args[1])
        end
    elseif tableContains(Commands["cut"], args[1]) then
        if table.getn(args) == 1 then
            args[2] = "1"
        end
        
        if table.getn(args) == 2 then
            local reps = tonumber(args[2])
            if reps == nil then
                throwIncorrectUsage(args[1])
            else
                if reps > 100 then
                    Console:push("that is far too many trees")
                else 
                    for i=1, reps do
                        largeForest:cutRandomTree()
                    end
                    Console:push(tostring(reps) .. " trees have been felled")
                end
            end
        end
    else
        throwUnknownCommand(args[1])
    end
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
        if (Commands[k].usage ~= nil) then
        Console:push(k .. " " .. Commands[k].usage)
        Console:push("  " .. Commands[k].tip)
        Console:push("  aliases: '" .. table.concat(Commands[k], "', '") .. "'")
        end
    end
end

-- initDebugState
-- input: nil
-- output: nil
--   sets up the global table debugFlagStates based on the 
--     Commands["debugflags"] string table. Currently sets all
--     flags to true
function initDebugState() 
    for k,j in pairs(Commands["debugflags"]) do
        debugFlagState[j] = false
    end
    print("Debug states initialized")
end
