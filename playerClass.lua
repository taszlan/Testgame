require('constants')

playerObject = {
  x = 10,
  y = 10,
  act_x = 320,
  act_y = 320,
  speed = 10
}

playerObject.__index = playerObject

function playerObject.new()
  local self = setmetatable({}, playerObject)
  return self
end

function playerObject:moveUp()
  self.y = self.y - 1	
end

function playerObject:moveDown()
    self.y = self.y + 1
end

function playerObject:moveLeft()
    self.x = self.x - 1
end

function playerObject:moveRight()
    self.x = self.x + 1
end
