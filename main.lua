-- =========================================================================================
-- Variables

debug = false

window = {
    originalWidth = 320,
    originalHeight = 240,
    scale = 1
}

res = {
    dir = "assets/",
    imgQueue = { },
    bgmQueue = { },
    sfxQueue = { },
    fntQueue = { },
    img = { },
    bgm = { },
    sfx = { },
    fnt = { }
}

game_vars = { }

levels = { }

-- =========================================================================================
-- Love2D main functions

function love.load()
    love.window.setMode(window.originalWidth * window.scale, window.originalHeight * window.scale)

    math.randomseed(os.time())

    loadImg("menu", "menu.png")
    loadBgm("bgm", "bgm.mp3")
    -- loadFont("font", "DejaVuSans.ttf", 20)
    loadRes()

    res.bgm.bgm:play()
end

-- -------------------------------------------------------------

function love.update(dt) end

-- -------------------------------------------------------------

function love.draw(dt)
    love.graphics.draw(res.img.menu, 0, 0)

    if debug then
        love.graphics.print("FPS: " .. love.timer.getFPS(), 5, 5)
    end
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
            love.window.setMode(window.originalWidth * window.scale, window.originalHeight * window.scale)
        end
        return
    end

    -- scale window down
    if k == "-" then
        if window.scale > 1 then
            window.scale = window.scale - 1
            love.window.setMode(window.originalWidth * window.scale, window.originalHeight * window.scale)
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
    res.fntQueue[name] = { src, size }
end

-- -------------------------------------------------------------

function loadImg(name, src)
    res.imgQueue[name] = src
end

-- -------------------------------------------------------------

function loadBgm(name, src)
    res.bgmQueue[name] = src
end

-- -------------------------------------------------------------

function loadSfx(name, src)
    res.sfxQueue[name] = src
end

-- -------------------------------------------------------------

function loadRes(threaded)
    for name, pair in pairs(res.fntQueue) do
        res.fnt[name] = love.graphics.newFont(res.dir .. pair[1], pair[2])
        res.fntQueue[name] = nil
    end

    for name, src in pairs(res.imgQueue) do
        res.img[name] = love.graphics.newImage(res.dir .. src)
        res.imgQueue[name] = nil
    end

    for name, src in pairs(res.bgmQueue) do
        res.bgm[name] = love.audio.newSource(res.dir .. src)
        res.bgm[name]:setLooping(true)
        res.bgmQueue[name] = nil
    end

    for name, src in pairs(res.sfxQueue) do
        res.sfx[name] = love.audio.newSource(res.dir .. src)
        res.bgm[name]:setLooping(false)
        res.sfxQueue[name] = nil
    end
end

-- =========================================================================================
