-- game state

require("util/helper")

GameState = class("GameState")

function GameState:__init() end

function GameState:update(dt) end
function GameState:draw(dt) end
function GameState:start() end
function GameState:stop() end
function GameState:keypressed(k) end
function GameState:keyreleased(k) end
function GameState:mousepressed(x, y, button) end
function GameState:mousereleased(x, y, button) end
function GameState:mousemoved(x, y, dx, dy) end
