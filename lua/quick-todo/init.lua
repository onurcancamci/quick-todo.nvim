local M = {}

---Setup the quick-todo plugin
---@param opts UserOptions: plugin options
M.setup = function(opts)
  require("quick-todo.config").setup(opts)
end

---Say hello to the user
---@return string: message to the user
M.hello = function()
  local str = "Hello " .. require("quick-todo.config").options.name
  vim.print(str)
  return str
end

---Say bye to the user
---@return string: message to the user
M.bye = function()
  local str = "Bye " .. require("quick-todo.config").options.name
  vim.print(str)
  return str
end

return M
