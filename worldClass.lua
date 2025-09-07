require('constants')
require('triangleClass')
require('playerClass')

worldObject = {
  map = {},
  tableOfTriangles = {},
  player
}

worldObject.__index = worldObject

function worldObject.new()
  local self = setmetatable({}, worldObject)
  for i = 0, 19 do 
    self.map[i] = {}
    for j = 0, 19 do
      if(i == 0 or j == 0 or i == 19 or j == 19) then
        self.map[i][j] = WALL
      else self.map[i][j] = EMPTY
      end
    end
  end
  self.player = playerObject.new()
  self.map[self.player.x][self.player.y] = PLAYER
  self:initializeTriangles()

  return self
end

function worldObject.mapMoveUp(x, y, id)
  worldObject.map[x][y] = EMPTY
  worldObject.map[x][y-1] = id
end

function worldObject.mapMoveDown(x, y, id)
  worldObject.map[x][y] = EMPTY
  worldObject.map[x][y+1] = id  
end

function worldObject.mapMoveLeft(x, y, id)
  worldObject.map[x][y] = EMPTY
  worldObject.map[x-1][y] = id    
end

function worldObject.mapMoveRight(x, y, id)
  worldObject.map[x][y] = EMPTY
  worldObject.map[x+1][y] = id    
end

function worldObject:initializeTriangles()
  for i = 1, NO_TRIANGLES do
    randX = math.random(1,18)
    randY = math.random(1,18)
    while self.map[randX][randY] ~= EMPTY or
    (randX == 9 and (randY == 9 or randY == 10 or randY == 11)) or
    (randX == 10 and (randY == 9 or randY == 10 or randY == 11)) or
    (randX == 11 and (randY == 9 or randY == 10 or randY == 11)) 
    do
      randX = math.random(1,18)
      randY = math.random(1,18)
    end
    table.insert(worldObject.tableOfTriangles, triangleObject.new(randX, randY, i + 2, randomDirection()) )
    self.map[randX][randY] = i + 2
  end
end  

function randomDirection()
  dir = math.random(1,4)
  if dir == 1 then
    return RIGHT
  elseif dir == 2 then
    return LEFT
  elseif dir == 3 then
    return UP
  elseif dir == 4 then
    return DOWN
  end  
end


function worldObject:moveTriangles()
  for k, v in pairs(self.tableOfTriangles) do
    if v.direction == UP then
      if self.map[v.x][v.y-1] == EMPTY then
        self.mapMoveUp(v.x, v.y, v.id)
        v:moveUp()
      end
      v.direction = randomDirection()
    elseif v.direction == DOWN then
      if self.map[v.x][v.y+1] == EMPTY then
        self.mapMoveDown(v.x, v.y, v.id)
        v:moveDown()
      end
      v.direction = randomDirection()
    elseif v.direction == LEFT then
      if self.map[v.x-1][v.y] == EMPTY then
        self.mapMoveLeft(v.x, v.y, v.id)
        v:moveLeft()
      end
      v.direction = randomDirection()
    elseif v.direction == RIGHT then
      if self.map[v.x+1][v.y] == EMPTY then
        self.mapMoveRight(v.x, v.y, v.id)
        v:moveRight()
      end
      v.direction = randomDirection()
    end
  end
end

function worldObject:updatePlayerActualPosition(dt)
  self.player.act_x = self.player.act_x - ((self.player.act_x - (self.player.x * 32)) * self.player.speed * dt)
  self.player.act_y = self.player.act_y - ((self.player.act_y - (self.player.y * 32)) * self.player.speed * dt)
end

function worldObject:updateTrianglesActualPosition(dt)
  for k, v in pairs(self.tableOfTriangles) do
    v.act_x = v.act_x - ((v.act_x - (v.x * 32)) * v.speed * dt)
    v.act_y = v.act_y - ((v.act_y - (v.y * 32)) * v.speed * dt)
    v.act_angle = v.act_angle - (v.act_angle - v.direction) * dt * v.speed
  end  
end