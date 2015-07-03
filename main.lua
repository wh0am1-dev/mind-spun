require("lib/lovedebug")
flux = require("lib/flux")

-- =========================================================================================
-- Variables

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

button = {
    play = {
        name = "play",
        x = 0,
        y = 0,
        width = 0,
        height = 0,
        up = nil,
        down = nil,
        wasDown = false,
        isDown = false,
        justPressed = false
    }
}

global = {
    debug = false,
    width = 320,
    height = 240,
    scaleBefore = 3,
    scale = 3,
    fullscreen = false,
    inMenu = true
}

levels = { }

-- =========================================================================================
-- Love2D main functions

function love.load()
    love.window.setMode(global.width * global.scale, global.height * global.scale)
    love.graphics.setDefaultFilter("nearest", "nearest", 0)

    math.randomseed(os.time())

    loadImg("menuBack", "menu.png")
    loadImg("btnPlayUp", "btn_play_up.png")
    loadImg("btnPlayDown", "btn_play_down.png")
    loadBgm("menu", "menu.mp3")
    -- loadFont("font", "DejaVuSans.ttf", 20)
    loadRes()

    button.play.up = res.img.btnPlayUp
    button.play.down = res.img.btnPlayDown
    button.play.width = button.play.up:getWidth()
    button.play.height = button.play.up:getHeight()
    button.play.x = global.width / 2 - (button.play.up:getWidth() / 2)
    button.play.y = global.height * 3 / 4 - (button.play.down:getHeight() / 2)

    res.bgm.menu:play()
end

-- -------------------------------------------------------------

function love.update(dt)
    for key, btn in pairs(button) do
        if btn.wasDown and not btn.isDown then btn.justPressed = true end
        btn.wasDown = btn.isDown
    end
end

-- -------------------------------------------------------------

function love.draw(dt)
    if global.inMenu then
        love.graphics.draw(res.img.menuBack, 0, 0, 0, global.scale, global.scale)

        if button.play.isDown then
            love.graphics.draw(button.play.down, button.play.x * global.scale, button.play.y * global.scale, 0, global.scale, global.scale)
        else
            love.graphics.draw(button.play.up, button.play.x * global.scale, button.play.y * global.scale, 0, global.scale, global.scale)
        end
    else

    end

    if global.debug then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 5, 5)
        love.graphics.print("isPlayDown: " .. tostring(button.play.isDown), 5, 20)
        love.graphics.print("playJustPressed: " .. tostring(button.play.justPressed), 5, 35)
        love.graphics.setColor(255, 255, 255, 255)
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
        if not global.fullscreen and global.scale < 5 then
            global.scale = global.scale + 1
            love.window.setMode(global.width * global.scale, global.height * global.scale)
        end
        return
    end

    -- scale window down
    if k == "-" then
        if not global.fullscreen and global.scale > 1 then
            global.scale = global.scale - 1
            love.window.setMode(global.width * global.scale, global.height * global.scale)
        end
        return
    end

    -- toggle fullscreen
    if k == "return" and love.keyboard.isDown("lalt", "ralt", "alt") then
        global.fullscreen = not global.fullscreen
        if global.fullscreen then
            global.scaleBefore = global.scale
            global.scale = 5
        else
            global.scale = global.scaleBefore
        end
        love.window.setMode(global.width * global.scale, global.height * global.scale, { fullscreen = global.fullscreen })
    end
end

-- -------------------------------------------------------------

function love.mousepressed(x, y, b)
    if b == "l" then
        for key, btn in pairs(button) do
            if boxHit(x, y, btn.x * global.scale, btn.y * global.scale, btn.width * global.scale, btn.height * global.scale) then
                btn.isDown = true
            end
        end
    end
end

-- -------------------------------------------------------------

function love.mousereleased(x, y, b)
    if b == "l" then
        for key, btn in pairs(button) do
            if btn.isDown then btn.isDown = false end
        end
    end
end

-- -------------------------------------------------------------

function love.keyreleased(k) end
function love.mousemoved(x, y, dx, dy) end
function love.quit() end

-- =========================================================================================
-- Is mouse on box ?

function boxHit(mx, my, x, y, w, h)
    return mx > x and mx < x + w and my > y and my < y + h
end

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
