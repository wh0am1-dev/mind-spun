require("lib/lovedebug")
flux = require("lib/flux")
require("levels")

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
    },
    info = {
        name = "info",
        x = 9,
        y = 221,
        width = 0,
        height = 0,
        up = nil,
        down = nil,
        wasDown = false,
        isDown = false,
        justPressed = false
    },
    exit = {
        name = "exit",
        x = 283,
        y = 221,
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

tokens = {
    { -- 1
        pos = 2,
        img = nil,
        x = 0,
        y = 0
    }, { -- 2
        pos = 3,
        img = nil,
        x = 0,
        y = 0
    }, { -- 3
        pos = 4,
        img = nil,
        x = 0,
        y = 0
    }, { -- 4
        pos = 5,
        img = nil,
        x = 0,
        y = 0
    }, { -- 5
        pos = 6,
        img = nil,
        x = 0,
        y = 0
    },
    moving = 0
}

paths = { }
moves = { }

cells = {
    { x = 189, y = 207, size = 25, move = false },
    { x = 102, y = 158, size = 25, move = false },
    { x = 102, y = 57, size = 25, move = false },
    { x = 189, y = 8, size = 25, move = false },
    { x = 275, y = 57, size = 25, move = false },
    { x = 275, y = 158, size = 25, move = false }
}

spots = {
    { x = 192, y = 210 },
    { x = 105, y = 161 },
    { x = 105, y = 60 },
    { x = 192, y = 11 },
    { x = 278, y = 60 },
    { x = 278, y = 161 },
    free = 1,
    freeTemp = 0
}

centers = {
    { x = 201, y = 219 },
    { x = 114, y = 170 },
    { x = 114, y = 69 },
    { x = 201, y = 20 },
    { x = 287, y = 69 },
    { x = 287, y = 170 }
}

global = {
    debug = false,
    borderless = false,
    width = 320,
    height = 240,
    screenWidth = 0,
    screenHeight = 0,
    fullscreenScale = 1,
    scaleBefore = 2,
    volume = 1,
    inGame = false,
    inCredits = false,
    easing = "backout"
}

settings = {
    scale = 2,
    fullscreen = false,
    sound = true,
    level = 1
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
    resetting = false,
    toGame = false,
    toMenu = false,
    toCredits = false,
    exit = false,
    resetTime = 0,
    toGameTime = 0,
    toMenuTime = 0,
    toCreditsTime = 0,
    exitTime = 0
}

-- =========================================================================================
-- Love2D main functions

function love.load()
    -- load settings
    if not love.filesystem.exists("data.bin") then love.filesystem.write("data.bin", table.show(settings, "settings")) end
    settingsChunk = love.filesystem.load("data.bin")
    settingsChunk()

    -- setup window
    love.window.setMode(0, 0, { fullscreen = false })
    global.screenWidth = love.graphics.getWidth()
    global.screenHeight = love.graphics.getHeight()
    while global.fullscreenScale < 5 and global.width * (global.fullscreenScale + 1) < global.screenWidth and global.height * (global.fullscreenScale + 1) < global.screenHeight do
        global.fullscreenScale = global.fullscreenScale + 1
    end
    love.graphics.setBackgroundColor(88, 88, 88)
    if settings.fullscreen then
        global.scaleBefore = settings.scale
        settings.scale = global.fullscreenScale
    end
    love.window.setMode(global.width * settings.scale, global.height * settings.scale, { fullscreen = settings.fullscreen, borderless = global.borderless })
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    -- math.randomseed(os.time())

    -- load resources
    loadImg("menu", "menu.png")
    loadImg("credits", "credits.png")
    loadImg("playUp", "btn_play_up.png")
    loadImg("playDown", "btn_play_down.png")
    loadImg("infoUp", "btn_info_up.png")
    loadImg("infoDown", "btn_info_down.png")
    loadImg("exitUp", "btn_exit_up.png")
    loadImg("exitDown", "btn_exit_down.png")
    loadImg("backUp", "btn_back_up.png")
    loadImg("backDown", "btn_back_down.png")
    loadImg("againUp", "btn_again_up.png")
    loadImg("againDown", "btn_again_down.png")
    loadImg("game", "game.png")
    loadImg("board", "board.png")

    loadImg("path_1-2", "path_1-2.png")
    loadImg("path_1-3", "path_1-3.png")
    loadImg("path_1-4", "path_1-4.png")
    loadImg("path_1-5", "path_1-5.png")
    loadImg("path_1-6", "path_1-6.png")
    loadImg("path_2-3", "path_2-3.png")
    loadImg("path_2-4", "path_2-4.png")
    loadImg("path_2-5", "path_2-5.png")
    loadImg("path_2-6", "path_2-6.png")
    loadImg("path_3-4", "path_3-4.png")
    loadImg("path_3-5", "path_3-5.png")
    loadImg("path_3-6", "path_3-6.png")
    loadImg("path_4-5", "path_4-5.png")
    loadImg("path_4-6", "path_4-6.png")
    loadImg("path_5-6", "path_5-6.png")

    loadImg("move_1", "move_1.png")
    loadImg("move_2", "move_2.png")
    loadImg("move_3", "move_3.png")
    loadImg("move_4", "move_4.png")
    loadImg("move_5", "move_5.png")
    loadImg("move_6", "move_6.png")

    loadImg("token_1", "token_1.png")
    loadImg("token_2", "token_2.png")
    loadImg("token_3", "token_3.png")
    loadImg("token_4", "token_4.png")
    loadImg("token_5", "token_5.png")

    loadBgm("music", "music.mp3")
    loadSfx("yaay", "yaay.ogg")
    loadSfx("woosh", "woosh.ogg")
    loadSfx("select_0", "select_0.ogg")
    loadSfx("select_1", "select_1.ogg")
    loadSfx("select_2", "select_2.ogg")
    loadSfx("select_3", "select_3.ogg")

    loadFont("font", "xaba.ttf", 32)
    loadRes()

    -- setup objects
    button.play.up = res.img.playUp
    button.play.down = res.img.playDown
    button.play.width = button.play.up:getWidth()
    button.play.height = button.play.up:getHeight()
    button.play.x = global.width / 2 - (button.play.up:getWidth() / 2)
    button.play.y = global.height * 3 / 4 - (button.play.down:getHeight() / 2) - 10
    button.info.up = res.img.infoUp
    button.info.down = res.img.infoDown
    button.info.width = button.info.up:getWidth()
    button.info.height = button.info.up:getHeight()
    button.exit.up = res.img.exitUp
    button.exit.down = res.img.exitDown
    button.exit.width = button.exit.up:getWidth()
    button.exit.height = button.exit.up:getHeight()
    button.back.up = res.img.backUp
    button.back.down = res.img.backDown
    button.back.width = button.back.up:getWidth()
    button.back.height = button.back.up:getHeight()
    button.again.up = res.img.againUp
    button.again.down = res.img.againDown
    button.again.width = button.again.up:getWidth()
    button.again.height = button.again.up:getHeight()

    tokens[1].img = res.img.token_1
    tokens[2].img = res.img.token_2
    tokens[3].img = res.img.token_3
    tokens[4].img = res.img.token_4
    tokens[5].img = res.img.token_5

    loadLevel()
    love.graphics.setFont(res.fnt.font)
    if settings.sound then res.bgm.music:play() end
end

-- -------------------------------------------------------------

function love.update(dt)
    flux.update(dt)

    if not timers.inTransition then
        if global.inGame then
            if not timers.resetting then
                updateGame(dt)
            end
        elseif global.inCredits then
            updateCredits(dt)
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
        timers.resetting = true
        resetLevel()
        resetTransition()
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

    button.info.justPressed = false
    if button.info.wasDown and not button.info.isDown then
        button.info.isDown = false
        button.info.wasDown = false
        button.info.justPressed = true
        timers.inTransition = true
        timers.toCredits = true
        startTransition()
    end
    button.info.wasDown = button.info.isDown

    button.exit.justPressed = false
    if button.exit.wasDown and not button.exit.isDown then
        button.exit.isDown = false
        button.exit.wasDown = false
        button.exit.justPressed = true
        timers.inTransition = true
        timers.exit = true
        exitTransition()
    end
    button.exit.wasDown = button.exit.isDown

    if button.play.justPressed then res.sfx.select_2:play() end
    if button.info.justPressed then res.sfx.select_2:play() end
    if button.exit.justPressed then res.sfx.select_0:play() end
end

-- -------------------------------------------------------------

function updateCredits(dt)
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

    if button.back.justPressed then res.sfx.select_1:play() end
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
            resetLevel()
            timers.resetting = true
            resetTransition()
        end
    elseif timers.toMenu then
        timers.toMenuTime = timers.toMenuTime + dt

        if timers.toMenuTime > timers.time / 2 then
            global.inGame = false
            global.inCredits = false
        end

        if timers.toMenuTime > timers.time then
            timers.toMenuTime = 0
            timers.toMenu = false
            timers.inTransition = false
        end
    elseif timers.toCredits then
        timers.toCreditsTime = timers.toCreditsTime + dt

        if timers.toCreditsTime > timers.time / 2 then
            global.inCredits = true
        end

        if timers.toCreditsTime > timers.time then
            timers.toCreditsTime = 0
            timers.toCredits = false
            timers.inTransition = false
        end
    elseif timers.resetting then
        timers.resetTime = timers.resetTime + dt
        if timers.resetTime > timers.time then
            timers.resetTime = 0
            timers.resetting = false
        end
    end
end

-- -------------------------------------------------------------

function love.draw(dt)
    if global.inGame then
        drawGame(dt)
    elseif global.inCredits then
        drawCredits(dt)
    else
        drawMenu(dt)
    end

    if timers.inTransition then
        drawTransition()
    end

    if global.debug then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print("--- Debug ---", 5, 5)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 5, 20)
        love.graphics.print("level: " .. tostring(settings.level), 5, 35)
        love.graphics.setColor(255, 255, 255, 255)
    end
