io.stdout:setvbuf('no')
require('playerClass')
require('constants')
require('worldClass')
require('triangleClass')

local world = worldObject.new()

function love.load()
  score = 0

  math.randomseed(os.time())

  love.window.setMode(640, 660)
  
  -- shader additions
  startTime = love.timer.getTime()
  crtShader = love.graphics.newShader("crt.glsl")
  canvas = love.graphics.newCanvas(640, 660, { type = '2d', readable = true })

  -- load move sound
  moveSound = love.audio.newSource("sounds/moveit.mp3", "static")
end


function love.update(dt)
  world:updatePlayerActualPosition(dt)
  world:updateTrianglesActualPosition(dt)
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear(0, 0, 0, 1)

  love.graphics.setColor(0.878, 0.773, 0.157, 1)
  love.graphics.rectangle("fill", world.player.act_x, world.player.act_y, 32, 32)
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.print("SCORE: "..tostring(score), 20, 640)

  for i = 1, #world.tableOfTriangles do
    tmp = world.tableOfTriangles[i]
    love.graphics.polygon("fill",
      (tmp.act_x+16) + 16 * math.cos(math.rad(tmp.act_angle)),
      (tmp.act_y+16) + 16 * math.sin(math.rad(tmp.act_angle)),
      (tmp.act_x+16) + 16 * math.cos(math.rad(tmp.act_angle+120)),
      (tmp.act_y+16) + 16 * math.sin(math.rad(tmp.act_angle+120)),
      (tmp.act_x+16) + 16 * math.cos(math.rad(tmp.act_angle+240)),
      (tmp.act_y+16) + 16 * math.sin(math.rad(tmp.act_angle+240))
    )
  end

  for x=0, #world.map do
    for y=0, #world.map[x] do
      if world.map[x][y] == 1 then
        love.graphics.rectangle("line", x * 32, y * 32, 32, 32)
      end
    end
  end

  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1)
  crtShader:send('millis', love.timer.getTime() - startTime)
  love.graphics.setShader(crtShader)
  love.graphics.draw(canvas, 0, 0)
  love.graphics.setShader()
end


-- helper to play overlapping sound
function playMoveSound()
  local s = moveSound:clone()
  s:play()
end

function love.keypressed(key)  
  if key == "down" then
    if (world.map[world.player.x][world.player.y+1] ~= WALL) then
      world.mapMoveDown(world.player.x, world.player.y, PLAYER)
      world.player:moveDown()
      world:moveTriangles()
      playMoveSound()
    end
  elseif key == "up" then
    if (world.map[world.player.x][world.player.y-1] ~= WALL) then
      world.mapMoveUp(world.player.x, world.player.y, PLAYER)
      world.player:moveUp()
      world:moveTriangles()
      playMoveSound()
    end
  elseif key == "left" then
    if (world.map[world.player.x-1][world.player.y] ~= WALL) then
      world.mapMoveLeft(world.player.x, world.player.y, PLAYER)
      world.player:moveLeft()
      world:moveTriangles()
      playMoveSound()
    end
  elseif key == "right" then
    if (world.map[world.player.x+1][world.player.y] ~= WALL) then
      world.mapMoveRight(world.player.x, world.player.y, PLAYER)
      world.player:moveRight()     
      world:moveTriangles()
      playMoveSound()
    end
  end
end
