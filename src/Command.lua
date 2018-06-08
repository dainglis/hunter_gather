-- Command.lua
-- Contains functions and tables for console commands

close = {"close", "quit", "exit"}
reset = {"reset", "clear"}
cut = {"cut"}
time = {"time"}

function promptCommand(cmd)
    if tableContains(reset, cmd) then
        init()
    elseif tableContains(close, cmd) then
        w.close()
    elseif tableContains(time, cmd) then
        --        toggleNight()

    end
end

