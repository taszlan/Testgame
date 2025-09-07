require('constants')

triangleObject = {
  x,
  y,
  id,
  direction,
  speed = 10,
  act_x,
  act_y,
  act_angle
}

triangleObject.__index = triangleObject

function triangleObject.new(x, y, id, direction)
  local self = setmetatable({}, triangleObject)
  self.x = x
  self.y = y
  self.id = id
  self.direction = direction
  self.act_x = x*32
  self.act_y = y*32
  self.act_angle = direction
  return self
end

function triangleObject:moveUp()
  self.y = self.y - 1	
end

function triangleObject:moveDown()
  self.y = self.y + 1
end

function triangleObject:moveLeft()
  self.x = self.x - 1
end

function triangleObject:moveRight()
  self.x = self.x + 1
end