end

-- -------------------------------------------------------------

function drawMenu(dt)
    love.graphics.draw(res.img.menu, 0, 0, 0, settings.scale, settings.scale)

    if button.play.isDown then
        love.graphics.draw(button.play.down, button.play.x * settings.scale, button.play.y * settings.scale, 0, settings.scale, settings.scale)
    else
        love.graphics.draw(button.play.up, button.play.x * settings.scale, button.play.y * settings.scale, 0, settings.scale, settings.scale)
    end

    if button.info.isDown then
        love.graphics.draw(button.info.down, button.info.x * settings.scale, button.info.y * settings.scale, 0, settings.scale, settings.scale)
    else
        love.graphics.draw(button.info.up, button.info.x * settings.scale, button.info.y * settings.scale, 0, settings.scale, settings.scale)
    end

    if button.exit.isDown then
        love.graphics.draw(button.exit.down, button.exit.x * settings.scale, button.exit.y * settings.scale, 0, settings.scale, settings.scale)
    else
        love.graphics.draw(button.exit.up, button.exit.x * settings.scale, button.exit.y * settings.scale, 0, settings.scale, settings.scale)
    end

    love.graphics.setColor(68, 68, 68, 255)
    love.graphics.print("Level " .. settings.level, (global.width / 2 - (res.fnt.font:getWidth("Level " .. settings.level) / 2)) * settings.scale, (global.height * 3 / 4 + 15) * settings.scale, 0, settings.scale, settings.scale)
    love.graphics.setColor(255, 255, 255, 255)
