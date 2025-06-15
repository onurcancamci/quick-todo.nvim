describe("QuickTodo Config", function()
  -- Always clear the module cache before each test to isolate them
  before_each(function()
    package.loaded["quick-todo.config"] = nil
  end)

  it("applies defaults when no options are passed", function()
    local config = require("quick-todo.config")
    config.setup({})

    local opts = config.options

    assert(type(opts.keys) == "table")
    assert(opts.keys.open == "<leader>T")

    assert(type(opts.window) == "table")
    assert(type(opts.window.height) == "number")
    assert(type(opts.window.width) == "number")
    assert(opts.window.border == "rounded")
    assert(type(opts.window.winblend) == "number")
  end)

  it("overrides default options with user options", function()
    local config = require("quick-todo.config")
    config.setup({
      keys = { open = "Q" },
      window = {
        height = 0.5,
        width = 0.4,
        border = "single",
        winblend = 20,
      },
    })

    local opts = config.options

    assert(opts.keys.open == "Q")
    assert(opts.window.height == 0.5)
    assert(opts.window.width == 0.4)
    assert(opts.window.border == "single")
    assert(opts.window.winblend == 20)
  end)
end)
