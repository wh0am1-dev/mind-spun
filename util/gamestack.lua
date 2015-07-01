-- gamestack

require("util/helper")

GameStack = class("GameStack")

function GameStack:__init()
    self.states = {}
end

function GameStack:current()
    if #self.states > 0 then
        return self.states[#self.states]
    else
        return nil
    end
end

function GameStack:push(state)
    if self:current() then self:current():stop() end
    table.insert(self.states, state)
    self:current():start()
end

function GameStack:pop()
    if not self:current() then return end
    self:current():stop()
    table.remove(self.states, #self.states)
    if self:current() then
        self:current():start()
    else
        love.event.quit()
    end
end

function GameStack:switch(state)
    if not self:current() then return end
    self:current():stop()
    table.remove(self.states, #self.states)
    table.insert(self.states, state)
    self:current():start()
end

function GameStack:update(dt)
    if self:current() then self:current():update(dt) end
end

function GameStack:draw(dt)
    if self:current() then self:current():draw(dt) end
end

function GameStack:keypressed(k)
    if self:current() then self:current():keypressed(k) end
end

function GameStack:keyreleased(k)
    if self:current() then self:current():keyreleased(k) end
end

function GameStack:mousepressed(x, y, button)
    if self:current() then self:current():mousepressed(x, y, button) end
end

function GameStack:mousereleased(x, y, button)
    if self:current() then self:current():mousereleased(x, y, button) end
end

function GameStack:mousemoved(x, y, dx, dy)
    if self:current() then self:current():mousemoved(x, y, dx, dy) end
end
