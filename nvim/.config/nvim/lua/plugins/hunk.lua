local function open_hunk(args)
  if vim.fn.executable("hunk") ~= 1 then
    vim.notify("Install Hunk to review diffs: https://hunk.dev", vim.log.levels.ERROR)
    return
  end

  local cwd = vim.fs.root(LazyVim.root(), ".git")
  if not cwd then
    vim.notify("Hunk requires a Git repository", vim.log.levels.WARN)
    return
  end

  local command = { "hunk" }
  vim.list_extend(command, args)
  if vim.tbl_contains({ "diff", "show", "log", "patch", "pager" }, args[1]) then
    table.insert(command, 3, "--mode")
    table.insert(command, 4, "split")
  end
  Snacks.terminal(command, {
    cwd = cwd,
    win = {
      style = "float",
      width = 0,
      height = 0,
      border = "none",
      keys = { term_normal = false },
    },
  })
end

vim.api.nvim_create_user_command("Hunk", function(opts)
  open_hunk(#opts.fargs > 0 and opts.fargs or { "diff" })
end, {
  nargs = "*",
  desc = "Review diffs with Hunk",
  complete = function()
    return { "diff", "diff --staged", "diff --watch", "show", "log" }
  end,
})

return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>gd",
      function()
        open_hunk({ "diff" })
      end,
      desc = "Hunk Diff",
    },
    {
      "<leader>gD",
      function()
        open_hunk({ "diff", "--staged" })
      end,
      desc = "Hunk Staged Diff",
    },
    {
      "<leader>gW",
      function()
        open_hunk({ "diff", "--watch" })
      end,
      desc = "Hunk Watch Diff",
    },
    {
      "<leader>gH",
      function()
        open_hunk({ "log" })
      end,
      desc = "Hunk History",
    },
  },
}
