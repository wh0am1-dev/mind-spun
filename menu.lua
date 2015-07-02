-- main menu

require("util/gamestate")
require("util/resources")

Menu = class("Menu", GameState)

function Menu:update(dt)

end

function Menu:draw(dt)
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.clear()
end

function Menu:keypressed(k)
    if k == "escape" then
        stack:pop()
    end

    if k == "n" then
        if scale > 1 then
            scale = scale - 1
            love.window.setMode(320 * scale, 240 * scale)
        end
    elseif k == "m" then
        if scale < 5 then
            scale = scale + 1
            love.window.setMode(320 * scale, 240 * scale)
        end
    end
end