end

-- -------------------------------------------------------------

function drawCredits(dt)
    love.graphics.draw(res.img.credits, 0, 0, 0, settings.scale, settings.scale)

    if button.back.isDown then
        love.graphics.draw(button.back.down, button.back.x * settings.scale, button.back.y * settings.scale, 0, settings.scale, settings.scale)
    else
        love.graphics.draw(button.back.up, button.back.x * settings.scale, button.back.y * settings.scale, 0, settings.scale, settings.scale)
    end
end

-- -------------------------------------------------------------

function drawGame(dt)
    love.graphics.draw(res.img.game, 0, 0, 0, settings.scale, settings.scale)
    drawPaths(dt)
    love.graphics.draw(res.img.board, 0, 0, 0, settings.scale, settings.scale)
    drawMoves(dt)
    drawTokens(dt)

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

    love.graphics.setColor(68, 68, 68, 255)
    love.graphics.print("Level " .. settings.level, (57 - (res.fnt.font:getWidth("Level " .. settings.level) / 2)) * settings.scale, (global.height * 3 / 5) * settings.scale, 0, settings.scale, settings.scale)
    love.graphics.setColor(255, 255, 255, 255)
end

-- -------------------------------------------------------------

function drawTokens(dt)
    for i = 1, 5 do
        love.graphics.draw(res.img["token_" .. i], tokens[i].x * settings.scale, tokens[i].y * settings.scale, 0, settings.scale, settings.scale)
    end
