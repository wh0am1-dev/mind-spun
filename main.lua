-- =========================================================================================
-- Variables

window = {
    original_width = 320,
    original_height = 240,
    scale = 3
}

assets = {
    dir = "assets/",
    imageQueue = { },
    musicQueue = { },
    fontQueue = { },
    images = { },
    music = { },
    fonts = { }
}

game_vars = { }

levels = { }

-- =========================================================================================
-- Love2D main functions

function love.load()
    love.window.setMode(window.original_width * window.scale, window.original_height * window.scale)

    math.randomseed(os.time())

    loadImage("menu", "menu.png")
    -- loadFont("font", "DejaVuSans.ttf", 20)
    -- loadMusic("background", "background.mp3")
    loadResources()
end

-- -------------------------------------------------------------

function love.update(dt) end

-- -------------------------------------------------------------

function love.draw(dt)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 5, 5)
end

-- -------------------------------------------------------------

function love.keypressed(k)
    -- quit the game
    if k == "escape" then
        love.event.push("quit")
        return
    end

    -- scale window up
    if k == "+" then
        if window.scale < 5 then
            window.scale = window.scale + 1
            love.window.setMode(window.original_width * window.scale, window.original_height * window.scale)
        end
        return
    end

    -- scale window down
    if k == "-" then
        if window.scale > 1 then
            window.scale = window.scale - 1
            love.window.setMode(window.original_width * window.scale, window.original_height * window.scale)
        end
        return
    end
end

-- -------------------------------------------------------------

function love.keyreleased(k) end
function love.mousepressed(x, y, button) end
function love.mousereleased(x, y, button) end
function love.mousemoved(x, y, dx, dy) end
function love.quit() end

-- =========================================================================================
-- Assets management

function loadFont(name, src, size)
    assets.fontQueue[name] = { src, size }
end

-- -------------------------------------------------------------

function loadImage(name, src)
    assets.imageQueue[name] = src
end

-- -------------------------------------------------------------

function loadMusic(name, src)
    assets.musicQueue[name] = src
end

-- -------------------------------------------------------------

function loadResources(threaded)
    for name, pair in pairs(assets.fontQueue) do
        assets.fonts[name] = love.graphics.newFont(assets.dir .. pair[1], pair[2])
        assets.fontQueue[name] = nil
    end

    for name, src in pairs(assets.imageQueue) do
        assets.images[name] = love.graphics.newImage(assets.dir .. src)
        assets.imageQueue[name] = nil
    end

    for name, src in pairs(assets.musicQueue) do
        assets.music[name] = love.audio.newSource(assets.dir .. src)
        assets.musicQueue[name] = nil
    end
end

-- =========================================================================================
