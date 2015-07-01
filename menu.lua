-- main menu

require("util/gamestate")
require("util/resources")

Menu = class("Menu", GameState)

function Menu:update(dt)

end

function Menu:draw(dt)

end

function Menu:keypressed(k)
    if k == "escape" then
        stack:pop()
    end
end
