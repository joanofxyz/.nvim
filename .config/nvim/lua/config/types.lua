---@alias BufHook fun(bufnr: integer) A function that receives a bufnr as its sole parameter
---@alias Keybinding {mode: "n"|"v"|"i"|"x", key: string, cmd: string|function}
---@alias FloatOpts {title: string, title_pos?: "left"|"center"|"right", relative?: "editor"|"win"|"cursor"|"mouse", anchor?: "NV"|"NE"|"SW"|"SE", width?: number, height?: number, row?: number, col?: number, focusable?: boolean, border?: "none"|"single"|"double"|"rounded"|"solid"|"shadow", noautocmd?: boolean}
