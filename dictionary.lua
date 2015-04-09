Dictionary = Class('Dictionary')

function Dictionary:initialize()
  file = 'lib/dictionary.txt'
  self.dict = {}
  self.length = 0
  for line in io.lines(file) do
    self.length = self.length + 1
    self.dict[self.length] = line
  end
  print('dict is ' .. self.length)
end

function Dictionary:get()
  return self.dict
end

function Dictionary:dictLength()
  return self.length
end

return Dictionary
