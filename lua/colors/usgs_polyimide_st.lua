-- File: lua/colors/usgc_polyimide_st.lua
-- Usage: :colorscheme usgc_polyimide_st

local theme = {
  black = "#000000",
  white = "#FFFFFF",
  fl_red = "#FF0000",
  fl_green = "#00FF00",
  fl_blue = "#0000FF",
  fl_cyan = "#00FFFF",
  fl_magenta = "#FF00FF",
  fl_yellow = "#FFFF00",
  fl_orange = "#FF6600",
  maroon = "#660000",
  green = "#00A645",
  blue = "#000066",
  cyan = "#006666",
  magenta = "#660066",
  yellow = "#FFBF00",
  olive = "#666600",
  gray = "#999999",
}

local highlights = {
  -- Core UI
  Normal = { fg = theme.yellow, bg = theme.black },
  NormalFloat = { fg = theme.white, bg = theme.blue },
  FloatBorder = { fg = theme.gray, bg = theme.black },
  Cursor = { fg = theme.black, bg = theme.green },
  CursorLine = { bg = theme.fl_blue },
  CursorLineNr = { fg = theme.white, bold = true },
  LineNr = { fg = theme.fl_orange, bg = theme.black },
  SignColumn = { fg = theme.fl_orange, bg = theme.black },
  Visual = { fg = theme.fl_cyan, bg = theme.blue },
  VisualNOS = { fg = theme.fl_blue, bg = theme.gray },
  NonText = { fg = theme.gray },
  EndOfBuffer = { fg = theme.black },

  -- Status line
  StatusLine = { fg = theme.white, bg = theme.blue },
  StatusLineNC = { fg = theme.gray, bg = theme.black },
  VertSplit = { fg = theme.gray },

  -- Search
  Search = { fg = theme.black, bg = theme.fl_yellow },
  IncSearch = { fg = theme.black, bg = theme.fl_orange },

  -- Syntax (legacy, linked by default Treesitter)
  Comment = { fg = theme.gray, italic = true },
  Constant = { fg = theme.fl_magenta },
  String = { fg = theme.green },
  Character = { fg = theme.fl_orange },
  Number = { fg = theme.fl_magenta },
  Boolean = { fg = theme.fl_magenta },
  Identifier = { fg = theme.fl_cyan },
  Function = { fg = theme.fl_green, bold = true },
  Statement = { fg = theme.green },
  Keyword = { fg = theme.fl_blue, bold = true },
  PreProc = { fg = theme.fl_orange },
  Type = { fg = theme.cyan },
  Special = { fg = theme.fl_yellow },
  Error = { fg = theme.fl_red, bold = true },
  Todo = { fg = theme.magenta, bg = theme.black, bold = true },

  -- Treesitter (modern highlights)
  ["@comment"] = { fg = theme.gray, italic = true },
  ["@string"] = { fg = theme.green },
  ["@number"] = { fg = theme.fl_magenta },
  ["@function"] = { fg = theme.fl_green, bold = true },
  ["@function.builtin"] = { fg = theme.fl_cyan },
  ["@keyword"] = { fg = theme.fl_blue, bold = true },
  ["@variable"] = { fg = theme.white },
  ["@variable.builtin"] = { fg = theme.fl_orange },
  ["@type"] = { fg = theme.cyan },
  ["@constant"] = { fg = theme.fl_magenta },
  ["@parameter"] = { fg = theme.yellow },

  -- LSP
  DiagnosticError = { fg = theme.fl_red },
  DiagnosticWarn = { fg = theme.fl_orange },
  DiagnosticInfo = { fg = theme.fl_blue },
  DiagnosticHint = { fg = theme.fl_cyan },
  DiagnosticUnderlineError = { undercurl = true, sp = theme.fl_red },
  DiagnosticUnderlineWarn = { undercurl = true, sp = theme.fl_orange },
  DiagnosticUnderlineInfo = { undercurl = true, sp = theme.fl_blue },
  DiagnosticUnderlineHint = { undercurl = true, sp = theme.fl_cyan },
  LspInlayHint = { fg = theme.gray, italic = true },

  -- GitSigns
  GitSignsAdd = { fg = theme.green },
  GitSignsChange = { fg = theme.fl_blue },
  GitSignsDelete = { fg = theme.fl_red },

  -- Telescope
  TelescopeNormal = { fg = theme.white, bg = theme.black },
  TelescopeBorder = { fg = theme.gray, bg = theme.black },
  TelescopePromptNormal = { fg = theme.white, bg = theme.blue },
  TelescopePromptBorder = { fg = theme.white, bg = theme.blue },
  TelescopeSelection = { fg = theme.white, bg = theme.fl_blue },
  TelescopeMatching = { fg = theme.fl_yellow, bold = true },

  -- nvim-cmp
  CmpItemAbbr = { fg = theme.white },
  CmpItemAbbrMatch = { fg = theme.fl_yellow, bold = true },
  CmpItemKindFunction = { fg = theme.fl_green },
  CmpItemKindVariable = { fg = theme.fl_cyan },
  CmpItemKindKeyword = { fg = theme.fl_blue },

  -- NvimTree
  NvimTreeNormal = { fg = theme.white, bg = theme.black },
  NvimTreeNormalNC = { fg = theme.white, bg = theme.black },
  NvimTreeRootFolder = { fg = theme.fl_orange, bold = true },
  NvimTreeOpenedFolderName = { fg = theme.fl_blue, bold = true },
  NvimTreeExecFile = { fg = theme.fl_green, bold = true },
  NvimTreeSpecialFile = { fg = theme.fl_magenta },

  -- WhichKey
  WhichKey = { fg = theme.fl_cyan, bold = true },
  WhichKeyGroup = { fg = theme.fl_yellow },
  WhichKeyDesc = { fg = theme.white },
  WhichKeySeparator = { fg = theme.gray },
  WhichKeyFloat = { bg = theme.blue },
}

for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
