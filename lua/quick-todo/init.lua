local M = {}

local state = {
  window = -1,
  buffer = -1,
}

local function sanitize_path(path)
  return path:gsub("[/\\]", "__")
end

local function get_save_location()
  local cwd = vim.fn.getcwd()
  local data_dir = vim.fn.stdpath("data") .. "/quick-todo/"
  local file_dir = data_dir .. sanitize_path(cwd)
  local file_path = file_dir .. "/todo.md"

  vim.fn.mkdir(file_dir, "p")
  return file_path
end

local function create_window()
  if state.window == -1 or not vim.api.nvim_win_is_valid(state.window) then
    local opts = require("quick-todo.config").options or {}
    local width = math.floor(vim.o.columns * opts.window.width)
    local height = math.floor(vim.o.lines * opts.window.height)
    local winblend = opts.window.winblend or 0
    local config = {
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      border = "rounded",
      title = "Quick Todo",
      title_pos = "center",
      footer = string.format("Project: %s", vim.fn.getcwd()),
      footer_pos = "left",
    }

    local current_win = vim.api.nvim_get_current_win()
    local sign_column_value = vim.api.nvim_get_option_value("signcolumn", { win = current_win })
    local relativenumber_value = vim.api.nvim_get_option_value("relativenumber", { win = current_win })
    local number_value = vim.api.nvim_get_option_value("number", { win = current_win })

    local win = vim.api.nvim_open_win(state.buffer, true, config)
    state.window = win

    vim.wo[win].winblend = winblend
    vim.wo[win].signcolumn = sign_column_value
    vim.wo[win].number = number_value
    vim.wo[win].relativenumber = relativenumber_value
    return win
  else
    return state.window
  end
end

local function get_buffer()
  local path = get_save_location()
  if vim.fn.filereadable(path) == 0 then
    vim.fn.writefile({}, path, "s")
  end

  local bufnr = vim.fn.bufnr(path, false)
  local is_valid = bufnr > 0 and vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr)

  if not is_valid then
    -- bufnr = vim.api.nvim_create_buf(false, false)
    bufnr = vim.fn.bufnr(path, true)

    vim.api.nvim_buf_set_name(bufnr, path)
    state.buffer = bufnr

    -- just in case
    if vim.api.nvim_buf_line_count(bufnr) == 1 and vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == "" then
      local lines = vim.fn.readfile(path)
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    end

    vim.bo[bufnr].buftype = ""
    vim.bo[bufnr].buflisted = false -- not in :ls
    vim.bo[bufnr].bufhidden = "wipe" -- hide instead of wipe
    vim.bo[bufnr].filetype = "markdown"
    vim.bo[bufnr].modifiable = true
    vim.bo[bufnr].swapfile = false
    vim.bo[bufnr].readonly = false
    vim.bo[bufnr].undofile = false

    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("checktime") -- update timestamp
      vim.cmd("set nomodified") -- optional safety to clear mod flag
    end)

    vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = bufnr, silent = true })
    vim.keymap.set("n", "<C-c>", "<cmd>quit<cr>", { buffer = bufnr, silent = true })
  end

  return bufnr
end

local function actual_open_window()
  local bufnr = get_buffer()

  local win = create_window()
  vim.api.nvim_win_set_buf(win, bufnr)
end

local function close_window()
  if vim.api.nvim_win_is_valid(state.window) then
    local success = pcall(vim.api.nvim_win_hide, state.window)
    if not success then
      vim.api.nvim_win_close(state.window, false)
    end
  end
end

M.open_todo = function()
  if vim.api.nvim_win_is_valid(state.window) then
    close_window()
  else
    actual_open_window()
  end
end

---Setup the quick-todo plugin
---@param opts Options: plugin options
M.setup = function(opts)
  require("quick-todo.config").setup(opts)
  require("quick-todo.commands").setup()

  vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
      if vim.api.nvim_win_is_valid(state.window) then
        close_window()
      end
      state.window = -1
      state.buffer = -1
    end,
  })
end

return M
