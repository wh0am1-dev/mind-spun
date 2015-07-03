require("lib/lovedebug")
flux = require("lib/flux")

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
    }
}

-- global variables
global = {
    width = 320,
    height = 240,
    scaleBefore = 3,
    inGame = false
}

-- settings
settings = {
    debug = false,
    scale = 3,
    fullscreen = false,
    sound = false
}

timers = {
    time = 0.5,
    toGame = false,
    toMenu = false,
    toGameTime = 0,
    toMenuTime = 0
}

levels = { }

-- =========================================================================================
-- Love2D main functions

function love.load()
    -- load settings
    print("exists settings.lua? >>> " .. tostring(love.filesystem.exists("settings.lua")))
    print("settings:\n" .. table.show(settings, "settings"))
    if not love.filesystem.exists("settings.lua") then love.filesystem.write("settings.lua", table.show(settings, "settings")) end
    settingsChunk = love.filesystem.load("settings.lua")
    settingsChunk()

    -- setup window
    love.graphics.setBackgroundColor(88, 88, 88)
    if settings.fullscreen then
        global.scaleBefore = settings.scale
        settings.scale = 5
    end
    love.window.setMode(global.width * settings.scale, global.height * settings.scale, { fullscreen = settings.fullscreen, borderless = true })
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    -- math.randomseed(os.time())

    -- load resources
    loadImg("menu", "menu.png")
    loadImg("playUp", "btn_play_up.png")
    loadImg("playDown", "btn_play_down.png")
    loadImg("board", "board.png")
    loadBgm("music", "music.mp3")
    -- loadFont("font", "DejaVuSans.ttf", 20)
    loadRes()

    -- setup objects
    button.play.up = res.img.playUp
    button.play.down = res.img.playDown
    button.play.width = button.play.up:getWidth()
    button.play.height = button.play.up:getHeight()
    button.play.x = global.width / 2 - (button.play.up:getWidth() / 2)
    button.play.y = global.height * 3 / 4 - (button.play.down:getHeight() / 2)

    if settings.sound then res.bgm.music:play() end
end

-- -------------------------------------------------------------

function love.update(dt)
    if global.inGame then
        -- game
    else
        if button.play.wasDown and not button.play.isDown then
            button.play.isDown = false
            button.play.wasDown = false
            button.play.justPressed = false
            timers.toGame = true
        end
        button.play.wasDown = button.play.isDown
    end

    if timers.toGame then
        timers.toGameTime = timers.toGameTime + dt
        if timers.toGameTime > timers.time then
            timers.toGameTime = 0
            timers.toGame = false
            global.inGame = true
        end
    elseif timers.toMenu then
        timers.toMenuTime = timers.toMenuTime + dt
        if timers.toMenuTime > timers.time then
            timers.toMenuTime = 0
            timers.toMenu = false
            global.inGame = false
        end
    end
end

-- -------------------------------------------------------------

function love.draw(dt)
    if global.inGame then
        love.graphics.draw(res.img.board, 0, 0, 0, settings.scale, settings.scale)
    else
        love.graphics.draw(res.img.menu, 0, 0, 0, settings.scale, settings.scale)

        if button.play.isDown then
            love.graphics.draw(button.play.down, button.play.x * settings.scale, button.play.y * settings.scale, 0, settings.scale, settings.scale)
        else
            love.graphics.draw(button.play.up, button.play.x * settings.scale, button.play.y * settings.scale, 0, settings.scale, settings.scale)
        end
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

function love.keypressed(k)
    if not timers.toGame and not timers.toMenu then
        -- scale window up
        if k == "+" then
            if not settings.fullscreen and settings.scale < 5 then
                settings.scale = settings.scale + 1
                love.window.setMode(global.width * settings.scale, global.height * settings.scale, { fullscreen = settings.fullscreen, borderless = true })
            end
            return
        end

        -- scale window down
        if k == "-" then
            if not settings.fullscreen and settings.scale > 1 then
                settings.scale = settings.scale - 1
                love.window.setMode(global.width * settings.scale, global.height * settings.scale, { fullscreen = settings.fullscreen, borderless = true })
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
            love.window.setMode(global.width * settings.scale, global.height * settings.scale, { fullscreen = settings.fullscreen, borderless = true })
        end
    end
end

-- -------------------------------------------------------------

function love.keyreleased(k)
    if not timers.toGame and not timers.toMenu then
        -- quit the game
        if k == "escape" then
            if global.inGame then
                timers.toMenu = true
            else
                love.event.push("quit")
            end
            return
        end
    end
end

-- -------------------------------------------------------------

function love.mousepressed(x, y, b)
    if global.inGame then
        -- game
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
        -- game
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
