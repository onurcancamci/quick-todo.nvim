local quickTodo = require("quick-todo")

-- Test quick-todo.nvim with default options
describe("Default options", function()
  quickTodo.setup({})
  it("can say hello", function()
    assert.are.equal("Hello John Doe", quickTodo.hello())
  end)
  it("can say bye", function()
    assert.are.equal("Bye John Doe", quickTodo.bye())
  end)
end)

-- Test quick-todo.nvim with user defined options
describe("User defined options", function()
  quickTodo.setup({ name = "John Smith" })
  it("can say hello", function()
    assert.are.equal("Hello John Smith", quickTodo.hello())
  end)
  it("can say bye", function()
    assert.are.equal("Bye John Smith", quickTodo.bye())
  end)
end)

-- RESOURCES:
--   - https://github.com/lunarmodules/busted
--   - https://hiphish.github.io/blog/2024/01/29/testing-neovim-plugins-with-busted/
