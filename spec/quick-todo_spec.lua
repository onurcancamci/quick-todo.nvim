describe("QuickTodo Config", function()
  -- Always clear the module cache before each test to isolate them
  before_each(function()
    package.loaded["quick-todo.config"] = nil
  end)

  it("applies defaults when no options are passed", function()
    local config = require("quick-todo.config")
    config.setup({})

    local opts = config.options

    assert.is_table(opts.keys)
    assert.is_equal("<leader>T", opts.keys.open)

    assert.is_table(opts.window)
    assert.is_number(opts.window.height)
    assert.is_number(opts.window.width)
    assert.is_equal("rounded", opts.window.border)
    assert.is_number(opts.window.winblend)
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

    assert.is_equal("Q", opts.keys.open)
    assert.is_equal(0.5, opts.window.height)
    assert.is_equal(0.4, opts.window.width)
    assert.is_equal("single", opts.window.border)
    assert.is_equal(20, opts.window.winblend)
  end)
end)
