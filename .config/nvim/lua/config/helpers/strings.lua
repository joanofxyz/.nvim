local function split(string, sep)
  local t = {}
  for s in string:gmatch("([^" .. sep .. "]+)") do
    table.insert(t, s)
  end
  return t
end

return {split = split}
