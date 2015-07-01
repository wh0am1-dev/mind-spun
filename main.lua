require("intro")
require("util/resources")
require("util/gamestack")

resources = Resources("assets/")

function reset()
    -- start game
    intro = Intro()
    stack = GameStack()
    stack:push(intro)
end

function love.load()
    math.randomseed(os.time())

    -- load images
    resources:addImage("author", "author.png")
    -- load fonts
    resources:addFont("tiny", "DejaVuSans.ttf", 10)
    -- load music
    -- resources:addMusic("background", "background.mp3")
    resources:load()

    reset()
end

function love.update(dt)
    stack:update(dt)
end

function love.draw(dt)
    stack:draw(dt)

    love.graphics.setFont(resources.fonts.tiny)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 5, 5)
end

function love.keypressed(k)
    stack:keypressed(k)
end

function love.keyreleased(k)
    stack:keyreleased(k)
end

function love.mousepressed(x, y, button)
    stack:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    stack:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    stack:mousemoved(x, y, dx, dy)
end

function love.quit()
end
