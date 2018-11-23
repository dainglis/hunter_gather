-- Console.lua
-- Contains definition and methods for the Console object and ConsoleWindow object

Console = {text = "", memory = {}, PROMPT = "$ "}
ConsoleWindow = {x = 0, y = 0, width = 0, height = 0, OFFSET = {X = 6, Y = 16, L = 15} }

CONSOLE = "console"

-- ConsoleWindow:new
--   ConsoleWindow constructor
-- input: number (x), number (y), number (width), number (height)
-- output: ConsoleWindow
--   returns a new ConsoleWindow object
function ConsoleWindow:new(x, y, width, height)
    local obj = {x=x, y=y, width=width, height=height}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- ConsoleWindow:setPosition
-- input: number (x), number (y)
-- output: nil
--   sets the x and y values of the ConsoleWindow object
function ConsoleWindow:setPosition(x, y)
    self.x = x
    self.y = y
end

-- ConsoleWindow:setSize
-- input: number (w), number (h)
-- output: nil
--   sets the width and height of the ConsoleWindow object
function ConsoleWindow:setSize(w, h)
    self.width = w
    self.height = h
end

function ConsoleWindow:resize()
    self:setPosition(20, 724) -- MAGIC NUMBERS = BAD
    self:setSize(480, self.OFFSET.Y + self.OFFSET.X)
    for i = 1, table.getn(Console.memory) do
        self:setPosition(self.x, self.y - 15)
        self:setSize(self.width, self.height + 15)
    end
end

function ConsoleWindow:draw()
    self:resize()

    g.setColor(cConsoleBackground)
    g.rectangle('fill', self.x, self.y, self.width, self.height)
    g.setColor(cWhite)
    g.rectangle('line', self.x, self.y, self.width, self.height)

    g.print(Console.PROMPT .. Console.text,
            self.x + self.OFFSET.X, 
            self.y + self.height - self.OFFSET.Y)
    for i = 1, Console:memSize() do
        g.print(Console.memory[i], 
                self.x + self.OFFSET.X,
                self.y + self.height - self.OFFSET.Y - (15 * i))
    end
end

-- Console:init
-- input: nil
-- output: nil
--   executed at load time to initialize the static Console object into a working state
function Console:init()
    self.text = ""
    if self.memory == nil then
        self.memory = {}
    end
    ConsoleWindow:resize()
end

-- Console:append
-- input: string (text)
-- output: nil
--   appends the given string to the Console objects text field
function Console:append(text)
    self.text = self.text .. text
end

function Console:push(text)
    table.insert(self.memory, 1, text)
end

-- Console:length()
-- input: nil
-- output: integer
--   returns the length of the 'text' field string
function Console:length()
    local length = string.len(self.text)
    return length
end

function Console:memSize()
    return table.getn(self.memory)
end

-- Console:clerText
-- input: nil
-- output: nil
--   sets the Console objects 'text' field to the empty string
function Console:clearText()
    self.text = ""
end

-- Console:backspace
-- input: nil
-- output: nil
--   removes the last character from the Console objects 'text' string
function Console:backspace()
    Console.text = string.sub(Console.text, 1, -2)
end

-- Console:clear
-- input: nil
-- output: nil
--   clears all lines of memory from the console
function Console:clear()
    while Console:memSize() > 0 do
        table.remove(Console.memory)
    end
end
