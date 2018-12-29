-- Commands.lua
-- Contains functions and tables for console commands
--
-- requires source Console, pulled from main
--
-- requires library hglib, pulled from main


-- List of available console commands and command line arguments
-- Command form:
--  ["command"] = {"command", "alias1", "alias2", ... , 
--      usage="command arguments if applicable",
--      tip="tooltip for the help dialog",
--      status=*relevant command data, not used for all commands*, }
--
-- Argument form:
--  ["argument"] = {"argument, alias1", "alias2", ... }
Commands = {
    -- arguments
    ["on"] = {"on", "true", "enable", "active", "-t"},
    ["off"] = {"off", "false", "disable", "inactive", "-f"},

    -- console commands
    ["help"] = {"help", "commands", "?", usage="", tip="prints help page"},
    ["close"] = {"close", "quit", "exit", usage="", tip="exits the game"},
    ["reset"] = {"reset", usage="", tip="resets the game"},
    ["clear"] = {"clear", "cls", usage="", tip="clears the console"},
    ["cut"] = {"cut", usage="[ %number ]", tip="cuts %number random trees, or 1 if no arguments"},
    ["night"] = {"night", usage="[ on | off ]", tip="toggles night overlay"},
    ["catalog"] = {"catalog", "catalogue", usage="", tip="shows the catalog"},

    -- debug command
    ["echo"] = {"echo", usage="[ on | off | %message ]", 
        tip="toggles echo of entered command or relays %message",
        status=false},
    -- TODO: make debugflags not suck and make it less global-dependent 
    ["debugflags"] = {"debug", "treebug", "waterbug", "life",
        usage="[flag] [on | off]", tip="toggles various debug flags"}
}


-- Commands:prompt
-- input: string (cmd)
-- output: nil
--   the given string cmd is tokenized into a table 'args'. the first element is taken as the input commnand
--     and the remaining elements are flags. if the command is valid, it is performed; otherwise an error
--     message is printed to console stating that the command is invalid.
function Commands:prompt(cmd)
    local args = tokenizeString(cmd)
    local argmax = table.getn(args)

    -- check ECHO status
    if table.getn(args) ~= 0 and Commands["echo"].status then
        local rebuiltString = table.concat(args, " ")
        Console:push(rebuiltString)
    end

     
    -- HELP display
    if tableContains(Commands["help"], args[1]) then
      if table.getn(args) == 1 then
          Console:clear()
          Commands:list()
      else
          Commands:throwIncorrectUsage(args[1])
      end
    -- CLOSE window command
    -- closes the love window and background terminal
    elseif tableContains(Commands["close"], args[1]) then
        love.event.quit()
    -- RESET command
    -- resets the hunter_gather instance by calling the init function 
    elseif tableContains(Commands["reset"], args[1]) then
        if table.getn(args) == 1 then
            Console:clear()
            init()
        else
            Commands:throwIncorrectUsage(args[1])
        end
    -- ECHO command
    elseif tableContains(Commands["echo"], args[1]) then
        if table.getn(args) < 2 then
            -- "echo" entered
            -- pushes a blank line to the Console
            Console:push(" ") 
        elseif tableContains(Commands["on"], args[2]) then
            -- turn echo on
            Commands["echo"].status = true
        elseif tableContains(Commands["off"], args[2]) then
            -- turn echo off
            Commands["echo"].status = false
        else  
            -- print entered text to console
            local rebuildString = ""
            for i=2,table.getn(args)  do
                rebuildString = rebuildString .. args[i] .. " "
            end
            Console:push(rebuildString)
        end
    -- DEBUGFLAG commands
    elseif tableContains(Commands["debugflags"], args[1]) then
        if table.getn(args) ~= 2 then
            Commands:throwIncorrectUsage(args[1])
        elseif tableContains(Commands["on"], args[2]) then
            debugFlagState[args[1]] = true
        elseif tableContains(Commands["off"], args[2]) then
            debugFlagState[args[1]] = false
        else
            Commands:throwIncorrectUsage(args[1])
        end
    -- CLEAR screen command
    elseif tableContains(Commands["clear"], args[1]) then
        Console:clear()
    -- NIGHT overlay toggle
    elseif tableContains(Commands["night"], args[1]) then
        if table.getn(args) ~= 2 then
            Commands:throwIncorrectUsage(args[1])
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
            Commands:throwIncorrectUsage(args[1])
        end
    -- CUT tree command
    elseif tableContains(Commands["cut"], args[1]) then
        if table.getn(args) == 1 then
            args[2] = "1"
        end
        
        if table.getn(args) == 2 then
            local reps = tonumber(args[2])
            if reps == nil then
                Commands:throwIncorrectUsage(args[1])
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
    -- CATALOG command
    elseif tableContains(Commands["catalog"], args[1]) then
        if table.getn(args) == 1 then
            -- print the catalog
            Console:push("This is the catalog: empty for now")
        else
            Commands:throwIncorrectUsage(args[1])
        end
    else
        Commands:throwUnknownCommand(args[1])
    end
end


-- Commands:throwIncorrectUsage
-- input: string (cmd)
-- output: nil
--   prints a message to console indicating that the command entered is in incorrect format
function Commands:throwIncorrectUsage(cmd)
    local incorrect = "incorrect use of the '" .. cmd .. "' command"
    print(incorrect)
    Console:push(incorrect)
end


-- Commands:throwUnknownCommand
-- input: string (cmd)
-- output: nil
--   prints a message to console indicating that the text entered is not a valid command
function Commands:throwUnknownCommand(cmd)
    if cmd then
        local unknown = "'" .. cmd .. "' is not a valid command"
        print(unknown)
        Console:push(unknown)
    end
end


-- Commands:list
-- input: nil
-- output: nil
--   pushes to console all of the available text commands and their aliases
function Commands:list()
    for k in pairs(Commands) do
        -- pulls only *commands* from the Commands table (non-function table elements that
        -- themselves have a 'usage' element)
        if (type(Commands[k]) ~= "function" and Commands[k].usage ~= nil) then
            Console:push(k .. " " .. Commands[k].usage)
            Console:push("  " .. Commands[k].tip)
            Console:push("  aliases: '" .. table.concat(Commands[k], "', '") .. "'")
        end
    end
end


-- DEPRECATED
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
 
-- DEPRECATED
-- toggleBoolean
-- input: boolean (bool)
-- output: boolean
--   switches the state of the given boolean variable
function toggleBoolean(bool)
    return not bool
end

