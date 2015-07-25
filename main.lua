require("lib/lovedebug")
flux = require("lib/flux")
require("levels")

-- =========================================================================================
-- Variables

-- resources
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

-- buttons
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
    },
    back = {
        name = "back",
        x = 15,
        y = 18,
        width = 0,
        height = 0,
        up = nil,
        down = nil,
        wasDown = false,
        isDown = false,
        justPressed = false
    },
    again = {
        name = "again",
        x = 10,
        y = 203,
        width = 0,
        height = 0,
        up = nil,
        down = nil,
        wasDown = false,
        isDown = false,
        justPressed = false
    }
}

-- global variables
global = {
    borderless = false,
    width = 320,
    height = 240,
    scaleBefore = 3,
    volume = 1,
    inGame = false
}

-- settings
settings = {
    debug = false,
    scale = 3,
    fullscreen = false,
    sound = true,
    level = 0
}

transition = {
    red = 88,
    green = 88,
    blue = 88,
    alpha = 0
}

timers = {
    time = 1.0,
    inTransition = false,
    toGame = false,
    toMenu = false,
    exit = false,
    toGameTime = 0,
    toMenuTime = 0,
    exitTime = 0
}

-- =========================================================================================
-- Love2D main functions

function love.load()
    -- load settings
    if not love.filesystem.exists("settings.lua") then love.filesystem.write("settings.lua", table.show(settings, "settings")) end
    settingsChunk = love.filesystem.load("settings.lua")
    settingsChunk()

    -- setup window
    love.graphics.setBackgroundColor(88, 88, 88)
    if settings.fullscreen then
        global.scaleBefore = settings.scale
        settings.scale = 5
    end
    love.window.setMode(global.width * settings.scale, global.height * settings.scale, { fullscreen = settings.fullscreen, borderless = global.borderless })
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    -- math.randomseed(os.time())

    -- load resources
    loadImg("menu", "menu.png")
    loadImg("playUp", "btn_play_up.png")
    loadImg("playDown", "btn_play_down.png")
    loadImg("backUp", "btn_back_up.png")
    loadImg("backDown", "btn_back_down.png")
    loadImg("againUp", "btn_again_up.png")
    loadImg("againDown", "btn_again_down.png")
    loadImg("board", "board.png")

    loadBgm("music", "music.mp3")
    loadSfx("meta", "metamorph.ogg")
    loadSfx("phase", "phase.ogg")
    loadSfx("select_0", "select_0.ogg")
    loadSfx("select_1", "select_1.ogg")
    loadSfx("select_2", "select_2.ogg")
    loadSfx("select_3", "select_3.ogg")
    -- loadFont("font", "DejaVuSans.ttf", 20)
    loadRes()

    -- setup objects
    button.play.up = res.img.playUp
    button.play.down = res.img.playDown
    button.play.width = button.play.up:getWidth()
    button.play.height = button.play.up:getHeight()
    button.play.x = global.width / 2 - (button.play.up:getWidth() / 2)
    button.play.y = global.height * 3 / 4 - (button.play.down:getHeight() / 2)
    button.back.up = res.img.backUp
    button.back.down = res.img.backDown
    button.back.width = button.back.up:getWidth()
    button.back.height = button.back.up:getHeight()
    button.again.up = res.img.againUp
    button.again.down = res.img.againDown
    button.again.width = button.again.up:getWidth()
    button.again.height = button.again.up:getHeight()

    if settings.sound then res.bgm.music:play() end
end

-- -------------------------------------------------------------

function love.update(dt)
    flux.update(dt)

    if not timers.inTransition then
        if global.inGame then
            updateGame(dt)
        else
            updateMenu(dt)
        end
    end

    updateTimers(dt)
end

-- -------------------------------------------------------------

function updateGame(dt)
    button.back.justPressed = false
    if button.back.wasDown and not button.back.isDown then
        button.back.isDown = false
        button.back.wasDown = false
        button.back.justPressed = true
        timers.inTransition = true
        timers.toMenu = true
        startTransition()
    end
    button.back.wasDown = button.back.isDown

    button.again.justPressed = false
    if button.again.wasDown and not button.again.isDown then
        button.again.isDown = false
        button.again.wasDown = false
        button.again.justPressed = true
    end
    button.again.wasDown = button.again.isDown

    if button.back.justPressed then res.sfx.select_1:play() end
    if button.again.justPressed then res.sfx.select_3:play() end
end

-- -------------------------------------------------------------

function updateMenu(dt)
    button.play.justPressed = false
    if button.play.wasDown and not button.play.isDown then
        button.play.isDown = false
        button.play.wasDown = false
        button.play.justPressed = true
        timers.inTransition = true
        timers.toGame = true
        startTransition()
    end
    button.play.wasDown = button.play.isDown

    if button.play.justPressed then res.sfx.select_2:play() end
end

