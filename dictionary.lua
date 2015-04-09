Dictionary = Class('Dictionary')

function Dictionary:initialize()
  local file = 'lib/dictionary.txt'
  self.dict = {}
  self.length = 0
  for line in io.lines(file) do
    self.length = self.length + 1
    self.dict[self.length] = line
  end
  print('dict is ' .. self.length)
end

function Dictionary:generateName()
  local n1 = math.random(1, self.length)
  local n2 = math.random(1, self.length)
  return self:firstToUpper(self.dict[n1]) .. ' ' .. self:firstToUpper(self.dict[n2])
end

function Dictionary:firstToUpper(str)
  return (str:gsub("^%l", string.upper))
end

return Dictionary
