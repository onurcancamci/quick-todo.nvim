local M = {}

---Validate the options table obtained from merging defaults and user options
local function validate_opts_table()
  local opts = require("quick-todo.config").options
  local ok, err = pcall(function()
    vim.validate({
      -- Keys
      keys = { opts.keys, "table" },
      ["keys.open"] = { opts.keys.open, "string" },

      -- Window
      window = { opts.window, "table" },
      ["window.height"] = { opts.window.height, "number" },
      ["window.width"] = { opts.window.width, "number" },
      ["window.border"] = { opts.window.border, "string" },
      ["window.winblend"] = { opts.window.winblend, "number" },
    })
  end)

  if not ok then
    vim.health.error("Invalid setup options: " .. err)
  else
    vim.health.ok("opts are correctly set")
  end
end

---This function is used to check the health of the plugin
---It's called by `:checkhealth` command
M.check = function()
  vim.health.start("quick-todo.nvim health check")

  validate_opts_table()

  -- Add more checks:
  --  - check for requirements
  --  - check for Neovim options (e.g. python support)
  --  - check for other plugins required
  --  - check for LSP setup
  --  ...
end

return M