-- -------------------------------------------------------------

function updateTimers(dt)
    if timers.exit then
        res.bgm.music:setVolume(global.volume)
        timers.exitTime = timers.exitTime + dt
        if timers.exitTime > timers.time then
            timers.exitTime = 0
            timers.exit = false
            timers.inTransition = false
            love.event.push("quit")
        end
    elseif timers.toGame then
        timers.toGameTime = timers.toGameTime + dt

        if timers.toGameTime > timers.time / 2 then
            global.inGame = true
        end

        if timers.toGameTime > timers.time then
            timers.toGameTime = 0
            timers.toGame = false
            timers.inTransition = false
        end
    elseif timers.toMenu then
        timers.toMenuTime = timers.toMenuTime + dt

        if timers.toMenuTime > timers.time / 2 then
            global.inGame = false
        end

        if timers.toMenuTime > timers.time then
            timers.toMenuTime = 0
            timers.toMenu = false
            timers.inTransition = false
        end
    end
end

-- -------------------------------------------------------------

function love.draw(dt)
    if global.inGame then
        love.graphics.draw(res.img.board, 0, 0, 0, settings.scale, settings.scale)

        if button.back.isDown then
            love.graphics.draw(button.back.down, button.back.x * settings.scale, button.back.y * settings.scale, 0, settings.scale, settings.scale)
        else
            love.graphics.draw(button.back.up, button.back.x * settings.scale, button.back.y * settings.scale, 0, settings.scale, settings.scale)
        end

        if button.again.isDown then
            love.graphics.draw(button.again.down, button.again.x * settings.scale, button.again.y * settings.scale, 0, settings.scale, settings.scale)
        else
            love.graphics.draw(button.again.up, button.again.x * settings.scale, button.again.y * settings.scale, 0, settings.scale, settings.scale)
        end
    else
        love.graphics.draw(res.img.menu, 0, 0, 0, settings.scale, settings.scale)

        if button.play.isDown then
            love.graphics.draw(button.play.down, button.play.x * settings.scale, button.play.y * settings.scale, 0, settings.scale, settings.scale)
        else
            love.graphics.draw(button.play.up, button.play.x * settings.scale, button.play.y * settings.scale, 0, settings.scale, settings.scale)
        end
    end

    if timers.inTransition then
        drawTransition()
    end

    if settings.debug then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 5, 5)
        if global.inGame then
            love.graphics.print("isPlayDown: " .. tostring(button.play.isDown), 5, 20)
            love.graphics.print("playJustPressed: " .. tostring(button.play.justPressed), 5, 35)
        end
        love.graphics.setColor(255, 255, 255, 255)
    end
end

-- -------------------------------------------------------------

function startTransition()
    flux.to(transition, 0.5, { alpha = 255 }):after(transition, 0.5, { alpha = 0 })
end

function exitTransition()
    flux.to(transition, 1, { red = 0, green = 0, blue = 0, alpha = 255 })
end

function drawTransition()
    love.graphics.setColor(transition.red, transition.green, transition.blue, transition.alpha)
    love.graphics.rectangle("fill", 0, 0, global.width * settings.scale, global.height * settings.scale)
    love.graphics.setColor(255, 255, 255, 255)
end

-- -------------------------------------------------------------

function love.keypressed(k)
    if not timers.toGame and not timers.toMenu then
        -- scale window up
        if k == "+" then
            if not settings.fullscreen and settings.scale < 5 then
                settings.scale = settings.scale + 1
                love.window.setMode(global.width * settings.scale, global.height * settings.scale, { fullscreen = settings.fullscreen, borderless = global.borderless })
            end
            return
        end

        -- scale window down
        if k == "-" then
            if not settings.fullscreen and settings.scale > 1 then
                settings.scale = settings.scale - 1
                love.window.setMode(global.width * settings.scale, global.height * settings.scale, { fullscreen = settings.fullscreen, borderless = global.borderless })
            end
            return
        end

        -- toggle fullscreen
        if k == "return" and love.keyboard.isDown("lalt", "ralt", "alt") then
            settings.fullscreen = not settings.fullscreen
            if settings.fullscreen then
                global.scaleBefore = settings.scale
                settings.scale = 5
            else
                settings.scale = global.scaleBefore
            end
            love.window.setMode(global.width * settings.scale, global.height * settings.scale, { fullscreen = settings.fullscreen, borderless = global.borderless })
        end
    end
end

-- -------------------------------------------------------------

function love.keyreleased(k)
    if not timers.toGame and not timers.toMenu then
        -- quit the game
        if k == "escape" then
            if global.inGame then
                timers.inTransition = true
                timers.toMenu = true
                startTransition()
                res.sfx.select_1:play()
            else
                res.sfx.select_0:play()
                timers.inTransition = true
                timers.exit = true
                flux.to(global, 1, { volume = 0 })
                exitTransition()
            end
            return
        end
    end
