return {
  "karb94/neoscroll.nvim",
  event = "WinScrolled",
  config = function()
    require("neoscroll").setup {
      hide_cursor = false,
      stop_eof = true,
      respect_scrolloff = false,
      easing_function = "quadratic",
    }
  end,
}