end

-- -------------------------------------------------------------

function calculatePaths()
    paths = { }

    for i = 1, 5 do
        for j = i + 1, 6 do
            if levels[settings.level].paths[i][j] == 1 then
                table.insert(paths, res.img["path_" .. i .. "-" .. j])
            end
        end
    end
end

function drawPaths(dt)
    for i, img in ipairs(paths) do
        love.graphics.draw(img, 0, 0, 0, settings.scale, settings.scale)
    end
end

-- -------------------------------------------------------------

function calculateMoves()
    moves = { }
    tokens.moving = 0

    for i = 1, 6 do
        cells[i].move = false
        if levels[settings.level].paths[spots.free][i] == 1 then
            table.insert(moves, i)
            cells[i].move = true
        end
    end
end

function drawMoves(dt)
    for i, n in ipairs(moves) do
        love.graphics.draw(res.img["move_" .. n], 0, 0, 0, settings.scale, settings.scale)
    end
end

-- -------------------------------------------------------------

function checkWin()
    for i, token in ipairs(tokens) do
        if not (i == token.pos - 1) then
            return false
        end
    end

    nextLevel()
    return true
end

-- -------------------------------------------------------------

function nextLevel()
    love.filesystem.write("data.bin", table.show(settings, "settings"))
    res.sfx.yaay:setVolume(0.5)
    res.sfx.yaay:play()

    if settings.level < 40 then
        settings.level = settings.level + 1
    else
        settings.level = 1
    end

    resetLevel()

    timers.resetting = true
    resetTransition()
end

-- -------------------------------------------------------------

function previousLevel()
    if settings.level > 1 then
        settings.level = settings.level - 1
    else
        settings.level = 40
    end

    resetLevel()

    timers.resetting = true
    resetTransition()
end

-- -------------------------------------------------------------

function resetLevel()
    calculatePaths()

    for i = 2, 6 do
        tokens[levels[settings.level].pos[i]].pos = i
    end

    spots.free = 1
    spots.freeBefore = 0
    calculateMoves()
end

-- -------------------------------------------------------------

function loadLevel()
    calculatePaths()

    for i = 2, 6 do
        tokens[levels[settings.level].pos[i]].pos = i
        tokens[levels[settings.level].pos[i]].x = spots[i].x
        tokens[levels[settings.level].pos[i]].y = spots[i].y
    end

    spots.free = 1
    spots.freeBefore = 0
    calculateMoves()
end

-- -------------------------------------------------------------

