-- intro

require("menu")
require("util/gamestate")
require("util/resources")

Intro = class("Intro", GameState)

timer = 0
time = 3

function Intro:update(dt)
    timer = timer + dt
    if timer >= time then
        goToMenu()
    end
end

function Intro:draw(dt)
    love.graphics.setBackgroundColor(50, 50, 50)
    love.graphics.clear()
    love.graphics.draw(resources.images.author, love.graphics.getWidth() / 2 - (resources.images.author:getWidth() / 2), love.graphics.getHeight() / 2 - (resources.images.author:getHeight() / 2))
end

function Intro:keypressed(k)
    if k == "escape" then
        love.event.push("quit")
    else
        goToMenu()
    end
end

function goToMenu()
    menu = Menu()
    stack:switch(menu)
end
