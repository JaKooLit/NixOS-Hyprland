local comment = require("Comment")

local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

-- enable comment
comment.setup({
  -- for commenting tsx, jsx, svelte, html files
  pre_hook = ts_context_commentstring.create_pre_hook(),
})