end

-- -------------------------------------------------------------

function love.mousepressed(x, y, b)
    if global.inGame then
        if b == "l" then
            if not timers.toMenu and boxHit(x, y, button.back.x * settings.scale, button.back.y * settings.scale, button.back.width * settings.scale, button.back.height * settings.scale) then
                button.back.isDown = true
            end

            if boxHit(x, y, button.again.x * settings.scale, button.again.y * settings.scale, button.again.width * settings.scale, button.again.height * settings.scale) then
                button.again.isDown = true
            end
        end
    else
        if b == "l" then
            if not timers.toGame and boxHit(x, y, button.play.x * settings.scale, button.play.y * settings.scale, button.play.width * settings.scale, button.play.height * settings.scale) then
                button.play.isDown = true
            end
        end
    end
end

-- -------------------------------------------------------------

function love.mousereleased(x, y, b)
    if global.inGame then
        if b == "l" then
            if not timers.toMenu and button.back.isDown then button.back.isDown = false end
            if not timers.reset and button.again.isDown then button.again.isDown = false end
        end
    else
        if b == "l" then
            if not timers.toGame and button.play.isDown then button.play.isDown = false end
        end
    end
end

-- -------------------------------------------------------------

function love.mousemoved(x, y, dx, dy) end

-- -------------------------------------------------------------

function love.quit()
    if settings.fullscreen then settings.scale = global.scaleBefore end
    love.filesystem.write("settings.lua", table.show(settings, "settings"))
end

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
        res.fnt[name] = love.graphics.newFont(res.dir .. "fonts/" .. pair[1], pair[2])
        res.fntQueue[name] = nil
    end

    for name, src in pairs(res.imgQueue) do
        res.img[name] = love.graphics.newImage(res.dir .. "img/" .. src)
        res.imgQueue[name] = nil
    end

    for name, src in pairs(res.bgmQueue) do
        res.bgm[name] = love.audio.newSource(res.dir .. "bgm/" .. src)
        res.bgm[name]:setLooping(true)
        res.bgmQueue[name] = nil
    end

    for name, src in pairs(res.sfxQueue) do
        res.sfx[name] = love.audio.newSource(res.dir .. "sfx/" .. src)
        res.sfx[name]:setLooping(false)
        res.sfxQueue[name] = nil
    end
end

-- =========================================================================================
-- Table to string

function table.show(t, name, indent)
    local cart -- a container
    local autoref -- for self references

    --[[ counts the number of elements in a table
    local function tablecount(t)
        local n = 0
        for _, _ in pairs(t) do n = n+1 end
        return n
    end
    ]]

    -- (RiciLake) returns true if the table is empty
    local function isemptytable(t) return next(t) == nil end

    local function basicSerialize(o)
        local so = tostring(o)
        if type(o) == "function" then
            local info = debug.getinfo(o, "S")
            -- info.name is nil because o is not a calling level
            if info.what == "C" then
                return string.format("%q", so .. ", C function")
            else
                -- the information is defined through lines
                return string.format("%q", so .. ", defined in (" .. info.linedefined .. "-" .. info.lastlinedefined .. ")" .. info.source)
            end
        elseif type(o) == "number" or type(o) == "boolean" then
            return so
        else
            return string.format("%q", so)
        end
    end

    local function addtocart(value, name, indent, saved, field)
        indent = indent or ""
        saved = saved or {}
        field = field or name

        cart = cart .. indent .. field

        if type(value) ~= "table" then
            cart = cart .. " = " .. basicSerialize(value) .. ";\n"
        else
            if saved[value] then
                cart = cart .. " = {}; -- " .. saved[value] .. " (self reference)\n"
                autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
            else
                saved[value] = name
                --if tablecount(value) == 0 then
                if isemptytable(value) then
                    cart = cart .. " = {};\n"
                else
                    cart = cart .. " = {\n"
                    for k, v in pairs(value) do
                        k = basicSerialize(k)
                        local fname = string.format("%s[%s]", name, k)
                        field = string.format("[%s]", k)
                        -- three spaces between levels
                        addtocart(v, fname, indent .. "   ", saved, field)
                    end
                    cart = cart .. indent .. "};\n"
                end
            end
        end
    end

    name = name or "__unnamed__"

    if type(t) ~= "table" then
        return name .. " = " .. basicSerialize(t)
    end

    cart, autoref = "", ""
    addtocart(t, name, indent)
    return cart .. autoref
end

-- =========================================================================================
-- Debug level formatting

function printLevel(num)
    print("Level 1:")
    for i = 1, 6 do
        print("Pod " .. i - 1 .. ":")
        print("Links:")
        for j = 1, 6 do
            print("pos(" .. i .. ", " .. j .. ") = " .. levels[num].links[i][j])
        end
        print("Pos: " .. levels[num].pos[i])
    end
end
