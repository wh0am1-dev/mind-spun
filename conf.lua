function love.conf(t)
    t.title = "Mind-Spun"
    t.author = "Neko250"
    t.identity = "mindspun"
    t.version = "0.9.2"
    t.console = false
    t.release = false
    t.window.width = 640
    t.window.height = 480
    t.window.fullscreen = false
    t.window.vsync = true
    t.window.fsaa = 4

    t.modules.joystick = false
    t.modules.audio = true
    t.modules.keyboard = true
    t.modules.event = true
    t.modules.image = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.mouse = true
    t.modules.sound = true
    t.modules.physics = false
end
