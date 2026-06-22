return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    opts = {
      debug = {
        enabled = false,
        show_scores = false,
      },
    },
    keys = {
      {
        "<leader>fF",
        function()
          require("fff").find_files()
        end,
        desc = "FFF Find Files",
      },
      {
        "<leader>sF",
        function()
          require("fff").live_grep()
        end,
        desc = "FFF Live Grep",
      },
      {
        "<leader>sW",
        function()
          require("fff").live_grep({ query = vim.fn.expand("<cword>") })
        end,
        desc = "FFF Search Word",
      },
      {
        "<leader>sf",
        function()
          require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
        end,
        desc = "FFF Fuzzy Grep",
      },
    },
  },
}