function getTokenOnCell(n)
    for i, token in ipairs(tokens) do
        if token.pos == n then
            return i
        end
    end
    return 0
end

-- -------------------------------------------------------------

function resetTransition()
    for i, token in ipairs(tokens) do
        flux.to(token, 1, { x = spots[token.pos].x, y = spots[token.pos].y }):ease(global.easing)
    end
end

function startTransition()
    flux.to(transition, 0.5, { alpha = 255 }):after(transition, 0.5, { alpha = 0 })
end

function exitTransition()
    flux.to(global, 1, { volume = 0 })
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
                settings.scale = global.fullscreenScale
            else
                settings.scale = global.scaleBefore
            end
            love.window.setMode(global.width * settings.scale, global.height * settings.scale, { fullscreen = settings.fullscreen, borderless = global.borderless })
        end
    end
end

-- -------------------------------------------------------------

function love.keyreleased(k)
    if global.debug and global.inGame then
        if k == "a" then
            previousLevel()
        elseif k == "s" then
            nextLevel()
        end
    end

    if not timers.toGame and not timers.toMenu then
        -- quit the game
        if k == "escape" then
            if global.inGame or global.inCredits then
                timers.inTransition = true
                timers.toMenu = true
                startTransition()
                res.sfx.select_1:play()
            else
                res.sfx.select_0:play()
                timers.inTransition = true
                timers.exit = true
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
    elseif global.inCredits then
        if b == "l" then
            if not timers.toMenu and boxHit(x, y, button.back.x * settings.scale, button.back.y * settings.scale, button.back.width * settings.scale, button.back.height * settings.scale) then
                button.back.isDown = true
            end
        end
    else
        if b == "l" then
            if not timers.toGame and boxHit(x, y, button.play.x * settings.scale, button.play.y * settings.scale, button.play.width * settings.scale, button.play.height * settings.scale) then
                button.play.isDown = true
            end

            if not timers.toCredits and boxHit(x, y, button.info.x * settings.scale, button.info.y * settings.scale, button.info.width * settings.scale, button.info.height * settings.scale) then
                button.info.isDown = true
            end

            if not timers.exit and boxHit(x, y, button.exit.x * settings.scale, button.exit.y * settings.scale, button.exit.width * settings.scale, button.exit.height * settings.scale) then
                button.exit.isDown = true
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

            for i = 1, 6 do
                if table.contains(moves, i) and boxHit(x, y, cells[i].x * settings.scale, cells[i].y * settings.scale, cells[i].size * settings.scale, cells[i].size * settings.scale) then
                    tokens.moving = getTokenOnCell(i)
                    spots.freeBefore = spots.free
                    spots.free = tokens[tokens.moving].pos
                    tokens[tokens.moving].pos = spots.freeBefore
                    res.sfx.woosh:setVolume(0.5)
                    res.sfx.woosh:play()
                    flux.to(tokens[tokens.moving], 0.7, { x = spots[spots.freeBefore].x, y = spots[spots.freeBefore].y }):ease(global.easing):oncomplete(calculateMoves):oncomplete(checkWin)
                end
            end
        end
    elseif global.inCredits then
        if b == "l" then
            if not timers.toMenu and button.back.isDown then button.back.isDown = false end
        end
    else
        if b == "l" then
            if not timers.toGame and button.play.isDown then button.play.isDown = false end
            if not timers.toCredits and button.info.isDown then button.info.isDown = false end
            if not timers.exit and button.exit.isDown then button.exit.isDown = false end
        end
    end
end

-- -------------------------------------------------------------

function love.mousemoved(x, y, dx, dy) end

-- -------------------------------------------------------------

function love.quit()
    if settings.fullscreen then settings.scale = global.scaleBefore end
    love.filesystem.write("data.bin", table.show(settings, "settings"))
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
        res.fnt[name] = love.graphics.newFont(res.dir .. "fnt/" .. pair[1], pair[2])
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
-- Table contains

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
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
